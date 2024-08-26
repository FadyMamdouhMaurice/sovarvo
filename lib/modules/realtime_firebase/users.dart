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

Future<void> addUserRentalVideoGames(List<String> games, String type, String deliveryType, int discount, String address, int totalPrice) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // Format the current date as "yyyyMMddHHmmss" without spaces or periods
  String currentDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  database.child('Rentals Video Games').child(uid).child(currentDate).set({
    "Games": games,
    "Delivery Type": deliveryType,
    "discount": discount,
    "Address": address,
    "Total Price": totalPrice,
  });

}

Future<void> addUserAddress(String newAddress) async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;
    DatabaseReference userRef = database.child('Users').child(uid).child('Addresses');

    DataSnapshot snapshot = await userRef.get();
    List<dynamic> addresses = [];

    if (snapshot.exists) {
      // If there are existing addresses, add them to the list
      addresses = List.from(snapshot.value as List<dynamic>);
    }

    // Add the new address to the list
    addresses.add(newAddress);

    // Update the list in Firebase
    await userRef.set(addresses);
  } else {
    // Handle the case where the user is not signed in
    print('No user is signed in.');
  }
}

Future<List<Map<String, String>>> fetchAddresses() async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference userRef = database.child('Users').child(uid).child('Addresses');
  DatabaseEvent event = await userRef.once();

  List<Map<String, String>> fetchedAddresses = [];
  final data = event.snapshot.value;
  if (data != null && data is List<dynamic>) {
    for (var value in data) {
      if (value is String) {
        List<String> parts = value.split(',').map((part) => part.trim()).toList();
        if (parts.length == 3) {
          fetchedAddresses.add({
            'city': parts[0],
            'street': parts[1],
            'landmark': parts[2],
          });
        }
      }
    }
  }
  return fetchedAddresses;
}



Future<void> addNotifyUser(String username, String email, String phone, String gameName, String date) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // Reference to your Firebase database node where orders will be stored
  DatabaseReference notifyRef =
  FirebaseDatabase.instance.ref().child('Notify Me When Available').child(uid);

  // Generate a new key for the order
  String? notifyId = notifyRef.push().key;

  database.child('Notify Me When Available').child(uid).child(notifyId!).set({
    "FullName": username,
    "E-Mail": email,
    "Phone": phone,
    "Game": gameName,
    "requestedDate": date,
  });
}


Future<List<Map<String, dynamic>>> getNotifyUser() async {
  DatabaseReference notifyRef = FirebaseDatabase.instance.ref().child('Notify Me When Available');

  DataSnapshot snapshot = await notifyRef.get();

  if (snapshot.exists) {
    List<Map<String, dynamic>> notifyList = [];
    for (var user in snapshot.children) {
      for (var notify in user.children) {

        Map<String, dynamic> notifyData = {
          "FullName": notify.child("FullName").value,
          "E-Mail": notify.child("E-Mail").value,
          "Phone": notify.child("Phone").value,
          "Game": notify.child("Game").value,
          "requestedDate": notify.child("requestedDate").value,
        };
        notifyList.add(notifyData);
      }
    }
    // Sort the list by requestedDate
    notifyList.sort((a, b) {
      DateTime dateA = DateTime.parse(b["requestedDate"]);
      DateTime dateB = DateTime.parse(a["requestedDate"]);
      return dateA.compareTo(dateB);
    });

    return notifyList;
  } else {
    return [];
  }
}


Future<List<Map<String, dynamic>>> getOrders() async {
  final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Video Games Orders');

  DataSnapshot snapshot = await ordersRef.get();
  if (snapshot.value == null) {
    return [];
  }

  Map<dynamic, dynamic> ordersData = snapshot.value as Map<dynamic, dynamic>;
  List<Map<String, dynamic>> ordersList = [];

  ordersData.forEach((userId, userOrders) {
    Map<dynamic, dynamic> userOrdersMap = userOrders as Map<dynamic, dynamic>;
    userOrdersMap.forEach((orderId, order) {
      DateTime requestedTime = DateTime.parse(order['Requested Time']);

      ordersList.add({
        'userId': userId,
        'orderId': orderId,
        'customerInfo': order['Customer Info'],
        'requestedTime': requestedTime,
        'cartItems': order['cartItems'],
        'deliveryType': order['deliveryType'],
        'selectedAddress': order['selectedAddress'],
        'selectedWay': order['selectedWay'],
        'totalPrice': order['totalPrice'],
        'Requested Time':order['Requested Time'],
      });
    });
  });

  // Sort orders by requested time
  ordersList.sort((a, b) => (b['requestedTime'] as DateTime).compareTo(a['requestedTime'] as DateTime));

  return ordersList;
}
/*
Future<List<Map<String, dynamic>>> getOrders() async {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Video Games Orders');

  DataSnapshot snapshot = await ordersRef.get();

  if (snapshot.exists) {
    List<Map<String, dynamic>> orderList = [];
    for (var userOrders in snapshot.children) {
      for (var order in userOrders.children) {
        Map<dynamic, dynamic> orderDataDynamic = order.value as Map<dynamic, dynamic>;
        Map<String, dynamic> orderData = orderDataDynamic.map((key, value) => MapEntry(key.toString(), value));
        orderList.add(orderData);
      }
    }
    return orderList;
  } else {
    return [];
  }
}
*/

/*
Future<List<Map<String, String>>> getUserAddresses() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    String uid = currentUser.uid;
    DatabaseReference userRef = database.child('Users').child(uid).child('Addresses');

    DataSnapshot snapshot = await userRef.get();
    List<Map<String, String>> addresses = [];

    if (snapshot.exists) {
      List<String> addressList = List<String>.from(snapshot.value as List<dynamic>);

      // Convert each address string to a map with a key
      addresses = addressList.map((address) => {'address': address}).toList();
    }
    return addresses;
  } else {
    // Handle the case where the user is not signed in
    print('No user is signed in.');
    return []; // Return an empty list or handle the absence of user data as needed
  }
}
*/


/*
Future<List<Map<String, dynamic>>> fetchUserAddresses() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, String>> addresses = []; // List to store addresses

  if (currentUser != null) {
    String uid = currentUser.uid;
    DatabaseReference userAddressesRef = database.child('Users').child(uid).child('Addresses');

    userAddressesRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        List<dynamic> fetchedAddresses = databaseEvent.snapshot.value as List<dynamic>;

        addresses = fetchedAddresses.map((address) => {
          'street': address['street'] ?? '',
          'city': address['city'] ?? '',
          'landmark': address['landmark'] ?? ''
        }).toList() as List<Map<String, String>>;
      }
    }).catchError((error) {
      // Handle error
    });
  }
  return addresses;
}
*/
