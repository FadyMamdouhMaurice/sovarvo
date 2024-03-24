import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RentalDetailsScreen extends StatefulWidget {
  const RentalDetailsScreen({super.key});

  @override
  _RentalDetailsScreenState createState() => _RentalDetailsScreenState();
}

class _RentalDetailsScreenState extends State<RentalDetailsScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? usersRentals;
  Map<String, int> rentalsCount = {};
  Map<String, int> upcomingRentalsCount = {};

  @override
  void initState() {
    super.initState();
    _getRentals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Rental Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff8F3D96),
      ),
      body: usersRentals == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usersRentals!.length,
              itemBuilder: (context, userIndex) {
                var userKey = usersRentals!.keys.elementAt(userIndex);
                var userRentals = usersRentals![userKey];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("User ID: $userKey",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                    ),
          */
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _getUserInfo(userKey),
                            child: Text("Show User Info",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height * 0.02)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
                              Text("Number of Rentals: ${rentalsCount[userKey]}", textAlign: TextAlign.center),
                              SizedBox(height: 10,),
                              Text(
                                  "Number of Upcoming Rentals: ${upcomingRentalsCount[userKey]}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userRentals.length,
                      itemBuilder: (context, rentalIndex) {
                        var rentalKey = userRentals.keys.elementAt(rentalIndex);
                        var rental = userRentals[rentalKey];
                        DateTime startDate =
                            DateTime.parse(rental["Start Date"]);
                        if (_isUpcomingRental(startDate)) {
                          String formattedDate = DateFormat.yMMMMd()
                              .add_jm()
                              .format(_parseRentalId(
                                  rentalKey)); // Format as desired
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              color: const Color(0xff8F3D96),
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text("Rental Date: $formattedDate", style: const TextStyle( color: Colors.white),),
                                    const Expanded(child: SizedBox()),
                                    Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            _cancelRental(userKey, rentalKey);
                                          },
                                          icon: const Icon(Icons.delete_forever),
                                          color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // Display formatted date
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start Date: ${rental["Start Date"]}", style: const TextStyle( color: Colors.white),),
                                    Text("End Date: ${rental["End Date"]}", style: const TextStyle( color: Colors.white),),
                                    Text("Games: ${rental["Games"]}", style: const TextStyle( color: Colors.white),),
                                    Text(
                                        "Pickup Station: ${rental["Pickup Station"]}", style: const TextStyle( color: Colors.white),),
                                    Text(
                                        "Controller Count: ${rental["Controller Count"]}", style: const TextStyle( color: Colors.white),),
                                    Text("Price: ${rental["Price"]}", style: const TextStyle( color: Colors.white),),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(); // Skip past rentals
                        }
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }

  void _getRentals() {
    databaseReference.child("Rentals").once().then((DatabaseEvent event) {
      final dynamic value = event.snapshot.value;
      if (value != null && value is Map<Object?, Object?>) {
        usersRentals = {};
        value.forEach((key, dynamic val) {
          if (key is String) {
            usersRentals![key] = val;
          } else {
            // Handle the case when key is not a string
            // For example, convert key to a string or skip this key
          }
        });
        _calculateRentalCounts();
      } else {
        // Handle the case when data is null or not of expected type
        usersRentals = {};
      }
      setState(() {

      });
    });
  }

  void _getUserInfo(String userId) {
    databaseReference
        .child("Users")
        .child(userId)
        .once()
        .then((DatabaseEvent event) {
      final Object? userData = event.snapshot.value;
      if (userData != null && userData is Map<Object?, Object?>) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("User Information",
                  style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${userData["FullName"]}"),
                    Text("Email: ${userData["E-Mail"]}"),
                    Text("Phone: ${userData["Phone"]}"),
                    Text("Company: ${userData["Company"]}"),
                    Text("Code: ${userData["Code"]}"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: _buildUserInformation(userData)));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    'User information copied to clipboard')));
                          },
                          child: Text('Copy Information',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Handle the case when user data is null or not of expected type
      }
    });
  }

  String _buildUserInformation(Map<Object?, Object?> userData) {
    return "Name: ${userData["FullName"]}, Email: ${userData["E-Mail"]}, Phone: ${userData["Phone"]}";
  }

  bool _isUpcomingRental(DateTime startDate) {
    DateTime currentDate = DateTime.now();
    DateTime upcomingDate = currentDate.add(Duration(days: -1));
    return startDate.isAfter(upcomingDate);
  }

  DateTime _parseRentalId(String rentalId) {
    int year = int.parse(rentalId.substring(0, 4));
    int month = int.parse(rentalId.substring(4, 6));
    int day = int.parse(rentalId.substring(6, 8));
    int hour = int.parse(rentalId.substring(8, 10));
    int minute = int.parse(rentalId.substring(10, 12));
    int second = int.parse(rentalId.substring(12, 14));
    return DateTime(year, month, day, hour, minute, second);
  }

  void _calculateRentalCounts() {
    usersRentals!.forEach((userId, userRentals) {
      int rentals = userRentals.length;
      int upcomingRentals = userRentals.values.where((rental) {
        DateTime startDate = DateTime.parse(rental["Start Date"]);
        return startDate.isAfter(DateTime.now());
      }).length;
      rentalsCount[userId] = rentals;
      upcomingRentalsCount[userId] = upcomingRentals;
    });
  }

  void _cancelRental(String userId, String rentalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Cancelation", style: TextStyle(color: Colors.black)),
          content: const Text("Are you sure you want to cancel this rental?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                _performCancelRental(userId, rentalId); // Proceed with cancelation
              },
              child: Text("Yes", style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02
              )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: Text("No", style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02
              )),
            ),
          ],
        );
      },
    );
  }

  void _performCancelRental(String userId, String rentalId) {
    databaseReference
        .child("Rentals")
        .child(userId)
        .child(rentalId)
        .remove()
        .then((_) {
      setState(() {
        // Remove the rental from the local data
        usersRentals![userId]!.remove(rentalId);
        // Recalculate rental counts
        _calculateRentalCounts();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Rental canceled successfully."),
      ));
    }).catchError((error) {
      //print("Failed to cancel rental: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to cancel rental."),
      ));
    });
  }

}
