import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register_mobile.dart';
import 'package:Sovarvo/modules/home%20screen/appbar_home_mobile.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/shared/components.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:email_validator/email_validator.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});
  static const String route = '/';

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {

  late TextEditingController emailController;
  late ScrollController scrollController;
  late bool emailTextEmpty;
  late String errorMassage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    emailTextEmpty = true;
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
              children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Website-10.jpg'),
                      fit: BoxFit.cover
                  ),
                ),
                child: Stack(
                  // alignment: Alignment.topRight,
                  children: [
                    HomeAppBarMobile("Sign in", "assets/images/logo_final.png"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2),
                          const Text("Level Up Your Fun: Rent PS5, Play Anywhere", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06),
                          const Text("Embark on an exciting gaming journey with our PS5 rentals. Immerse yourself in endless entertainment with our diverse game library. Your ultimate gaming experience starts now!",
                              style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.center),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      style: TextStyle(
                                          color: MyThemeData.whiteTextColor,
                                          fontSize: MediaQuery.of(context).size.width * 0.04),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: MyThemeData.whiteTextColor)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: MyThemeData
                                                    .whiteTextColor), // White border color when focused
                                          ),
                                          hintText: 'Enter your email to create your journey',
                                          hintStyle: TextStyle(
                                              color: MyThemeData.greyTextColor,
                                              fontSize: MediaQuery.of(context).size.width * 0.04),
                                          fillColor: Colors.grey.withOpacity(0.3),
                                          filled: true),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                  if(!emailTextEmpty)
                                    Row(
                                      children: [
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                                        Text(errorMassage,
                                            style: const TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          vaildEmail();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          backgroundColor: MyThemeData.primaryColor,
                                        ),
                                        child: Text("Get Start",
                                            style:
                                            Theme.of(context).textTheme.labelSmall)),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                                  if(!emailTextEmpty)
                                    Row(
                                      children: [
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                                        Text("",
                                            style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.black),
                  padding: EdgeInsetsDirectional.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.09),
                  child: Column(
                    children: [
                      Text("Frequently Asked Question",
                          style: Theme.of(context).textTheme.labelLarge),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(children: [
                          extentionItem(
                            context: context,
                            title: 'What is Sovarvo ?',
                            details:
                            'Sovarvo is a gaming rental service specializing in providing video game consoles and games for PS5 (PlayStation 5).\nOur goal is to relieve our customers of life or professional stress and make them happier by providing. our unique entertainment services.\nOur vision is to normalize happiness.',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          extentionItem(
                              context: context,
                              title: 'How much does cost?',
                              details:
                              "Our service offers a package deal including PS5, 2 controllers, and FIFA for just 350 Egyptian pounds for two days.\nAnd if you want to add more games from our library, it's just an extra fee of 10 to 30 Egyptian pounds per day.\nSo, all in all, it's a great deal for your gaming needs!"),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          extentionItem(
                              context: context,
                              title: 'Where will I pick up my order ?',
                              details:
                              "Your order can be picked up from specific locations across Cairo city, and you have the flexibility to choose the most convenient one for you during the ordering process.\nSome of these locations include Al Manhal in Nasr City, City Stars in Nasr City, Maadi Metro Station, Maadi Sporting Club and Yacht Club, Ramses Square, Ghamra, and New Cairo Court.\nIf you have any suggestions for additional pickup locations, feel free to reach out to us via direct messages on our social media."),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          extentionItem(
                              context: context,
                              title: 'What can i play ?',
                              details:
                              "At Sovarvo, we offer a variety of great options for you to choose from. Dive into our library and explore the latest and greatest games! We're constantly updating and expanding based on your requests, ensuring there's always something exciting to play.\nIf you have a specific game in mind you'd like to see added, just drop us a message on our social media.\nLet the gaming adventures begin!"),
                        ]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Text("Level Up Your Fun: Rent PS5,\nPlay Anywhere",
                          style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text("Ready to play",
                          style: Theme.of(context).textTheme.labelSmall),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                            onPressed: () {
                              vaildEmail();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: MyThemeData.primaryColor,
                            ),
                            child: Text("Let's do it",
                                style: Theme.of(context).textTheme.labelMedium)),
                      )
                    ],
                  )),
            ),
            const bottomNavigationBar(),
          ]),
        ),
      ),
    );
  }

  void vaildEmail()
  {
    if(emailController.text.isEmpty){
      emailTextEmpty = false;
      errorMassage = 'Please enter your Email';
      scrollController.animateTo(0, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      setState(() {

      });
    }
    else if(!EmailValidator.validate(emailController.text)){
      emailTextEmpty = false;
      errorMassage = 'Please enter valid Email';
      scrollController.animateTo(0, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      setState(() {

      });
    }
    else {
      Navigator.of(context).pushNamed(
          CompleteRegisterMobile.route,
          arguments: emailController.text
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailTextEmpty = true;
    super.dispose();
  }
}