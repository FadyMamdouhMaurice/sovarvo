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
