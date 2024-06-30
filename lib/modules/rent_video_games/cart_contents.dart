import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

class CartContents extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<int, int> selectedCounts;
  final Function(int) removeItem;
  final double Function() calculateTotalPrice;

  CartContents({
    required this.cartItems,
    required this.selectedCounts,
    required this.removeItem,
    required this.calculateTotalPrice,
  });

  @override
  _CartContentsState createState() => _CartContentsState();
}

class _CartContentsState extends State<CartContents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MyThemeData.primaryColor, // Border color
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0), // Add border radius
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
              color: const Color(0xff8F3D96),
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
                                      fontSize: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.012,
                                    ),
                                  ),
                                  Text(
                                    'Price: ${item['price']} EGP',
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
                                  Text(
                                    'Used Price: ${item['used-price']} EGP',
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
                                  width: MediaQuery.of(context).size.width *
                                      0.05,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              'Total Price: ${widget.calculateTotalPrice()} EGP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.015,
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
      ),
    );
  }
}
