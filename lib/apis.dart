  import 'dart:convert';
  import 'dart:io';
  import 'package:Sovarvo/modules/realtime_firebase/users.dart';
  import 'package:Sovarvo/services/notification.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:http/http.dart';
  import 'package:googleapis_auth/auth_io.dart'; // Add googleapis_auth dependency in pubspec.yaml

  //for accessing firebase messaging (Push Notification)
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //for getting firebase messaging token
  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        //print(t);
        // Write the token to Firebase Realtime Database
        addAdminsToken(t);
      }
    });
  }
  //for sending push notification
  Future<void> sendPushNotification(List<String> tokens, String message) async {
    try {
      String accessToken = await getAccessToken();
      for (String token in tokens) {
        final body = {
          "message": {
            "token": token, // Corrected key name, removed extra spaces
            "notification": {
              "title": "Sovarvo",
              "body": message, // The message body sent in the notification
            }
          }
        };

        var response = await post(
          Uri.parse("https://fcm.googleapis.com/v1/projects/sovarvo-40099/messages:send"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        );

        print('Response status for token $token: ${response.statusCode}');
        print('Response body for token $token: ${response.body}');

        // Display a local notification
        await NotificationService.showNotification(
          title: "Sovarvo",
          body: "Sovarvo has got new rental",
        );
      }
    } catch (e) {
      print('\nsendPushNotification Error: $e');
    }
  }
  //add Admins Token to firebase
  Future<void> addAdminsToken(String t) async {
    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('AdminsToken');

    try {
      // Retrieve all tokens from the database
      DatabaseEvent event = await tokenRef.once();
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Check if the token already exists
        bool tokenExists = data.values.any((value) => value != null && value['token'] == t);

        if (tokenExists) {
          print('Token already exists in the database: $t');
        } else {
          // If the token doesn't exist, add it to the database
          await tokenRef.push().set({'token': t});
          print('Firebase Messaging token added to the database: $t');
        }
      } else {
        // If there are no tokens in the database, add the new token directly
        await tokenRef.push().set({'token': t});
        print('Firebase Messaging token added to the database: $t');
      }
    } catch (error) {
      print('Failed to add token to the database: $error');
    }
  }
  //get all Admins token from firebase
  Future<List<String>> getAllAdminsTokens() async {
    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('AdminsToken');
    List<String> tokens = [];

    // Retrieve all tokens from the database
    DatabaseEvent event = await tokenRef.once();

    Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?; // Cast with null safety

    if (data != null) {
      // Iterate through each token and add it to the list
      data.forEach((key, value) {
        if (value != null && value['token'] != null) {
          tokens.add(value['token']);
        }
      });
    }

    return tokens;
  }

  //for sending push notification
  Future<void> sendPushNotificationForRequestUserNotifyWhenAvailable(List<String> tokens, String gameName) async {
    try {
      String accessToken = await getAccessToken(); // Replace the legacy key with OAuth2 access token

      for (String token in tokens) {
        final body = {
          "message": {
            "token": token, // Correct key name for FCM v1
            "notification": {
              "title": "Sovarvo",
              "body": "Please Notify Me When $gameName is Available",
            }
          }
        };

        var response = await post(
          Uri.parse("https://fcm.googleapis.com/v1/projects/sovarvo-40099/messages:send"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken', // Use Bearer token for OAuth 2.0
          },
          body: jsonEncode(body),
        );

        print('Response status for token $token: ${response.statusCode}');
        print('Response body for token $token: ${response.body}');

        // Display a local notification
        await NotificationService.showNotification(
          title: "Sovarvo",
          body: "Please Notify Me When $gameName is Available",
        );
      }

      // Adding notification to your database (assuming addNotifyUser is implemented elsewhere)
      DateTime now = DateTime.now();
      addNotifyUser(user!.fullName, user!.email, user!.phone, gameName, now.toString());

    } catch (e) {
      print('\nsendPushNotification Error: $e');
    }
  }

  Future<String> getAccessToken() async {
    var accountCredentials = new ServiceAccountCredentials.fromJson(r'''
    {
    "type": "service_account",
    "project_id": "sovarvo-40099",
    "private_key_id": "e879de342ddc875a92cf80e8203b9230c312efc6",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCa2JYv9gUw02xs\nxxNXLVgEmMfF8HG4BQ6Phx4WoEFo19QVYZueIeqlDpcJ6uEz7z7XROfIGG9D4AKr\np2YGd6HDYT815/T8q5nLxncULKZQhaqo3cJjE3q2GJcYtc0BXDLp15A7+IdTkVAT\n8IWJAo1e8r8q0RZsMCOCwJhDIKrEx8ZjjGCJncDAtaVyHhqz4irSEjfF5hIj4z0D\niznnNbxkL+DyLvKpR29wuQZR/WqUH1E1tBGOfAaJt8fHZzC8uW6e/vZrjMIjvSMu\ni7XyeuR+iy54MJMWTZOdeuNlLq3okvWhjiHqEKdqevIY1Aws4RkLmbyR+nDzqnIg\niY0I9ptJAgMBAAECggEAGuL7pQVHXnR/kZ25hnwZmea7XWvEGytJnXNdLpmR8fXz\n3eiOYFVMTG+tmyu9AcsLcs6EnnJbs4HshMiyxvGz1VyH4MDPgaX8NO1XlNmx4S5s\ndRjYXWKu/npjlgdPOuq67m6fHUKooMKNEIFFdoZKbM+ikPkwNwXezJ/LcHB2Jmey\nh5V0CW07T6/YD46S/nJfje9jvYLgd//Bgdq8JSnbDGAnpicCX3SPo3KHppCS5Gd3\nBqYX2E7g1ISFOa4u3/mz+ta2vEeOFDkwqXbDh75Y29ykiIYC0McjwG2asJJ1J814\nOzOVLYfTfo6nhpBFeBs1/zcBJqsJk5WSXdtzFgNuWQKBgQDU1vX/mLMfjtdG219F\n8ZR4VT7BWa8q24Mp98rfnlyCVRs0dsqz8T/gfkTpOVdeCa0M2oX1D4S5TolSK+i5\nWeNnw5NcjAdD6b5hYDyQlIMkGEK/CcBJeRBZuds80lqz/JLrYG3J8l0gnOlpNlla\nBo07YkbbxEXk6jioO/2pro48JQKBgQC6Pwfh7ZHaTeJ4NBVll3NSn2eQoit/hRxt\nT54/cssd3Y+pfomcfEexrn+ye5hIM8gMUIlbjl8E5U3ZElK1kCdXe+U6LDpyluwq\ni+xi090rZl92gLo0KD8jPqusJhOAY7DC5C+Tl55ESH9vMEywi0EoWg6U3MYT3lw0\nSsCqmFcnVQKBgQCmwlWzkVym2S/qoG6hSopdTc0BiNcp6Rt3gmI9msI4i53pGTnw\nipDVv5kWcor1bvdbHsveGe6Pke0dqLGKp9b4sc9/r2bx2u4DNXe+f93QJgIF1AoI\nhwY8htYzbU0LwFUMfl0G4RH+P3LRsHeJhaCaaoHCJqHsnWcOyRISJGXk0QKBgQCx\naHb+u8jyNLxkGeDD2+crLdJ+ECv1FXvFmFC6SYO3mCRPpMw6dpvoYbsb7eVZ6ZFG\nQbUFtHFIfZCRFIYakw0WpVrt9dFa8+5UfOKYJQ4JWEPY4rf8FNZHoVvv6HktFEj8\n7FVxdrx4eMKCzHRQuuU/JcG8BSzdIjOcUBSErAZg3QKBgDVLrUCBQuDGT7huzqBC\nGhlCbMNpfZrs6gqnmRenM3bFNVNTUbotWOQcQGxotK9apMOGPBfdwig4wIa1R6gt\nD/jvqaDYuyjdaExG2gjRdypUixs/LOS0KNs9HE2fhG5K5tnR49kabwBCqO9p7FK6\n7gNUWEhInIIX3QDzNad9BzOa\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-ay846@sovarvo-40099.iam.gserviceaccount.com",
    "client_id": "110801109704152804803",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ay846%40sovarvo-40099.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  } 
    ''');

    var scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

    var client = Client();
    AccessCredentials credentials = await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        scopes,
        client
    );

    return credentials.accessToken.data;
  }
