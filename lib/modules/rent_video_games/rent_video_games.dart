import 'package:Sovarvo/apis.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_screen.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/video_games_header.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:flutter/material.dart';

class RentVideoGames extends StatefulWidget {

  const RentVideoGames({super.key});

  static const String route = '/rentvideogames';

  @override
  State<RentVideoGames> createState() => _RentVideoGamesState();
}

class _RentVideoGamesState extends State<RentVideoGames> {
  //List<String> videoGamesSelected = [];
  List<double> videoGamesSelectedPrices = [];
  //List<String> cartGames = []; // Track games added to cart
  //int cartCountItems = 0;
  Map<String, bool> buttonDisabledStates = {}; // Track disabled state of buttons
  Map<String, bool> notifyMeStates = {}; // Track "Notify Me When Available" state

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
    initializeAsyncTasks();
    loadCartItems();
    setState(() {
      // Your logic here
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body:  isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            VideoGamesHeader(
              cartCountItems: cartItems.length,
              searchText: searchText,
              onSearchChanged: (value) {
                setState(() {
                  videoGamesData = searchVideoGames(value, filteredVideoGamesData);
                });
              },
              onCartPressed: () async {
                Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
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
                  icon: Icon(Icons.sort, color: MyThemeData.primaryColor),
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  //childAspectRatio: 0.8,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24),
              itemCount: videoGamesData.length,
              itemBuilder: (context, index) {
                String gameName = videoGamesData.keys.elementAt(index);
                int count = videoGamesData[gameName]?['count'] ?? 0;
                String imageUrl = videoGamesData[gameName]?['image-url'] ?? '';
                double price = videoGamesData[gameName]?['price'] ?? 0;
                double rent_price =
                    videoGamesData[gameName]?['rent-price'] ?? 0;
                double used_price =
                    videoGamesData[gameName]?['used-price'] ?? 0;
                String available_date =
                    videoGamesData[gameName]?['available-date'] ?? '';
                double saveMoney = used_price - rent_price;
                int insurancePrice =
                    videoGamesData[gameName]?['insurance-price'] ?? 0;
                //bool isSelected = videoGamesSelected.contains(gameName); //List<String> gamesSelected = [];
                /*buttonText = cartGames.contains(gameName)
                    ? 'Added To Cart Successfully'
                    : 'Add To Cart';*/

                bool isInCart = cartItems
                    .any((item) => item['name'] == gameName);
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
                    borderRadius:
                        BorderRadius.circular(10.0), // Add border radius
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      if (count == 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text("Available on: $available_date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.011,
                              )),
                        ),
                      if (count > 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.02,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.15,
                                        height: MediaQuery.of(context).size.height * 0.8,
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          // You might want to adjust the width and height
                                          // according to your UI requirements
                                        )
                                            : const CircularProgressIndicator(),
                                      ),
                                    ],
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
                                    height: MediaQuery.of(context).size.height * 0.04,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Rent and Save $saveMoney EGP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context).size.width * 0.008,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text('$gameName',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.015,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.075,
                            child: Text('New',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.008,
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text('$price',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                          Text(' EGP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.075,
                            child: Text('Used',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.008,
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text('$used_price',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                          Text(' EGP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.075,
                            child: Text('Rent per month',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.008,
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text('$rent_price',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                          Text(' EGP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.008,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      if (count > 0)
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.04,
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
                                'available-date': available_date,
                                'insurance-price' : insurancePrice

                              });
                              buttonDisabledStates[gameName] = true; // Disable button after click
                            });
                            saveCartItems(); // Save to cache after adding item
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: MyThemeData.primaryColor,
                          ),
                          child: Text("$buttonText",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.009,
                              )),
                        ),
                      ),
                      if (count == 0)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: ElevatedButton(
                            onPressed: notifyMeStates[gameName] == true ? null : () async {
                              if(count == 0){
                                await cartHelpers.checkUserSignIn(context, user);

                                if(await cartHelpers.checkUserSignIn(context, user)){
                                  List<String> t = await getAllAdminsTokens();
                                  sendPushNotificationForRequestUserNotifyWhenAvailable(t,gameName);
                                  setState(() {
                                    notifyMeStates[gameName] = true;
                                    buttonText = 'You Will Be Notified';
                                  });
                                 }
                                 else{
                                   await cartHelpers.checkUserSignIn(context, user);
                                 }
                                 return;
                              }

                              /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'You will be notified when $gameName is available.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );*/
                            },
                            child: Text(
                              notifyMeStates[gameName] == true
                                  ? 'You Will Be Notified'
                                  : buttonText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.009,
                                ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: MyThemeData.primaryColor,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                );
              },
            ),
            /*ElevatedButton(onPressed: (){
              setState(() {

              });
            }, child: SizedBox()),*/
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            bottomNavigationBar(),
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