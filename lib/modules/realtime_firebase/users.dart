import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting


class _User {
   String uid;
   String code;
   String company;
   String email;
   String fullName;
   String password;
   String phone;
   bool mailMe;

  _User({
    required this.uid,
    required this.code,
    required this.company,
    required this.email,
    required this.fullName,
    required this.password,
    required this.phone,
    required this.mailMe,
  });
}

class Price {
  int controllerPrice;
  //int dayPrice;
  //int gamePrice;
  int psPrice;

  Price({
    required this.controllerPrice,
    //required this.dayPrice,
    //required this.gamePrice,
    required this.psPrice,
   });
}

class Rental {
   String startDate;
   String endDate;
   late  List<String> games;
   int controller;
   String pickupStation;
   double price;

  Rental({
    required this.startDate,
    required this.endDate,
    required this.games,
    required this.controller,
    required this.pickupStation,
    required this.price,
});

}

late Rental rental;
_User? user;
late Price prices;

final database = FirebaseDatabase.instance.ref();
//add user to realtime database
Future<void> addUser(String username, String email, String password, String phone, String company,String companyCode, bool mailMe) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  database.child('Users').child(uid).set({
    "FullName": username,
    "E-Mail": email,
    "Password": password,
    "Phone": phone,
    "Company":company,
    "Code": companyCode,
    "mailMe": !mailMe,
  });
}

//add User Rental to realtime database
Future<void> addUserRental(DateTime startDate, DateTime endDate, List<String> games, int controller, String pickupStation, double price) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // Format the current date as "yyyyMMddHHmmss" without spaces or periods
  String currentDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

/*  // Update game counts
  for (String gameName in games) {
    await decrementGameCount(gameName);
  }
  // Update SpareController count if user rents more than 2 controllers
  if (controller > 2) {
    await decrementSpareController(controller - 2);
  }*/

  database.child('Rentals').child(uid).child(currentDate).set({
    "Start Date": startDate.toString(),
    "End Date": endDate.toString(),
    "Games": games,
    "Controller Count": controller,
    "Pickup Station":pickupStation,
    "Price": price,
  });
}

/*
// Function to decrement game count
Future<void> decrementGameCount(String gameName) async {
  DatabaseEvent gameSnapshot = await database.child('Games').child(gameName).child('count').once();
  int currentCount = gameSnapshot.snapshot.value as int;
  await database.child('Games').child(gameName).update({'count': currentCount - 1});
}

// Function to decrement SpareController count
Future<void> decrementSpareController(int count) async {
  DatabaseEvent spareControllerSnapshot = await database.child('SpareController').once();
  if (spareControllerSnapshot.snapshot.value != null) {
    int currentCount = spareControllerSnapshot.snapshot.value as int;
    if (currentCount >= count) {
      await database.child('SpareController').set(currentCount - count);
    } else {
      // Handle case where SpareController count is insufficient
      //print('Error: Insufficient SpareController count');
    }
  } else {
    // Handle case where SpareController count does not exist
    //print('Error: SpareController count not found in database');
  }
}
*/

Future<void> getUserData() async {
  // Get the current user from Firebase Authentication
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // Use the current user's UID to retrieve data from the database
    DatabaseReference userRef =
    FirebaseDatabase.instance.ref().child('Users').child(currentUser.uid);

    // Get the data snapshot from the database
    DatabaseEvent databaseEvent = await userRef.once();
    // Extract user data from the snapshot
    Map<dynamic, dynamic> userData = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
    //print(userData);

    // Create a User object using the retrieved data
    user = _User(
      uid: currentUser.uid,
      code: userData['Code'],
      company: userData['Company'],
      email: userData['E-Mail'],
      fullName: userData['FullName'],
      password: userData['Password'],
      phone: userData['Phone'],
      mailMe: userData['mailMe'],
    );
  }
}

void getPricesData() async {
  // Use the current user's UID to retrieve data from the database
  DatabaseReference pricesRef =
  FirebaseDatabase.instance.ref().child('Prices');

  // Get the data snapshot from the database
  DatabaseEvent databaseEvent = await pricesRef.once();
  // Extract user data from the snapshot
  Map<dynamic, dynamic> priceData = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
  //print(priceData);

  // Create a User object using the retrieved data
  prices = Price(
    controllerPrice: priceData['Controller'],
    //dayPrice: priceData['Day'],
    //gamePrice: priceData['Game'],
    psPrice: priceData['PS'],
    );
}