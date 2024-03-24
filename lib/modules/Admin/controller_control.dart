import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpareControllerScreen extends StatefulWidget {
  const SpareControllerScreen({super.key});

  @override
  _SpareControllerScreenState createState() => _SpareControllerScreenState();
}

class _SpareControllerScreenState extends State<SpareControllerScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  int spareControllerCount = 0;

  @override
  void initState() {
    super.initState();
    _getSpareControllerCount();
  }

  void _getSpareControllerCount() {
    databaseReference.child("SpareController").once().then((DatabaseEvent event) {
      setState(() {
        spareControllerCount = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  void _updateSpareControllerCount(int newCount) {
    databaseReference.child("SpareController").set(newCount).then((_) {
      setState(() {
        spareControllerCount = newCount;
      });
      //print("Spare controller count updated successfully.");
    }).catchError((error) {
      //print("Failed to update spare controller count: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Spare Controller", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xff8F3D96),
    ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: Image.asset('assets/images/LOGOS-02.png'),
            ),
          ),
          Text(
            "Spare Controller Count: $spareControllerCount",
            style: TextStyle(
                fontSize:
                MediaQuery.of(context).size.height *
                0.03, color: const Color(0xff8F3D96))),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8F3D96),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Update Spare Controller Count", style: TextStyle(color: Colors.black)),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Update spare controller count when text changes
                        setState(() {
                          spareControllerCount = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration: const InputDecoration(hintText: "Enter new count"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Update",style: TextStyle(
                            fontSize:
                            MediaQuery.of(context).size.height *
                                0.02)),
                        onPressed: () {
                          // Update spare controller count in the database
                          _updateSpareControllerCount(spareControllerCount);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Change Spare Controller Count", style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white
            )),
          ),
        ],
      ),
    );
  }
}
