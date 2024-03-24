import 'package:flutter/material.dart';

import '../../shared/my_theme.dart';

class TotalSection extends StatefulWidget {
  final int price;

  const TotalSection({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  State<TotalSection> createState() => _TotalSectionState();
}

class _TotalSectionState extends State<TotalSection> {
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text("Total = ",
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black, fontSize: 35)),
            ),
            Expanded(
              child: Text("${widget.price} L.E",
                  softWrap: true,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: MyThemeData.greyTextColor, fontSize: 35)),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
      ],
    );
  }
}
