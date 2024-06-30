import 'package:flutter/material.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:Sovarvo/shared/terms_conditions_lang_widgets.dart';

class TermsConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(
          color: MyThemeData.primaryColor, // Border color
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0), // Add border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'الشروط والأحكام لموقع تأجير أسطوانات ألعاب البلايستيشن',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.012,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              buildArabicTerms(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'Terms and Conditions for Renting PlayStation Game Discs',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.012,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              buildEnglishTerms(),
            ],
          ),
        ),
      ),
    );
  }
}
