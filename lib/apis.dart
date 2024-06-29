import 'dart:convert';
import 'dart:io';
import 'package:Sovarvo/services/notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';



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
Future<void> sendPushNotification(List<String> tokens) async {
  try {
    for (String token in tokens) {
      final body = {
        "to": token,
        "notification": {
          "title": "Sovarvo", //our name should be sent
          "body": "Sovarvo has got new rental",
        },
      };

      var response = await post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
          'key=AAAANL8FLBg:APA91bFZA-QhnqtXTxNptzInFrjyUQ5GNzBTQBAOHiUQ75XOppPpMiKpwT8o4TqrRVjc-iKhtmkh-DNA28FKUYoKiHqolovm8oe6ZWKbaqE5mYVRUC9cN9enKhqcWcR1wZcU_P5JttEW'
        },
        body: jsonEncode(body),
      );

      print('Response status for token $token: ${response.statusCode}');
      print('Response body for token $token: ${response.body}');
      // Display a local notification
      await NotificationService.showNotification(title: "Sovarvo", body: "Sovarvo has got new rental");
    }
  } catch (e) {
    print('\nsendPushNotificationE: $e');
  }
}
//add Admins Token to firebase
Future<void> addAdminsToken(String t) async {
  DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('AdminsToken');

  // Retrieve all tokens from the database
  DatabaseEvent event = await tokenRef.once();
  Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

  if (data != null) {
    // Check if the new token already exists among the existing tokens
    bool tokenExists = false;
    data.forEach((key, value) {
      if (value != null && value['token'] == t) {
        tokenExists = true;
        print('Token already exists in the database: $t');
        return; // Exit the loop early if the token is found
      }
    });

    // If the token doesn't exist, add it to the database
    if (!tokenExists) {
      tokenRef.push().set({'token': t}).then((_) {
        print('Firebase Messaging token added to the database: $t');
      }).catchError((error) {
        print('Failed to add token to the database: $error');
      });
    }
  } else {
    // If there are no tokens in the database, add the new token directly
    tokenRef.push().set({'token': t}).then((_) {
      print('Firebase Messaging token added to the database: $t');
    }).catchError((error) {
      print('Failed to add token to the database: $error');
    });
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

/*
const clienId = "891557376496-6i06l4dcnih0vaf07am12gbgjpdugkld.apps.googleusercontent.com";
const clientSecret = "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";
const scope = [dr.DriveApi];
class GoogleDrive {
  final storage = SecureStorage();

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {

    //Get Credentials
    var credentials = await storage.getCredentials();
    if(credentials == null){

    var authClient = await clientViaUserConsent(ClientId(clienId, clientSecret), scope.cast<String>(), (url){
      //open Url in Browser
      launchUrl(url as Uri);
    });
    return authClient;
    } else {
      return authenticatedClient(http.Client(), AccessCredentials(
      AccessToken(credentials['type'],credentials['data'],DateTime.parse(credentials['expiry'])), credentials['refreshToken'], scope.cast<String>()));
    }
  }

  // Upload File
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = dr.DriveApi(client);

    var response = await drive.files.create(
      dr.File()..name = p.basename(file.absolute.path),
      uploadMedia: dr.Media(file.openRead(), file.lengthSync()));
    print(response.toJson());
  }
}*/