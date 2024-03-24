import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> userData = {};
  String? selectedCompany;
  List<dynamic> companiesList = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    databaseReference.child("Users").once().then((DatabaseEvent event) {
      final dynamic value = event.snapshot.value;
      if (value != null && value is Map<Object?, Object?>) {
        userData = {};
        value.forEach((key, dynamic val) {
          if (key is String) {
            userData[key] = val;
          } else {
            // Handle the case when key is not a string
            // For example, convert key to a string or skip this key
          }
        });
      } else {
        // Handle the case when data is null or not of expected type
        userData = {};
      }
      companiesList = userData.values.map((user) => user['Company']).toSet().toList();
      companiesList.insert(0, null); // Insert "All" option at the beginning

      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("User Data", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff8F3D96),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(child: Text('Choose your users Company: ', style: TextStyle(color:Color(0xff8F3D96), fontSize: 15, fontWeight: FontWeight.bold),)),
                const SizedBox(width: 20,),
                DropdownButton<dynamic>(
                  value: selectedCompany,
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedCompany = newValue;
                    });
                  },
                  items: companiesList.map<DropdownMenuItem<dynamic>>((dynamic value) {
                    return DropdownMenuItem<dynamic>(
                      value: value,
                      child: Text(value ?? 'All', style: const TextStyle(color: Color(0xff8F3D96))),
                    );
                  }).toList(),
                  hint: const Text('Filter by Company'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                var userId = userData.keys.elementAt(index);
                var user = userData[userId];
                if (selectedCompany == null || user?['Company'] == selectedCompany || selectedCompany == 'All') {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          //set border radius more than 50% of height and width to make circle
                        ),
                      color: const Color(0xff8F3D96),
                      child: ListTile(
                        //title: Text("User ID: $userId"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name: ${user['FullName']}", style: const TextStyle( color: Colors.white),),
                            Text("Email: ${user['E-Mail']}", style: const TextStyle( color: Colors.white),),
                            Text("Phone: ${user['Phone']}", style: const TextStyle( color: Colors.white),),
                            Text("Company: ${user['Company']}", style: const TextStyle( color: Colors.white),),
                            Text("Code: ${user['Code']}", style: const TextStyle( color: Colors.white),),
                            // Add more fields as needed
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // Return an empty SizedBox if the filter doesn't match
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}