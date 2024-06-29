import 'package:Sovarvo/modules/Admin/video_games.dart';
import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/Admin/controller_control.dart';
import 'package:Sovarvo/modules/Admin/order_control.dart';
import 'package:Sovarvo/modules/Admin/prices_control.dart';
import 'package:Sovarvo/modules/Admin/ps_control.dart';
import 'package:Sovarvo/modules/Admin/stations_control.dart';
import 'package:Sovarvo/modules/Admin/users_data.dart';
import 'package:Sovarvo/apis.dart';
import 'games_control.dart';

class AdminVGControlScreen extends StatefulWidget {
  AdminVGControlScreen({super.key});
  //static const String route = '/';

  @override
  State<AdminVGControlScreen> createState() => _AdminVGControlScreenState();
}

class _AdminVGControlScreenState extends State<AdminVGControlScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseMessagingToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8F3D96),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const videoGamesScreen(),
                      ),
                    );
                  },
                  child: const Text('Video Games', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}