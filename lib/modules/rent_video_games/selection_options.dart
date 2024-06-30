import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

class SelectionOptions extends StatefulWidget {
  final String selectedWay;
  final int selectedValue;
  final ValueChanged<String> onWayChanged;
  final ValueChanged<int> onValueChanged;

  SelectionOptions({
    required this.selectedWay,
    required this.selectedValue,
    required this.onWayChanged,
    required this.onValueChanged,
  });

  @override
  _SelectionOptionsState createState() => _SelectionOptionsState();
}

class _SelectionOptionsState extends State<SelectionOptions> {
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
                      fontSize: MediaQuery.of(context).size.width * 0.008,
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
                    });
                  },
                ),
                Text('New',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.008,
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
                    });
                  },
                ),
                Text('Used',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.008,
                    )),
              ],
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                    value: 0,
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
                        fontSize: MediaQuery.of(context).size.width * 0.008,
                      )),
                  Text('Pickup from nearest store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.007,
                      )),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            if (widget.selectedWay == 'rent')
              Container(
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
                      value: 1,
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
                          fontSize: MediaQuery.of(context).size.width * 0.008,
                        )),
                    Text('Receive your order at home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.007,
                        )),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
