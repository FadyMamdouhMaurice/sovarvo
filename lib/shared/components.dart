import 'package:flutter/material.dart';
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/signin/signin_mobile.dart';

import '../layout/home_screen.dart';
import '../modules/signin/signin.dart';
import 'my_theme.dart';

Widget defaultTextFeild({
  Iterable<String>? autofill,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String lableText,
  IconData? suffixIcon,
  var suffixPressed, // var not function because of null safety;
  bool isObscure = false,
  int? maxLength,
  bool readOnly = false,
  void Function(String)? onChanged, // add onChanged callback
  String? Function(String?)? validateFunction}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofillHints:autofill,
        maxLength: maxLength,
        validator: validateFunction,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isObscure,
        readOnly: readOnly,
        onChanged: (value) {
          onChanged?.call(value); // call onChanged callback
        },
        style: const TextStyle(color: Colors.black, fontSize: 20),
        decoration: InputDecoration(
          suffixIcon: suffixIcon != null
              ? IconButton(
            icon: Icon(
              suffixIcon,
            ),
            onPressed: suffixPressed,
          ) : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.black), // White border color when focused
          ),
          hintText: lableText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );

Widget appBarSignInOut(BuildContext context, String caption, String img) =>
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (caption == "Sign in") {
                Navigator.of(context).pushNamed(
                    HomeScreen.route);
              }
              else if (caption == "Sign out") {
                Navigator.of(context).pushNamed(
                    HomeAfterRegister.route);
              } else {
                Navigator.of(context).pushNamed(
                    HomeScreen.route);
              }
            },
            child: Container(
              height: 150,
              width: 150,
              decoration:
              BoxDecoration(image: DecorationImage(image: AssetImage(img))),
            ),
          ),
          InkWell(
            onTap: () {
              if (caption == "Sign in") {
                Navigator.of(context).pushNamed(
                    SignIn.route);
              } else if (caption == "Sign out") {
                Navigator.of(context).pushNamed(
                    HomeScreen.route);
              }
            },
            child: Text(
              caption,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );

Widget appBarSignInOutMobile(BuildContext context, String caption,
    String img) =>
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (caption == "Sign in") {
                Navigator.of(context).pushNamed(
                    HomeScreenMobile.route);
              }

              else if (caption == "Sign out") {
                Navigator.of(context).pushNamed(
                    HomeAfterRegisterMobile.route);
              }
              else {
                Navigator.of(context).pushNamed(
                    HomeScreenMobile.route);
              }
            },
            child: Container(
              height: 150,
              width: 150,
              decoration:
              BoxDecoration(image: DecorationImage(image: AssetImage(img))),
            ),
          ),
          InkWell(
            onTap: () {
              if (caption == "Sign in") {
                Navigator.of(context).pushNamed(
                    SignInMobile.route);
              } else if (caption == "Sign out") {
                Navigator.of(context).pushNamed(
                    HomeScreenMobile.route);
              }
            },
            child: Text(
              caption,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );

Widget extentionItem({
  required BuildContext context,
  required String title,
  required String details,
}) {
  // Splitting the details into separate lines
  List<String> detailLines = details.split('\n');
  return ExpansionTile(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    collapsedShape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    iconColor: Colors.white,
    collapsedIconColor: Colors.white,
    backgroundColor: MyThemeData.greyTextColor,
    tilePadding: EdgeInsetsDirectional.symmetric(
        horizontal: MediaQuery
            .of(context)
            .size
            .width * 0.01,
        vertical: MediaQuery
            .of(context)
            .size
            .height * 0.01),
    collapsedBackgroundColor: MyThemeData.greyTextColor,
    title: Text(title, style: Theme
        .of(context)
        .textTheme
        .labelMedium),
    children: <Widget>[
      ListTile(
          title: Text(details,
              style: Theme
                  .of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontWeight: FontWeight.w200))),
    ],
  );
}
