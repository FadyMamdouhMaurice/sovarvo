/*
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void _showAddAddressDialog(BuildContext context, GlobalKey<FormState> formKey,
    TextEditingController streetController, TextEditingController cityController, TextEditingController landmarkController, List<Map<String, String>> addresses, ValueChanged<String?> onStationSelected, ValueChanged<int> onAddressChanged) {
  // Your implementation of _showAddAddressDialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Address', style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.012,
        )),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'City*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the city';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: streetController,
                    decoration: InputDecoration(
                      labelText: 'Full Address*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: landmarkController,
                    decoration: InputDecoration(
                      labelText: 'Nearest Landmark (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add', style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.01,
            )),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String street = streetController.text;
                String city = cityController.text;
                String landmark = landmarkController.text;
                String combinedAddress = '$street, $city, $landmark';

                */
/*setState(() {
                  addresses.add({
                    'street': street,
                    'city': city,
                    'landmark': landmark
                  });
                });*//*

                addUserAddress(combinedAddress);

                streetController.clear();
                cityController.clear();
                landmarkController.clear();

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

void fetchPickupStations(Function(List<String>) setStationItems) {
  DatabaseReference pickupStationsRef = FirebaseDatabase.instance.ref().child('Pickup Stations Video Games');
  pickupStationsRef.once().then((DatabaseEvent databaseEvent) {
    if (databaseEvent.snapshot.value != null) {
      Map<dynamic, dynamic> pickupStationsData = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
      List<String> stationItems = pickupStationsData.values.cast<String>().toList();
      setStationItems(stationItems);
    }
  }).catchError((error) {
    // Handle error
  });
}

void getDiscountDeliveryPrice(DatabaseReference databaseReference, Function(int) setDiscountDeliveryPrice) {
  databaseReference.child("Discount Delivery Price").once().then((DatabaseEvent event) {
    int discountDeliveryPrice = (event.snapshot.value ?? 0) as int;
    setDiscountDeliveryPrice(discountDeliveryPrice);
  });
}*/
