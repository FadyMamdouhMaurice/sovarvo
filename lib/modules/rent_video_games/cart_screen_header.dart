// header_section.dart
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:flutter/material.dart';

class CartScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Video_game_bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Center items in this row
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).pushReplacementNamed(
                  HomeAfterRegister.route);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_final.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          Flexible( // Use Flexible to prevent overflow on smaller screens
            child: Text(
              'We Aim To Reach You Anytime & Everywhere Your Satisfaction Is Our Mission',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
