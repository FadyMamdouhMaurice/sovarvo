import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PickupVideoGamesControlScreen extends StatefulWidget {
  const PickupVideoGamesControlScreen({super.key});

  @override
  _PickupVideoGamesControlScreenState createState() =>
      _PickupVideoGamesControlScreenState();
}

class _PickupVideoGamesControlScreenState
    extends State<PickupVideoGamesControlScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> pickupStations = {};

  final TextEditingController _pickupStationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPickupStations();
  }

  void _getPickupStations() {
    databaseReference
        .child("Pickup Stations Video Games")
        .once()
        .then((DatabaseEvent event) {
      setState(() {
        pickupStations = (event.snapshot.value) as Map<dynamic, dynamic>;
      });
    });
  }

  void _addPickupStation(String newKey, String newValue) {
    databaseReference
        .child("Pickup Stations Video Games")
        .update({newKey: newValue}).then((_) {
      setState(() {
        pickupStations[newKey] = newValue;
      });
      //print("$newKey pickup station added successfully.");
    }).catchError((error) {
      //print("Failed to add $newKey pickup station: $error");
    });
  }

  void _deletePickupStation(String key) {
    databaseReference
        .child("Pickup Stations Video Games")
        .child(key)
        .remove()
        .then((_) {
      setState(() {
        pickupStations.remove(key);
      });
      //print("$key pickup station deleted successfully.");
    }).catchError((error) {
      //print("Failed to delete $key pickup station: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Pickup Station Control", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff8F3D96),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: pickupStations.keys.map((key) {
            TextEditingController controller;
            switch (key) {
              default:
                controller = _pickupStationController;
            }
            return ListTile(
              title: const Text(""),
              subtitle: Row(
                children: [
                  Text("$key Station", style: TextStyle(color: const Color(0xff8F3D96), fontWeight: FontWeight.bold,fontSize: 18)),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    color: Colors.red,
                    onPressed: () {
                      _deletePickupStation(key);
                    },
                  ),
                ],
              ),
            );
          }).toList()
            ..add(ListTile(
              title: const Text("Add Pickup Station"),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pickupStationController,
                      decoration: const InputDecoration(
                        hintText: "Enter new pickup station name",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _addPickupStation(
                          _pickupStationController.text.trim(),
                          _pickupStationController.text.trim());
                      _pickupStationController.clear();
                    },
                  ),
                ],
              ),
            )),
        ),
      ),
    );
  }
}