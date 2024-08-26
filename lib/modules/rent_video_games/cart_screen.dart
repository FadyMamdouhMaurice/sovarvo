import 'package:Sovarvo/apis.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_contents.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_screen_header.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/selection_options.dart';
import 'package:Sovarvo/modules/rent_video_games/terms_conditions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';
import '../../shared/my_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.cartItems});

  static const String route = '/cart';
  final List<Map<String, dynamic>> cartItems;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<int, int> selectedCounts = {};
  int _selectedValue = 0;
  String _selectedWay = 'rent';
  int _selectedAddress = 0;
  String _selectedStation = '';
  final CartHelpers cartHelpers = CartHelpers();
  int discount = 0;
  int deliveryPrice = 0;
  String deliveryType = 'Home Delivery';
  String deliveryAddress = '';
  //String loginOrNot = 'Sign out';
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    loadCartItems();
    // Initialize the selected counts with 1 for each item
    for (int i = 0; i < widget.cartItems.length; i++) {
      selectedCounts[i] = 1;
    }

    cartHelpers.getDeliveryPrice((price) {
      setState(() {
        deliveryPrice = price;
      });
    });

    // Set initial delivery address if addresses list is not empty
    /*if (addresses.isNotEmpty) {
      deliveryAddress = addresses[0].toString();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CartScreenHeader(),
            //appBarSignInOut(context, loginOrNot, "assets/images/logo_final.png"),
            Container(
              height: MediaQuery.of(context).size.height * 1,
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CartContents(
                      cartItems: widget.cartItems,
                      selectedCounts: selectedCounts,
                      discount: discount,
                      removeItem: _removeItem,
                      calculateTotalPrice: calculateTotalPrice,
                      calculateInsurancePrice: calculateInsurancePrice,
                      buildConfirmButton: _buildConfirmButton, selectedWay: _selectedWay,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectionOptions(
                      selectedWay: _selectedWay,
                      selectedValue: _selectedValue,
                      selectedAddress: _selectedAddress,
                      onWayChanged: (newValue) {
                        setState(() {
                          _selectedWay = newValue;
                          if (_selectedWay != 'rent') discount = 0;
                        });
                      },
                      onValueChanged: (newValue) {
                        setState(() {
                          _selectedValue = newValue;
                          deliveryType =
                              _selectedValue == 0 ? 'Home Delivery' : 'Pickup';
                          deliveryAddress = _selectedValue == 0 ? addresses[_selectedAddress].toString() : _selectedStation;
                        });
                      },
                      onStationSelected: (String? selectedStation) {
                        setState(() {
                          _selectedStation = selectedStation!;
                          deliveryAddress = _selectedStation;
                        });
                      },
                      onDiscountChanged: handleDiscountChanged,
                      onAddressChanged: (int value) {
                        setState(() {
                          _selectedAddress = value;
                          // Get the actual address string from the selected radio button value
                          deliveryAddress =
                              addresses[_selectedAddress].toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TermsConditions(),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const bottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return InkWell(
      onTap: () async {
        String checkSelectedWay = 'rent-price';
        if(_selectedWay == 'rent') checkSelectedWay = 'rent-price';
        else if(_selectedWay == 'new') checkSelectedWay = 'price';
        if(_selectedWay == 'used') checkSelectedWay = 'used-price';

        // Check if any item in the cart has a zero price for the selected way
        bool hasZeroPrice = widget.cartItems.any((item) {
          // Ensure the item contains the selected way and handle different types
          if (item.containsKey(checkSelectedWay)) {
            final price = item[checkSelectedWay];
            if (price is int || price is double) {
              return price == 0;
            }
          }
          return false;
        });

          if (await cartHelpers.checkUserSignIn(context, user)) {
          // Proceed with the purchase logic
          if (widget.cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your Cart Contents is Empty'),
            ));
            return;
          } else if (deliveryAddress.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Choose Your Address or Pick Up Station'),
            ));
          }
          // Check if any item in the cart has a zero price for the selected way
          else if(hasZeroPrice) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('There is video games in your cart not available as $_selectedWay. Please update the cart.'),
            ));
            return;
          }
          else if (!isSelected) {
            cartHelpers.confirmPurchase(context, isSelected, (value) {
              setState(() {
                isSelected = value;
              });
            }, () {
              setState(() {
                createOrder(
                  user!.uid,
                  widget.cartItems,
                  _selectedWay,
                  deliveryAddress,
                  calculateTotalPrice(),
                  deliveryType,
                );
                cartItems.clear();
                saveCartItems();
              });
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              MyThemeData.primaryColor,
              Colors.blue,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.05,
        child: Center(
          child: Text("Confirm",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      cartHelpers.removeItem(index, widget.cartItems, selectedCounts);
    });
  }

  int calculateTotalPrice() {
    return cartHelpers.calculateTotalPrice(
        widget.cartItems, selectedCounts, _selectedWay);
  }

  int calculateInsurancePrice() {
    return cartHelpers.calculateInsurancePrice(
        widget.cartItems, selectedCounts);
  }

  void handleDiscountChanged(int newDiscount) {
    setState(() {
      discount = newDiscount;
    });
  }

  void createOrder(
      String uid,
      List<Map<String, dynamic>> cartItems,
      String selectedWay,
      String selectedAddress,
      int totalPrice,
      deliveryType) {
    // Create an instance of the Order class
    Order order = Order(
      userId: uid,
      // Assuming user has a UID after signing in
      cartItems: cartItems,
      selectedWay: selectedWay,
      selectedAddress: selectedAddress,
      totalPrice: totalPrice + deliveryPrice - discount + calculateInsurancePrice(),
      deliveryType: deliveryType,
      selectedCounts: selectedCounts, // Pass selectedCounts
      customerName: user!.fullName,
      customerEmail: user!.email,
      customerPhone: user!.phone,
      customerCompany: user!.company,
      customerCode: user!.code,
    );

    // Reference to your Firebase database node where orders will be stored
    DatabaseReference ordersRef =
        FirebaseDatabase.instance.ref().child('Video Games Orders').child(uid);

    // Generate a new key for the order
    String? orderId = ordersRef.push().key;

    // Save the order to Firebase
    ordersRef.child(orderId!).set(order.toJson()).then((_) async {
      // Handle success scenario (e.g., show confirmation message)
      print('Order successfully placed!');

      // Update game counts for each item in cart
      for (int i = 0; i < cartItems.length; i++) {
        Map<String, dynamic> cartItem = cartItems[i];
        String gameId = cartItem['name']; // Adjust key based on your data structure
        int orderedQuantity = selectedCounts[i] ?? 1;
        _updateVideoGameCount(gameId, orderedQuantity);
      }

      List<String> t = await getAllAdminsTokens();
      await sendPushNotification(t, 'Sovarvo has got Video game order');

      // Clear cart items and navigate back to the home screen
      setState(() {

        selectedCounts.clear();
      });

      // Navigate back to the home screen
      //Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed(
          HomeAfterRegister.route);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order successfully placed! Will Get it within 3 days'),
      ));

    }).catchError((error) {
      // Handle error scenario
      print('Failed to place order: $error');
    });
  }

  void _updateVideoGameCount(String gameId, int orderedQuantity) {
    DatabaseReference gameRef =
    FirebaseDatabase.instance.ref().child('VideoGames').child(gameId);
    gameRef.once().then((DatabaseEvent databaseEvent) {
      Map<String, dynamic>? gameData = databaseEvent.snapshot.value as Map<String, dynamic>?; // Cast snapshot.value to Map<String, dynamic>?

      if (gameData != null) {
        int currentCount = gameData['Count']; // Access 'count' property from gameData
        int newCount = currentCount - orderedQuantity;
        gameRef.update({'Count': newCount});
      }
    });
  }
}
