import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PSCountScreen extends StatefulWidget {
  const PSCountScreen({super.key});

  @override
  _PSCountScreenState createState() => _PSCountScreenState();
}

class _PSCountScreenState extends State<PSCountScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  int psCount = 0;

  @override
  void initState() {
    super.initState();
    _getPSCount();
  }

  void _getPSCount() {
    databaseReference
        .child("PS")
        .child("count")
        .once()
        .then((DatabaseEvent event) {
      setState(() {
        psCount = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  void _updatePSCount(int newCount) {
    databaseReference.child("PS").update({"count": newCount}).then((_) {
      setState(() {
        psCount = newCount;
      });
      //print("PS count updated successfully.");
    }).catchError((error) {
      //print("Failed to update PS count: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("PS", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xff8F3D96),
    ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            "PS Count: $psCount",
            style: TextStyle(
                fontSize:
                MediaQuery.of(context).size.height *
                    0.03, color: const Color(0xff8F3D96)),
          ),
          SizedBox(
            height: 20,
          ),
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
                    title: const Text("Update PS Count", style: TextStyle(color: Colors.black)),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Update psCount when text changes
                        setState(() {
                          psCount = int.tryParse(value) ?? 0;
                        });
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter new count"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Update",style: TextStyle(
                            fontSize:
                            MediaQuery.of(context).size.height *
                                0.02)),
                        onPressed: () {
                          // Update PS count in the database
                          _updatePSCount(psCount);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Change PS Count", style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white
            )),
          ),
        ],
      ),
    );
  }
}