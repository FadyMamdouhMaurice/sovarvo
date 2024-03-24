import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/layout/home_screen.dart';
import 'package:Sovarvo/modules/Admin/admin_control_screen.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register_mobile.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/make_order/make_order.dart';
import 'package:Sovarvo/modules/make_order/make_order_mobile.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/signin/signin.dart';
import 'package:Sovarvo/modules/signin/signin_mobile.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

/*class NavigationProvider extends ChangeNotifier {
  String _currentScreen = '/home';

  String get currentScreen => _currentScreen;

  void updateScreen(String screen) {
    _currentScreen = screen;
    _storeScreen(screen); // Store the current screen in SharedPreferences
    notifyListeners();
  }

  // Function to store the current screen in SharedPreferences
  Future<void> _storeScreen(String screen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentScreen', screen);
  }
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: user != null ? getUserData() : null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: const Color(0xff8F3D96),),
            ],
          );
        }
        else if (snapshot.hasError) {
          // Error while fetching data
          return Text('Error: ${snapshot.error}');
        }
        else {
          return ScreenTypeLayout.builder(
            desktop: (p0) => AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: const Color(0xff8F3D96),
              ),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: MyThemeData.lightTheme,
                darkTheme: MyThemeData.darkTheme,
                initialRoute: '/makeorder',
                routes: {
                  HomeScreen.route: (context) => HomeScreen(),
                  SignIn.route: (context) => SignIn(),
                  CompleteRegister.route: (context) {
                    final String? email = ModalRoute.of(context)?.settings.arguments as String?;
                    return CompleteRegister(email: email ?? '',); // Pass the email to CompleteRegister
                  },
                  HomeAfterRegister.route: (context) => HomeAfterRegister(),
                  MakeOrder.route: (context) => MakeOrder(),
                },
                //home: const HomeScreen()
              ),
            ),
            mobile: (p0) => MaterialApp(debugShowCheckedModeBanner: false,
                theme: MyThemeData.lightTheme,
                darkTheme: MyThemeData.darkTheme,
                home: MakeOrderMobile()),
                /*AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: const Color(0xff8F3D96),
              ),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: MyThemeData.lightTheme,
                darkTheme: MyThemeData.darkTheme,
                initialRoute: '/',
                routes: {
                  HomeScreen.route: (context) => HomeScreenMobile(),
                  SignIn.route: (context) => SignInMobile(),
                  CompleteRegister.route: (context) {
                    final String? email = ModalRoute.of(context)?.settings.arguments as String?;
                    return CompleteRegisterMobile(email: email ?? '',); // Pass the email to CompleteRegister
                  },
                  HomeAfterRegister.route: (context) => HomeAfterRegisterMobile(),
                  MakeOrder.route: (context) => MakeOrderMobile(),
                },
                //home: const HomeScreen()
              ),
            ),*/
            breakpoints: const ScreenBreakpoints(
              desktop: 500,
              watch: 0.0,
              tablet: 0.0,
            ),
          );
        }
      },
/*
      child: ScreenTypeLayout.builder(
          desktop: (p0) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: MyThemeData.lightTheme,
              darkTheme: MyThemeData.darkTheme,
              initialRoute: '/',
              routes: {
                HomeScreen.route: (context) => HomeScreen(),
                SignIn.route: (context) => SignIn(),
                CompleteRegister.route: (context) {
                  final String? email = ModalRoute.of(context)?.settings.arguments as String?;
                  return CompleteRegister(email: email ?? '',); // Pass the email to CompleteRegister
                },
                HomeAfterRegister.route: (context) => HomeAfterRegister(),
                MakeOrder.route: (context) => MakeOrder(),
              },
              //home: const HomeScreen()
          ),
          mobile: (p0) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MyThemeData.lightTheme,
            darkTheme: MyThemeData.darkTheme,
            initialRoute: '/',
            routes: {
              HomeScreen.route: (context) => HomeScreenMobile(),
              SignIn.route: (context) => SignInMobile(),
              CompleteRegister.route: (context) {
                final String? email = ModalRoute.of(context)?.settings.arguments as String?;
                return CompleteRegisterMobile(email: email ?? '',); // Pass the email to CompleteRegister
              },
              HomeAfterRegister.route: (context) => HomeAfterRegisterMobile(),
              MakeOrder.route: (context) => MakeOrderMobile(),
            },
            //home: const HomeScreen()
          ),
          breakpoints: const ScreenBreakpoints(
            desktop: 500,
            watch: 0.0,
            tablet: 0.0,
          ),
        ),
*/
    );
      /*Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) {
          return FutureBuilder(future: _getStoredScreen(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String initialRoute = snapshot.data ?? '/home';
              return Navigator(
                initialRoute: initialRoute,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (_) {
                      switch (settings.name) {
                        case '/home':
                          return HomeScreen();
                        case '/CompleteRegister':
                          return CompleteRegister(String as String);
                        case '/signIn':
                          return SignIn();
                        default:
                          return Container(); // handle other routes if needed
                      }
                    },
                  );
                },
              );
            }
          },
          );
        },
      )*/
      //SignIn(),
      //MakeOrder(),
      // CompleteRegister()
      //HomeAfterRegister(),

  }
  /*// Function to retrieve the stored screen from SharedPreferences
  Future<String?> _getStoredScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentScreen');
  }*/
}
