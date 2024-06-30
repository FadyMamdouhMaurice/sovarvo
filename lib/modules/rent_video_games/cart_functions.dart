import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/signin/signin.dart';

class CartHelpers {
  Future<void> checkUserSignIn(BuildContext context, dynamic user) async {
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
    } else {
      // Continue with the existing logic for handling the order
      // ...
      //letsDoItNow();
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

  double calculateTotalPrice(List<Map<String, dynamic>> cartItems, Map<int, int> selectedCounts, String selectedWay) {
    double total = 0.0;
    for (int index = 0; index < cartItems.length; index++) {
      final item = cartItems[index];
      final count = selectedCounts[index] ?? 1;
      double price = 0.0;

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
}
