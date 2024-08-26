import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

List<Map<String, String>> addresses = []; // List to store addresses

class SelectionOptions extends StatefulWidget {
  final String selectedWay;
  final int selectedValue;
  final int selectedAddress;
  final ValueChanged<String> onWayChanged;
  final ValueChanged<int> onValueChanged;
  final ValueChanged<int> onAddressChanged;
  final void Function(String?) onStationSelected;
  final ValueChanged<int> onDiscountChanged;

  SelectionOptions({
    required this.selectedWay,
    required this.selectedValue,
    required this.onWayChanged,
    required this.onValueChanged,
    required this.onStationSelected,
    required this.onDiscountChanged,
    required this.selectedAddress,
    required this.onAddressChanged,
  });

  @override
  _SelectionOptionsState createState() => _SelectionOptionsState();
}

class _SelectionOptionsState extends State<SelectionOptions> {

  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> stationItems = [];
  String? stationSelectedValue;
  String dropdownValue = "I do not own any Sovarvo games.";
  final databaseReference = FirebaseDatabase.instance.ref();
  int discountDeliveryPrice = 0;
  final CartHelpers cartHelpers = CartHelpers(); // Initialize CartHelpers


  @override
  void initState() {
    super.initState();
    fetchPickupStations();
    getDiscountDeliveryPrice();
    myFetchAddresses();
  }

  Future<void> myFetchAddresses() async {
    List<Map<String, String>> fetchedAddresses = await fetchAddresses();
    setState(() {
      addresses = fetchedAddresses;
    });
    // Notify the parent widget that addresses are fetched
    if (addresses.isNotEmpty) {
      widget.onAddressChanged(0);
    }
  }

  @override
  void didUpdateWidget(SelectionOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWay != oldWidget.selectedWay && widget.selectedWay == 'rent') {
      setState(() {
        dropdownValue = "I do not own any Sovarvo games.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Radio<String>(
                  fillColor: MaterialStateProperty.all(MyThemeData.primaryColor),
                  value: 'rent',
                  groupValue: widget.selectedWay,
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.onWayChanged(newValue!);
                    });
                  },
                ),
                Text('Rent',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      //fontSize: MediaQuery.of(context).size.width * 0.008,
                    )),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Row(
              children: [
                Radio<String>(
                  fillColor: MaterialStateProperty.all(MyThemeData.primaryColor),
                  value: 'new',
                  groupValue: widget.selectedWay,
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.onWayChanged(newValue!);
                      widget.onValueChanged(0);
                    });
                  },
                ),
                Text('New',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      //fontSize: MediaQuery.of(context).size.width * 0.008,
                    )),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Row(
              children: [
                Radio<String>(
                  fillColor: MaterialStateProperty.all(MyThemeData.primaryColor),
                  value: 'used',
                  groupValue: widget.selectedWay,
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.onWayChanged(newValue!);
                      widget.onValueChanged(0);
                    });
                  },
                ),
                Text('Used',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      //fontSize: MediaQuery.of(context).size.width * 0.008,
                    )),
              ],
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(
                    color: MyThemeData.primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Radio(
                      fillColor: MaterialStateProperty.all(MyThemeData.primaryColor),
                      value: 0,
                      groupValue: widget.selectedValue,
                      onChanged: (int? newValue) {
                        setState(() {
                          widget.onValueChanged(newValue!);

                        });
                      },
                    ),
                    Image.asset(
                      'assets/images/truck.png',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    SizedBox(width: 10),
                    Text('Home Delivery',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          //fontSize: MediaQuery.of(context).size.width * 0.008,
                        )),
                    Text('Receive your order at home',
                        style: TextStyle(
                          color: Colors.white,
                          //fontSize: MediaQuery.of(context).size.width * 0.007,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            if (widget.selectedWay == 'rent')
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    border: Border.all(
                      color: MyThemeData.primaryColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Radio(
                        fillColor:
                        MaterialStateProperty.all(MyThemeData.primaryColor),
                        value: 1,
                        groupValue: widget.selectedValue,
                        onChanged: (int? newValue) {
                          setState(() {
                            widget.onValueChanged(newValue!);
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/delivery-man.png',
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      SizedBox(width: 10),
                      Text('Pick Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontSize: MediaQuery.of(context).size.width * 0.008,
                          )),
                      Text('Pickup from nearest store',
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: MediaQuery.of(context).size.width * 0.007,
                          )),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (widget.selectedWay == 'rent')
          Container(
            height: MediaQuery.of(context).size.height *
                0.1,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              border: Border.all(
                color: MyThemeData.primaryColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                dropdownColor: Colors.grey[900],
                isExpanded: true,
                value: dropdownValue,
                onChanged: _onDropdownChanged,
                items: <String>["I do not own any Sovarvo games.",
                  'I own a game from Sovarvo and want to exchange it for a $discountDeliveryPrice EGP discount on my order.']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: RichText(
                      text: TextSpan(
                        children: value.split(' ').map((word) {
                          return TextSpan(
                            text: '$word ',
                            style: TextStyle(
                              color: Colors.white,
                              height: 1.5, // Adjust the height as needed for spacing
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        SizedBox(
          height: MediaQuery.of(context).size.height *
              0.02,
        ),

        if(widget.selectedValue == 0)
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(
                    color: MyThemeData.primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shipping Addresses',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontSize: MediaQuery.of(context).size.width * 0.012,
                          )),
                      Row(
                        children: [
                          Text('Choose a delivery address or ',
                              style: TextStyle(
                                color: Colors.white,
                                //fontSize: MediaQuery.of(context).size.width * 0.007,
                              )),
                          GestureDetector(
                            onTap: () async {
                              // Check if the user is signed in
                              if(await cartHelpers.checkUserSignIn(context, user)){
                              // Proceed with the purchase logic
                                _showAddAddressDialog();
                              }
                            },
                            child: Text('Add New Address',
                                style: TextStyle(
                                  color: MyThemeData.primaryColor,
                                  //fontSize: MediaQuery.of(context).size.width * 0.007,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: MyThemeData.primaryColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(
                        color: MyThemeData.primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Radio(
                            fillColor:
                            MaterialStateProperty.all(MyThemeData.primaryColor),
                            value: index,
                            groupValue: widget.selectedAddress,
                            onChanged: (int? newValue) {
                              setState(() {
                                widget.onAddressChanged(newValue!);
                              });
                            },
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          Expanded(
                            child: Text(
                              '${addresses[index]['city']}, ${addresses[index]['street']}, ${addresses[index]['landmark'] ?? ''}',
                              style: TextStyle(
                                color: Colors.white,
                                //fontSize: MediaQuery.of(context).size.width * 0.008,
                              ),
                              overflow: TextOverflow.ellipsis, // Add ellipsis to handle overflow
                              maxLines: 1, // Restrict to a single line
                            ),
                          ),
                          IconButton(onPressed: (){
                            confirmDeleteAddressDialog(index);
                          }, icon: Icon(Icons.delete_forever, color: Colors.red,)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

        if(widget.selectedValue == 1)
          Container(
            //width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              border: Border.all(
                color: MyThemeData.primaryColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(color: Colors.grey[800])),
                isExpanded: true,
                hint: Text(
                    'Select Station',
                    style: TextStyle(
                      color: Colors.white,
                      //fontSize: MediaQuery.of(context).size.width * 0.012,
                    )
                ),
                items: stationItems
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ))
                    .toList(),
                value: stationSelectedValue,
                onChanged: (String? value) {
                  setState(() {
                    stationSelectedValue = value;
                  });
                  widget.onStationSelected(stationSelectedValue);

                },
                menuItemStyleData: MenuItemStyleData(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
          ),

      ],
    );
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Address', style: TextStyle(
            color: Colors.black,
            //fontSize: MediaQuery.of(context).size.width * 0.012,
          )),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _cityController,
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
                      controller: _streetController,
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
                      controller: _landmarkController,
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
                fontSize: 16,
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add', style: TextStyle(
                fontSize: 16,
              )),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String street = _streetController.text;
                  String city = _cityController.text;
                  String landmark = _landmarkController.text;
                  String combinedAddress = '$street, $city, $landmark';

                  setState(() {
                    addresses.add({
                      'street': street,
                      'city': city,
                      'landmark': landmark
                    });
                  });
                  addUserAddress(combinedAddress);

                  _streetController.clear();
                  _cityController.clear();
                  _landmarkController.clear();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void confirmDeleteAddressDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this address', style: TextStyle(
            color: Colors.black,
            //fontSize: MediaQuery.of(context).size.width * 0.012,
          )),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(
                fontSize: 16,
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(
                fontSize: 16,
              )),
              onPressed: () {
                //add function to remove address from list and from firebase and update state
                setState(() {
                  deleteAddress(user!.uid,index);
                  addresses.removeAt(index);
                  widget.onAddressChanged(addresses.isNotEmpty ? 0 : -1);
                });
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      },
    );
  }

  void fetchPickupStations() {
    DatabaseReference pickupStationsRef = FirebaseDatabase.instance.ref().child('Pickup Stations Video Games');
    pickupStationsRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<dynamic, dynamic> pickupStationsData = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          stationItems = pickupStationsData.values.cast<String>().toList();
        });
      }
    }).catchError((error) {
      //print("Error fetching Pickup Stations: $error");
    });

  }

  void getDiscountDeliveryPrice() {
    databaseReference.child("Discount Delivery Price").once().then((DatabaseEvent event) {
      setState(() {
        discountDeliveryPrice = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  void _onDropdownChanged(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      int discount = 0;
      if (dropdownValue == 'I own a game from Sovarvo and want to exchange it for a $discountDeliveryPrice EGP discount on my order.') {
        discount = discountDeliveryPrice;
      } else if (dropdownValue == "Get ${discountDeliveryPrice * 2} EGP discount when change with last 2 orders") {
        discount = discountDeliveryPrice * 2;
      }
      widget.onDiscountChanged(discount);
    });

  }
  Future<void> deleteAddress(String userId, int addressIndex) async {
    try {
      DatabaseReference userRef = databaseReference.child('Users').child(userId);
      DatabaseEvent databaseEvent = await userRef.once();
      Map userData = databaseEvent.snapshot.value as Map;

      if (userData['Addresses'] != null) {
        List<dynamic> addresses = List.from(userData['Addresses']);
        if (addressIndex >= 0 && addressIndex < addresses.length) {
          addresses.removeAt(addressIndex);

          await userRef.update({
            'Addresses': addresses,
          });

          print('Address deleted successfully.');
        } else {
          print('Invalid address index.');
        }
      } else {
        print('No addresses found.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
