import 'package:Sovarvo/modules/Admin/admin_control_screen.dart';
import 'package:Sovarvo/modules/Admin/admin_vg_control.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add your action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminControlScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: MyThemeData.primaryColor,
                          // Border color
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                            10.0), // Add border radius
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Image.asset('assets/images/ps5.png'),
                          ),
                          Text(
                            'Manage PS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.03
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                  GestureDetector(
                    onTap: () {
                      // Add your action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminVGControlScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: MyThemeData.primaryColor,
                          // Border color
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                            10.0), // Add border radius
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Image.asset('assets/images/FC24.png'),
                          ),
                          Text(
                            'Manage Video Games',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
