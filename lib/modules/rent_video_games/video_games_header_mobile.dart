// header_section.dart
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

class VideoGamesHeaderMobile extends StatelessWidget {
  final int cartCountItems;
  final TextEditingController searchText;
  final Function(String) onSearchChanged;
  final VoidCallback onCartPressed;

  VideoGamesHeaderMobile({
    required this.cartCountItems,
    required this.searchText,
    required this.onSearchChanged,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Video_game_bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (user?.uid == null) {
                      Navigator.of(context).pushNamed(
                          HomeScreenMobile.route);
                    }
                    else{
                      Navigator.of(context).pushNamed(
                          HomeAfterRegisterMobile.route);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo_final.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                Spacer(),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    IconButton(
                        onPressed: onCartPressed,
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.07,
                        )),
                    if(cartCountItems != 0)
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: MyThemeData.primaryColor,
                        child: Text(
                          cartCountItems.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'We Aim To Reach You Anytime & Everywhere Your Satisfaction Is Our Mission',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                    )),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchText,
                    onChanged: onSearchChanged,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          searchText.clear();
                          onSearchChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}