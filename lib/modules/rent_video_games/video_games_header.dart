// header_section.dart
import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';

class VideoGamesHeader extends StatelessWidget {
  final int cartCountItems;
  final TextEditingController searchText;
  final Function(String) onSearchChanged;
  final VoidCallback onCartPressed;

  VideoGamesHeader({
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
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo_final.png'),
                        fit: BoxFit.cover),
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
                          size: MediaQuery.of(context).size.width * 0.03,
                        )),
                    if(cartCountItems != 0)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: MyThemeData.primaryColor,
                        child: Text(
                          cartCountItems.toString(),
                          style: TextStyle(color: Colors.white),
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
                Spacer(),
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
                Spacer(),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          ],
        ),
      ),
    );
  }
}
