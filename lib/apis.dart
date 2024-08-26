import 'dart:convert';
import 'dart:io';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
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
Future<void> sendPushNotification(List<String> tokens, String message) async {
  try {
    for (String token in tokens) {
      final body = {
        "to": token,
        "notification": {
          "title": "Sovarvo", //our name should be sent
          //"body": "Sovarvo has got new rental",
          "body": message,
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

//for sending push notification
Future<void> sendPushNotificationForRequestUserNotifyWhenAvailable(List<String> tokens, String gameName) async {
  try {
    for (String token in tokens) {
      final body = {
        "to": token,
        "notification": {
          "title": "Sovarvo", //our name should be sent
          "body": "Please Notify Me When $gameName is Available",
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
      await NotificationService.showNotification(title: "Sovarvo", body: "Please Notify Me When $gameName is Available",
      );
    }
    DateTime now = DateTime.now();
    addNotifyUser(user!.fullName,user!.email, user!.phone, gameName, now.toString());
  } catch (e) {
    print('\nsendPushNotificationE: $e');
  }
}