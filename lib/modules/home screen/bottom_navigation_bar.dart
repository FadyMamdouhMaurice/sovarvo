import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class bottomNavigationBar extends StatelessWidget {
  const bottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.black),
      padding: EdgeInsetsDirectional.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05,
          //horizontal: MediaQuery.of(context).size.height * 0.05
      ),
      child: Column(
        children: [
          //Container(height: 1, color: Colors.grey[300]),
          //SizedBox(height: MediaQuery.of(context).size.height * 0.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Find us on social media', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: MediaQuery.of(context).size.width* 0.04,),
              GestureDetector(
                onTap: () => _launchMyAcounts('https://www.instagram.com/sovarvo/'),
                child: SvgPicture.asset(
                  'assets/icons/instagram.svg',
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.001,),
              GestureDetector(
                onTap: () => _launchMyAcounts('https://www.linkedin.com/company/sovarvo/'),
                child: SvgPicture.asset(
                  'assets/icons/linkedin.svg',
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.001,),
              GestureDetector(
                onTap: () => _launchMyAcounts('https://wa.me/201098285931'),
                child: SvgPicture.asset(
                  'assets/icons/whatsapp.svg',
                  width: 50,
                  height: 50,
                ),
              ),

            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.copyright,color: Colors.grey, size: 15),
              SizedBox(width: MediaQuery.of(context).size.width * 0.005,),
              const Text('Built by Fady Mamdouh, connect with him', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.005,),
              GestureDetector(
                onTap: () => _launchMyAcounts('https://www.linkedin.com/in/fadymamdouh-23/'),
                child: SvgPicture.asset(
                  'assets/icons/linkedin.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchMyAcounts(String uri) async {
    final Url = Uri.parse(uri);
    if (await canLaunchUrl(Url)) {
      await launchUrl(Url);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
//https://www.linkedin.com/company/sovarvo/