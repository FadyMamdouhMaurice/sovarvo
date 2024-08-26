import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/Admin/controller_control.dart';
import 'package:Sovarvo/modules/Admin/order_control.dart';
import 'package:Sovarvo/modules/Admin/prices_control.dart';
import 'package:Sovarvo/modules/Admin/ps_control.dart';
import 'package:Sovarvo/modules/Admin/stations_control.dart';
import 'package:Sovarvo/modules/Admin/users_data.dart';
import 'games_control.dart';

class AdminControlScreen extends StatefulWidget {
  AdminControlScreen({super.key});
  //static const String route = '/';

  @override
  State<AdminControlScreen> createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getFirebaseMessagingToken();
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
                width: 200,
                height: 200,
                child: Image.asset('assets/images/logo_final.png'),
              ),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PSCountScreen(),
                      ),
                    );
                  },
                  child: const Text('PS', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpareControllerScreen(),
                      ),
                    );
                  },
                  child: const Text('Spare Controller', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameCountScreen(),
                      ),
                    );
                  },
                  child: const Text('Games', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentalDetailsScreen(),
                      ),
                    );
                  },
                  child: const Text('Orders', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PriceControlScreen(),
                      ),
                    );
                  },
                  child: const Text('Prices', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PickupStationControlScreen(),
                      ),
                    );
                  },
                  child: const Text('Stations', style: TextStyle(
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserDataScreen(),
                      ),
                    );
                  },
                  child: const Text('Users', style: TextStyle(
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