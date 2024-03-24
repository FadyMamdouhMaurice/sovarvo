import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/make_order/make_order.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import '../home screen/appbar_home.dart';
import '../make_order/make_order_functions.dart';

class HomeAfterRegister extends StatelessWidget {
  const HomeAfterRegister({super.key});
  static const String route = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  HomeAppBar("Sign out", "assets/images/logo_final.png"),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Welcome back!",
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text("Best games, Best quality, and more",
                            style: Theme.of(context).textTheme.labelLarge),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text("Play anywhere, anytime ",
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.5,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pushNamed(
                                    MakeOrder.route);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: MyThemeData.primaryColor,
                              ),
                              child: Text("Make an order",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          const bottomNavigationBar(),
        ]),
      ),
    );
  }
}
