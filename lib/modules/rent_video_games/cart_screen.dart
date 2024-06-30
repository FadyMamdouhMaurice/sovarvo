import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_contents.dart';
import 'package:Sovarvo/modules/rent_video_games/selection_options.dart';
import 'package:Sovarvo/modules/rent_video_games/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';


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
  final CartHelpers cartHelpers = CartHelpers();
  final dynamic user = null; // Replace this with your actual user logic

  @override
  void initState() {
    super.initState();
    // Initialize the selected counts with 1 for each item
    for (int i = 0; i < widget.cartItems.length; i++) {
      selectedCounts[i] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1,
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CartContents(cartItems: widget.cartItems,
                      selectedCounts: selectedCounts,
                      removeItem: _removeItem,
                      calculateTotalPrice: calculateTotalPrice,),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectionOptions(
                      selectedWay: _selectedWay,
                      selectedValue: _selectedValue,
                      onWayChanged: (newValue) {
                        setState(() {
                          _selectedWay = newValue;
                        });
                      },
                      onValueChanged: (newValue) {
                        setState(() {
                          _selectedValue = newValue;
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
            ),            const bottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      cartHelpers.removeItem(index, widget.cartItems, selectedCounts);
    });
  }

  double calculateTotalPrice() {
    return cartHelpers.calculateTotalPrice(widget.cartItems, selectedCounts, _selectedWay);
  }

  Future<void> checkUserSignIn() async {
    await cartHelpers.checkUserSignIn(context, user);
  }
}