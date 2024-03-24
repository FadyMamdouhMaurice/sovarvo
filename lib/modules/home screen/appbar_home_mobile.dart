import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/signin/signin_mobile.dart';

import '../../shared/my_theme.dart';

class HomeAppBarMobile extends StatefulWidget {
  String buttonCaption;
  String img;

  HomeAppBarMobile(this.buttonCaption, this.img, {super.key});

  @override
  State<HomeAppBarMobile> createState() => _HomeAppBarMobileState();
}

class _HomeAppBarMobileState extends State<HomeAppBarMobile> {
  // Initial Selected Value
  String? dropdownvalue = 'English';

  // List of items in our dropdown menu
  //var items = ['English', 'Arabic'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(widget.img))),
          ),
          Row(
            children: [
              /*Container(
                //padding: EdgeInsetsDirectional.only(start: 30, end: 10),
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyThemeData.whiteTextColor),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      dropdownvalue ?? 'Select Item',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.black),
                              ),
                            ))
                        .toList(),
                    value: dropdownvalue,
                    onChanged: (String? value) {
                      setState(() {
                        dropdownvalue = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.31,
                height: MediaQuery.of(context).size.height * 0.065,
                child: ElevatedButton(
                    onPressed: () async {
                      if (widget.buttonCaption == "Sign in") {
                        /*Provider.of<NavigationProvider>(context, listen: false)
                            .updateScreen('/signIn');
                        */
                        Navigator.of(context).pushNamed(
                          SignInMobile.route,
                        );
                      } else if (widget.buttonCaption == "Sign out") {
                        await FirebaseAuth.instance.signOut();
                        user = null;
                        Navigator.of(context).pushNamed(
                          HomeScreenMobile.route,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: MyThemeData.primaryColor,
                    ),
                    child: Text(widget.buttonCaption,
                        style: Theme.of(context).textTheme.labelSmall)),
              )
            ],
          )
        ],
      ),
    );
  }
}