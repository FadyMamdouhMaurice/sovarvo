import 'package:Sovarvo/apis.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_screen_mobile.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/video_games_header_mobile.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:flutter/material.dart';

import '../realtime_firebase/users.dart';

class RentVideoGamesMobile extends StatefulWidget {
  const RentVideoGamesMobile({super.key});

  static const String route = '/rentvideogames';

  @override
  State<RentVideoGamesMobile> createState() => _RentVideoGamesMobileState();
}

class _RentVideoGamesMobileState extends State<RentVideoGamesMobile> {
  //List<String> videoGamesSelected = [];
  List<double> videoGamesSelectedPrices = [];
  Map<String, bool> buttonDisabledStates =
      {}; // Track disabled state of buttons
  Map<String, bool> notifyMeStates =
      {}; // Track "Notify Me When Available" state
  Map<String, Map<String, dynamic>> videoGames = {};
  Map<String, Map<String, dynamic>> filteredVideoGamesData = {};
  String newVideoGameName = '';
  String newVideoGameImageUrl = '';
  int newVideoGamePrice = 0;
  int rentVideoGamePrice = 0;
  int usedVideoGamePrice = 0;
  int videoGameCount = 0;
  String availableDate = '';
  String _sortOption = 'Price (New)';
  String buttonText = 'Add To Cart';
  TextEditingController searchText = TextEditingController();
  bool isLoading = true;
  final CartHelpers cartHelpers = CartHelpers();

  @override
  void initState() {
    super.initState();
    loadCartItems();
    initializeAsyncTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  VideoGamesHeaderMobile(
                    cartCountItems: cartItems.length,
                    searchText: searchText,
                    onSearchChanged: (value) {
                      setState(() {
                        videoGamesData =
                            searchVideoGames(value, filteredVideoGamesData);
                      });
                    },
                    onCartPressed: () async {
                      Navigator.of(context).pushNamed(CartScreenMobile.route);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          'Sort By:',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        DropdownButton<String>(
                          value: _sortOption,
                          icon:
                              Icon(Icons.sort, color: MyThemeData.primaryColor),
                          dropdownColor: Colors.grey[800],
                          style: TextStyle(color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              _sortOption = newValue!;
                              videoGamesData =
                                  sortVideoGames(videoGamesData, _sortOption);
                            });
                          },
                          items: <String>['Name', 'Price (New)', 'Price (Used)', 'Price (Rent)', 'Availability']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        //childAspectRatio: 0.8,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      itemCount: videoGamesData.length,
                      itemBuilder: (context, index) {
                        String gameName = videoGamesData.keys.elementAt(index);
                        int count = videoGamesData[gameName]?['count'] ?? 0;
                        String imageUrl =
                            videoGamesData[gameName]?['image-url'] ?? '';
                        int price = videoGamesData[gameName]?['price'] ?? 0;
                        int rent_price =
                            videoGamesData[gameName]?['rent-price'] ?? 0;
                        int used_price =
                            videoGamesData[gameName]?['used-price'] ?? 0;
                        String available_date =
                            videoGamesData[gameName]?['available-date'] ?? '';
                        int saveMoney = used_price - rent_price;

                        int insurancePrice =
                            videoGamesData[gameName]?['insurance-price'] ?? 0;

                        bool isInCart =
                            cartItems.any((item) => item['name'] == gameName);
                        buttonText = isInCart
                            ? 'Added To Cart Successfully'
                            : 'Add To Cart';

                        //if (count > 0) { buttonText = 'Add To Cart';}
                        if (count == 0) {
                          buttonText = 'Notify Me When Available';
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyThemeData.primaryColor, // Border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // Add border radius
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              if (count == 0)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: Text("Available on: $available_date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                ),
                              if (count > 0)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Expanded(
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.6,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.contain,
                                                  // You might want to adjust the width and height
                                                  // according to your UI requirements
                                                )
                                              : const CircularProgressIndicator(),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MyThemeData.primaryColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              5.0,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Rent and Save $saveMoney EGP',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    alignment: AlignmentDirectional.topStart,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Text('$gameName',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text('New',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        )),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Text('$price',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                  Text(' EGP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text('Used',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        )),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Text('$used_price',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                  Text(' EGP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text('Rent per month',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        )),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Text('$rent_price',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                  Text(' EGP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              if (count > 0)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: ElevatedButton(
                                    onPressed: isInCart
                                        ? null
                                        : () {
                                            if (isInCart) return;

                                            setState(() {
                                              //cartCountItems++;
                                              /*if (!cartGames.contains(gameName)) {
                                  //cartGames.add(gameName);

                                }*/
                                              cartItems.add({
                                                'name': gameName,
                                                'count': count,
                                                'image-url': imageUrl,
                                                'price': price,
                                                'rent-price': rent_price,
                                                'used-price': used_price,
                                                'available-date':
                                                    available_date,
                                                'insurance-price' : insurancePrice
                                              });
                                              buttonDisabledStates[gameName] =
                                                  true; // Disable button after click
                                            });
                                            saveCartItems();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: MyThemeData.primaryColor,
                                    ),
                                    child: Text("$buttonText",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                        )),
                                  ),
                                ),
                              if (count == 0)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: ElevatedButton(
                                    onPressed: notifyMeStates[gameName] == true
                                        ? null
                                        : () async {
                                            await cartHelpers.checkUserSignIn(
                                                context, user);

                                            if (await cartHelpers
                                                .checkUserSignIn(
                                                    context, user)) {
                                              List<String> t =
                                                  await getAllAdminsTokens();
                                              sendPushNotificationForRequestUserNotifyWhenAvailable(
                                                  t, gameName);
                                              setState(() {
                                                notifyMeStates[gameName] = true;
                                                buttonText =
                                                    'You Will Be Notified';
                                              });
                                            } else {
                                              await cartHelpers.checkUserSignIn(
                                                  context, user);
                                            }
                                            return;
                                          },
                                    child: Text(
                                      notifyMeStates[gameName] == true
                                          ? 'You Will Be Notified'
                                          : buttonText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: MyThemeData.primaryColor,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const bottomNavigationBar(),
                ],
              ),
            ),
    );
  }

  Future<void> initializeAsyncTasks() async {
    // Perform your asynchronous tasks here
    await initializeVideoGamesData();
    setState(() {
      // Update the widget state if needed
      // Sort video games by price after loading
      filteredVideoGamesData = sortVideoGames(videoGamesData, _sortOption);
      videoGamesData = filteredVideoGamesData; // Initialize display data+
      isLoading = false; // Set loading to false once data is loaded
    });
  }
}
