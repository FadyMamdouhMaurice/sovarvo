import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PriceControlScreen extends StatefulWidget {
  const PriceControlScreen({super.key});

  @override
  _PriceControlScreenState createState() => _PriceControlScreenState();
}

class _PriceControlScreenState extends State<PriceControlScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> prices = {};
  dynamic price;
  final TextEditingController _controllerController = TextEditingController();
  //final TextEditingController _dayController = TextEditingController();
  final TextEditingController _gameController = TextEditingController();
  final TextEditingController _psController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPrices();
  }

  void _getPrices() {
    databaseReference.child("Prices").once().then((DatabaseEvent event) {
      setState(() {
        prices = (event.snapshot.value) as Map<dynamic, dynamic>;
        /*_controllerController = TextEditingController(text: prices["Controller"].toString());
        _dayController = TextEditingController(text: prices["Day"].toString());
        _gameController = TextEditingController(text: prices["Game"].toString());
        _psController = TextEditingController(text: prices["PS"].toString());*/
      });
    });
  }

  void _updatePrice(String key, int newValue) {
    databaseReference.child("Prices").update({key: newValue}).then((_) {
      setState(() {
        prices[key] = newValue;
      });
      //print("$key price updated successfully.");
    }).catchError((error) {
      //print("Failed to update $key price: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Price Control",style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff8F3D96),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                width: double.infinity,
                height: 350,
                child: Image.asset('assets/images/LOGOS-02.png'),
              ),
            ),
            Column(
              children: prices.keys.map((key) {
                TextEditingController controller;
                switch (key) {
                  case "Controller":
                    controller = _controllerController;
                    break;
                  /*case "Day":
                    controller = _dayController;
                    break;
                  */
                  case "Game":
                    controller = _gameController;
                    break;
                  case "PS":
                    controller = _psController;
                    break;
                  default:
                    controller = TextEditingController();
                }
                return ListTile(
                  title: Text("$key Price: ${prices[key]} \$", style: TextStyle(color: const Color(0xff8F3D96), fontWeight: FontWeight.bold,)),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          onChanged: (newValue) {
                            price = newValue;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.done,color: Color(0xff8F3D96)),
                        onPressed: () {
                          setState(() {
                            _updatePrice(key, int.tryParse(price) ?? 0);
                            controller.text = '';
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
