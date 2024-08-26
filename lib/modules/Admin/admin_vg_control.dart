import 'package:Sovarvo/modules/Admin/notify_user_screen.dart';
import 'package:Sovarvo/modules/Admin/pickup_video_game.dart';
import 'package:Sovarvo/modules/Admin/video_games.dart';
import 'package:Sovarvo/modules/Admin/video_games_orders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/apis.dart';

class AdminVGControlScreen extends StatefulWidget {
  AdminVGControlScreen({super.key});
  //static const String route = '/';

  @override
  State<AdminVGControlScreen> createState() => _AdminVGControlScreenState();
}

class _AdminVGControlScreenState extends State<AdminVGControlScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  int deliveryPrice = 0;
  int discountDeliveryPrice = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseMessagingToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8F3D96),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/logo_final.png'),
              ),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const videoGamesScreen(),
                      ),
                    );
                  },
                  child: const Text('Video Games', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PickupVideoGamesControlScreen(),
                      ),
                    );
                  },
                  child: const Text('Stations', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    _showUpdateDeliveryPriceDialog();
                  },
                  child: const Text('Add Delivery Price', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    _showUpdateDiscountDeliveryPriceDialog();
                  },
                  child: const Text('Add Discount Delivery Price', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotifyUserScreen(),
                      ),
                    );
                  },
                  child: const Text('Notify User', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoGamesOrdersScreen(),
                      ),
                    );
                  },
                  child: const Text('Video Games Orders', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showUpdateDeliveryPriceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newDeliveryPrice = deliveryPrice;
        return AlertDialog(
          title: const Text("Update Delivery Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Delivery Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newDeliveryPrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameDeliveryPrice(newDeliveryPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameDeliveryPrice(int newDeliveryePrice) {
    databaseReference.child("Delivery Price").set(newDeliveryePrice).then((_) {
      setState(() {
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

  void _showUpdateDiscountDeliveryPriceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newDiscountDeliveryPrice = discountDeliveryPrice;
        return AlertDialog(
          title: const Text("Update Discount Delivery Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Discount Delivery Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newDiscountDeliveryPrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameDiscountDeliveryPrice(newDiscountDeliveryPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameDiscountDeliveryPrice(int newDiscountDeliveryePrice) {
    databaseReference.child("Discount Delivery Price").set(newDiscountDeliveryePrice).then((_) {
      setState(() {
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

}