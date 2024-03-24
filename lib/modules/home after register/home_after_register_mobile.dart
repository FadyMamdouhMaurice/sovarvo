import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/home%20screen/appbar_home_mobile.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/make_order/make_order_mobile.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import '../make_order/make_order_functions.dart';

// Initialize an empty map to store key-value pairs
Map<String, Map<String, dynamic>> gamesData = {};

class HomeAfterRegisterMobile extends StatelessWidget {
  const HomeAfterRegisterMobile({super.key});
  static const String route = '/home';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              // width: double.infinity,
              //   height: double.infinity,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Website-10.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    HomeAppBarMobile("Sign out", "assets/images/logo_final.png"),
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.03),
                            Text("Best games Best quality and more",
                                style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold,), textAlign: TextAlign.center),
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.08),
                            Text("Play anywhere, anytime ",
                                style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.center),
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.07),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        MakeOrderMobile.route,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    backgroundColor: MyThemeData.primaryColor,
                                  ),
                                  child: Text("Make an order",style:
                                  Theme.of(context).textTheme.labelSmall)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            const bottomNavigationBar(),
          ]),
        ),
      ),
    );
  }
 }