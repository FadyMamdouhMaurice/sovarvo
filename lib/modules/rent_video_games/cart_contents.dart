import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_functions.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

class CartContents extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<int, int> selectedCounts;
  final Function(int) removeItem;
  final int Function() calculateTotalPrice;
  final int Function() calculateInsurancePrice;

  final int discount; // Add this property
  final Widget Function() buildConfirmButton; // Add this property
  final String selectedWay; // Add this property


  CartContents({
    required this.cartItems,
    required this.selectedCounts,
    required this.removeItem,
    required this.calculateTotalPrice,
    required this.calculateInsurancePrice,
    required this.discount,
    required this.buildConfirmButton, // Initialize this property
    required this.selectedWay, // Initialize this property

  });

  @override
  _CartContentsState createState() => _CartContentsState();
}

class _CartContentsState extends State<CartContents> {
  int deliveryPrice = 0;
  bool isSelected = false;
  final CartHelpers cartHelpers = CartHelpers(); // Initialize CartHelpers
  String summeryType = 'rent';
  int insurancePrice = 0;

  @override
  void initState() {
    super.initState();
    if (widget.cartItems.isNotEmpty) {
      cartHelpers.getDeliveryPrice((price) {
        setState(() {
          deliveryPrice = price;
        });
      });
    }
    insurancePrice = widget.calculateInsurancePrice();
  }

  @override
  void didUpdateWidget(CartContents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems.isEmpty) {
      setState(() {
        deliveryPrice = 0;
      });
    }

    // Update the summeryType based on the selectedWay
    if (oldWidget.selectedWay != widget.selectedWay) {
      setState(() {
        summeryType = widget.selectedWay;
        if(widget.selectedWay == 'used' || widget.selectedWay == 'new') insurancePrice = 0;
        else insurancePrice = widget.calculateInsurancePrice();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
            Text('Cart Contents',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.015,
                )),
            Text('Contents of Your Shopping Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.008,
                )),
            Divider(
              height: MediaQuery.of(context).size.height * 0.01,
              color: MyThemeData.primaryColor,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.16,
                              child: Image.network(item['image-url']),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      color: MyThemeData.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.012,
                                    ),
                                  ),
                                  Text(
                                    'New Price: ${item['price']} EGP',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Used Price: ${item['used-price']} EGP',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Rent Price: ${item['rent-price']} EGP',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    widget.removeItem(index);
                                    removeFromCart(item['name']);
                                    setState(() {
                                      //update screen with new insurancePrice
                                      insurancePrice = widget.calculateInsurancePrice();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    border: Border.all(
                                      color: MyThemeData.primaryColor,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<int>(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      isExpanded: true,
                                      dropdownColor: Colors.grey[900],
                                      value: widget.selectedCounts[index],
                                      items: List.generate(item['count'], (i) {
                                        return DropdownMenuItem<int>(
                                          value: i + 1,
                                          child: Text('${i + 1}'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          widget.selectedCounts[index] = value!;
                                          insurancePrice = widget.calculateInsurancePrice();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: MediaQuery.of(context).size.height * 0.01,
                          color: const Color(0xff8F3D96),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: MediaQuery.of(context).size.height * 0.01,
              color: const Color(0xff8F3D96),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtotal', // Apply discount here
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.01,
                  ),
                ),
                Text(
                  'Summary of cart Subtotal', // Apply discount here
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.008,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                buildSubtotalItems('+',summeryType,widget.calculateTotalPrice(), context),
                buildSubtotalItems('+','Shipping And Handling',deliveryPrice ,context),
                if(summeryType == 'rent')
                  buildSubtotalItems('+','Deposit (Insurance Price)',insurancePrice, context),
                buildSubtotalItems('- ','Discount',widget.discount, context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              ],
            ),

            Divider(
              height: MediaQuery.of(context).size.height * 0.01,
              color: const Color(0xff8F3D96),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price: ${widget.calculateTotalPrice() - widget.discount + deliveryPrice} EGP',
                      // Apply discount here
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text('Get it within 3 days',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.008,
                        )),
                  ],
                ),
                Expanded(child: SizedBox()),
                widget.buildConfirmButton(),
              ],
            ),

            Text('The deposit amount is added to non-employees of our partners',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.008,
                )),
          ],
        ),
      ),
    );
  }

}

Widget buildSubtotalItems (sign,summeryType,price, context){
  return Row(
    children: [
      Text(
        '$sign', // Apply discount here
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.008,
        ),
      ),
      Text(
        ' $summeryType', // Apply discount here
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.008,
        ),
      ),
      Spacer(),
      Text(
        '$price EGP', // Apply discount here
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.008,
        ),
      ),
    ],
  );
}