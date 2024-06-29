import 'package:Sovarvo/apis.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/make_order/make_order_functions.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/signin/signin_mobile.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import '../../shared/components.dart';
import 'date_section.dart';
import 'game_section.dart';

bool availableDate = true;

class MakeOrderMobile extends StatefulWidget {
  const MakeOrderMobile({super.key});
  static const String route = '/makeorder';

  @override
  State<MakeOrderMobile> createState() => _MakeOrderMobileState();
}

class _MakeOrderMobileState extends State<MakeOrderMobile> {
  var searchController = TextEditingController();
  List<String> selectedGames = [];
  List<double> selectedGamesPrice = [];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedController;
  String? selectedStation;
  int numberOfDays = 0;
  double totalPrice = 0; // Initialize totalPrice
  String loginOrNot = 'Sign out';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPricesData();
    selectedController = '0 Controllers';
    initializeAsyncTasks();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              appBarSignInOutMobile(context, loginOrNot, "assets/images/LOGOS-02.png"),
              Container(height: 5, color: Colors.grey[300]),
              /////////////////////////////////////////////////////all column
              Column(
                children: [
                  //const CompanyWorkSection(),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.05,
                      horizontal: MediaQuery.of(context).size.width * 0.05
                    ),
                    child: Column(
                        children: [
                          Container(
                            height: 450,
                            width: 450,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/images/ps5.png'))),
                          ),
                      //////////////////////////////////////////////////////////////////////1
                      SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GameSection(
                                  onGamesSelected: handleGamesSelected,
                                ),
                              ],
                            ),
                          )),
                      /////////////////////////////////////////////////////////////////////////////2
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.06,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              DateSection(
                                onStartDateSelected: handleStartDateSelected,
                                onEndDateSelected: handleEndDateSelected,
                                onControllerSelected: handleControllerSelected,
                                onStationSelected: handleStationSelected,
                                onNumberOfDaysCalculated:
                                handleNumberOfDaysCalculated,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //////////////////////////////////////////////////////////////////////3
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        child: Column(
                          children: [
                            //TotalSection( price: totalPrice,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text("Total = ",
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context).size.width * 0.08)),
                                ),
                                Expanded(
                                  child: Text("$totalPrice L.E",
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                          color: MyThemeData.greyTextColor,
                                          fontSize: MediaQuery.of(context).size.width * 0.08)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.025,
                            ),
                            InkWell(
                              onTap: () {
                                //print(selectedController);
                                checkUserSignInMobile();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      MyThemeData.primaryColor,
                                      Colors.blue,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                width: double.infinity,
                                height:
                                MediaQuery.of(context).size.height * 0.08,
                                child: Center(
                                  child: Text("Let's do it",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const bottomNavigationBar(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleStartDateSelected(DateTime? startDate) {
    setState(() {
      selectedStartDate = startDate;
    });
    calculateNumberOfDays();
    // Perform any additional logic here if needed
  }

  void handleEndDateSelected(DateTime? endDate) {
    setState(() {
      selectedEndDate = endDate;
    });
    calculateNumberOfDays();
    updateTotalPrice(); // Recalculate total price when games are selected

    // Perform any additional logic here if needed
  }

  void handleControllerSelected(String? controller) {
    setState(() {
      selectedController = controller;
      updateTotalPrice(); // Recalculate total price when games are selected
    });
  }

  void handleStationSelected(String? station) {
    setState(() {
      selectedStation = station;
    });
  }

  void handleNumberOfDaysCalculated(int days) {
    setState(() {
      numberOfDays = days;
      updateTotalPrice(); // Recalculate total price when games are selected
    });
  }

  void handleGamesSelected(List<String> games, List<double> price) {
    setState(() {
      selectedGames = games;
      selectedGamesPrice = price;

      updateTotalPrice(); // Recalculate total price when games are selected
    });
  }

  int calculateNumberOfDays() {
    if (selectedStartDate != null && selectedEndDate != null) {
      final difference = selectedEndDate!.difference(selectedStartDate!).inDays;
      setState(() {
        numberOfDays = difference + 1;
      });
      return difference + 1;
    }
    return 0;
  }

  void updateTotalPrice() {
    /*if (selectedStartDate != null &&
        selectedEndDate != null &&
        selectedController != null &&
        numberOfDays > 0) {
      selectedController = extractNumericPart(selectedController!);
      totalPrice = (prices.psPrice +
              (prices.controllerPrice * int.parse(selectedController!)) / 2 +
              (prices.dayPrice * numberOfDays) +
              (prices.gamePrice * selectedGames.length))
          .toInt();
    } else {
      totalPrice = 0;
    }*/
    selectedController = extractNumericPart(selectedController!);

    double sum = 0;
    for (int i = 0; i < selectedGamesPrice.length; i++) {
      sum += selectedGamesPrice[i];
    }

    // If the user selects 1 or 2 controllers, set the controller price to 0
    int controllerPrice = (int.parse(selectedController!) <= 2) ? 0 : prices.controllerPrice;

    totalPrice = (prices.psPrice * numberOfDays +
        (controllerPrice * (int.parse(selectedController!)) / 2 * numberOfDays ) +
        (sum * numberOfDays))
        .toDouble();
    //(prices.dayPrice * numberOfDays) +

    setState(() {});
  }

  String extractNumericPart(String input) {
    // Split the input string by space
    List<String> parts = input.split(' ');

    // Get the first part (should be the number)
    String numericPart = parts.isNotEmpty ? parts[0] : '';

    // Trim any leading or trailing whitespace
    return numericPart.trim();
  }

  void _showConfirmation(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 4), // Adjust duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void letsDoItNow() {
    if (selectedController == '0 Controllers') {
      _showConfirmation(context, 'Choose how many of controller you want');
    } else if (selectedStartDate == null && selectedEndDate == null) {
      _showConfirmation(context, 'Choose your rental period');
    } else if (selectedGames.isEmpty) {
      _showConfirmation(context, 'Choose your games');
    } else if (selectedStation == null) {
      _showConfirmation(context, 'Choose your pick up station');
    } else if(!availableDate){
      _showConfirmation(context, 'The selected dates contains disabled dates. Please choose a different dates.');
    }
    else {
      updateTotalPrice();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Update',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  )),
              content: const Text('Are you sure you want to rental?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                ),
                TextButton(
                  onPressed: () async {
                    await addUserRental(
                        selectedStartDate!,
                        selectedEndDate!,
                        selectedGames,
                        int.parse(selectedController!),
                        selectedStation!, 
                        totalPrice);

                    List<String> t = await getAllAdminsTokens();
                    await sendPushNotification(t);

                    Navigator.of(context).pop(); // Close dialog
                    _showConfirmation(context,
                        'Your order has been reserved! Wait for a call from us'); // Show confirmation message
                    Navigator.of(context).pushNamed(
                      HomeAfterRegisterMobile.route,
                    );
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          });
    }
    setState(() {

    });
  }
  Future<void> checkUserSignInMobile() async {
    if (user == null) {
      loginOrNot = 'Sign in';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign In Required', style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            )),
            content: Text('You need to sign in to can continue.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to sign-in screen or any authentication flow
                  Navigator.of(context).pushNamed(
                      SignInMobile.route);
                },
                child: Text('Sign In', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
              ),
            ],
          );
        },
      );
    } else {
      // Continue with the existing logic for handling the order
      // ...
      letsDoItNow();
    }
  }
  Future<void> initializeAsyncTasks() async {
    // Perform your asynchronous tasks here
    await getRentalDatesFromFirebase();
    await getPSCount();
    await initializeGamesData();
    await checkUserSignInTextMobile();
    setState(() {
      // Update the widget state if needed
    });
  }
  checkUserSignInTextMobile() {
    if(user == null){
      loginOrNot = 'Sign in';
    }
    else {
      loginOrNot = 'Sign out';
    }
  }
}