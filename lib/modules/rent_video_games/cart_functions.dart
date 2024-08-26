import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Sovarvo/modules/signin/signin.dart';

final databaseReference = FirebaseDatabase.instance.ref();

class CartHelpers {
  final databaseReference = FirebaseDatabase.instance.ref();

  void getDeliveryPrice(Function(int) setDeliveryPrice) {
    databaseReference.child("Delivery Price").once().then((DatabaseEvent event) {
      setDeliveryPrice((event.snapshot.value ?? 0) as int);
    });
  }

  void confirmPurchase(BuildContext context, bool isSelected, Function(bool) setSelected, Function createOrder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool localIsSelected = isSelected; // Local state to manage the checkbox
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Confirm Purchase',
                style: TextStyle(
                  //fontSize: MediaQuery.of(context).size.width * 0.01,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      "I agree to the terms and conditions and privacy policy",
                      style: TextStyle(
                        fontSize: 13,
                        //fontSize: MediaQuery.of(context).size.width * 0.008,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.002),
                  Theme(
                    data: ThemeData(
                      checkboxTheme: CheckboxThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: localIsSelected,
                      onChanged: (value) {
                        setState(() {
                          localIsSelected = value!;
                        });
                        setSelected(value!);
                      },
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (!localIsSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('You must agree to the Terms and Conditions and Privacy Policy'),
                      ));
                    } else {
                      // Call createOrder here
                      createOrder();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> checkUserSignIn(BuildContext context, dynamic user) async {
    if (user == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign In Required',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                )),
            content: Text('You need to sign in to can continue.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to sign-in screen or any authentication flow
                  Navigator.of(context).pushNamed(SignIn.route);
                },
                child: Text('Sign In',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
              ),
            ],
          );
        },
      );
      return false;
    } else {
      // Continue with the existing logic for handling the order
      // ...
      return true;
    }
  }

  void removeItem(int index, List<Map<String, dynamic>> cartItems, Map<int, int> selectedCounts) {
    cartItems.removeAt(index);
    selectedCounts.remove(index);
    // Update the keys of the selectedCounts map
    selectedCounts = {
      for (var i = 0; i < cartItems.length; i++) i: selectedCounts[i] ?? 1
    };
  }

  int calculateTotalPrice(List<Map<String, dynamic>> cartItems, Map<int, int> selectedCounts, String selectedWay) {
    int total = 0;
    for (int index = 0; index < cartItems.length; index++) {
      final item = cartItems[index];
      final count = selectedCounts[index] ?? 1;
      int price = 0;

      if (selectedWay == 'rent') {
        price = item['rent-price'];
      } else if (selectedWay == 'new') {
        price = item['price'];
      } else if (selectedWay == 'used') {
        price = item['used-price'];
      }

      total += price * count;
    }

    return total;
  }

  int calculateInsurancePrice(List<Map<String, dynamic>> cartItems, Map<int, int> selectedCounts) {
    int total = 0;
    for (int index = 0; index < cartItems.length; index++) {
      final item = cartItems[index];
      final count = selectedCounts[index] ?? 1;

      int price = 0;

      price = item['insurance-price'] ?? 0; // Add null check here

      total += price * count;
    }
    return total;
  }

}

class Order {
  String userId; // Assuming you have a user ID for authentication
  List<Map<String, dynamic>> cartItems;
  Map<int, int> selectedCounts; // Add selectedCounts
  String selectedWay; // 'rent', 'new', 'used'
  String selectedAddress; // Address string or pickup station
  int totalPrice;
  String deliveryType;
  String customerName;
  String customerPhone;
  String customerEmail;
  String customerCompany;
  String customerCode;


  Order({
    required this.userId,
    required this.cartItems,
    required this.selectedCounts, // Initialize selectedCounts
    required this.selectedWay,
    required this.selectedAddress,
    required this.totalPrice,
    required this.deliveryType,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerCompany,
    required this.customerCode,
  });

  // Convert only game name and count to JSON
    Map<String, dynamic> toJson() {
      List<Map<String, dynamic>> simplifiedCartItems = [];
      for (int i = 0; i < cartItems.length; i++) {
        simplifiedCartItems.add({
          'name': cartItems[i]['name'],
          'selectedCount': selectedCounts[i], // Use selectedCounts instead of count
        });
      }

      Map<String, dynamic> customerInfo = {
        'Name': customerName,
        'Phone': customerPhone,
        'E-Mail': customerEmail,
        'Company': customerCompany,
        'Code': customerCode,
    };

    return {
      'cartItems': simplifiedCartItems,
      'selectedWay': selectedWay,
      'selectedAddress': selectedAddress,
      'totalPrice': totalPrice,
      'deliveryType': deliveryType,
      'Requested Time': DateTime.now().toString(),
      'Customer Info': customerInfo,
    };
  }
}


