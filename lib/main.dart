import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register_mobile.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/make_order/make_order_mobile.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_screen.dart';
import 'package:Sovarvo/modules/rent_video_games/cart_screen_mobile.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_functions.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games_mobile.dart';
import 'package:Sovarvo/modules/signin/signin_mobile.dart';
import 'package:Sovarvo/modules/rent_video_games/rent_video_games.dart';
import 'package:Sovarvo/services/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:Sovarvo/layout/home_screen.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:Sovarvo/modules/make_order/make_order.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/modules/signin/signin.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessageOpenedApp.listen((message) {});

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initializeNotification();

  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.user}) : super(key: key);
  final User? user;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user != null ? getUserData() : null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: const Color(0xff8F3D96),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // Error while fetching data
          return Text('Error: ${snapshot.error}');
        } else {
          return ScreenTypeLayout.builder(
            desktop: (p0) => AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: const Color(0xff8F3D96),
              ),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: MyThemeData.lightTheme,
                darkTheme: MyThemeData.darkTheme,
                initialRoute: '/',
                routes: {
                  HomeScreen.route: (context) => HomeScreen(),
                  SignIn.route: (context) => SignIn(),
                  CompleteRegister.route: (context) {
                    final String? email =
                        ModalRoute.of(context)?.settings.arguments as String?;
                    return CompleteRegister(
                      email: email ?? '',
                    ); // Pass the email to CompleteRegister
                  },
                  HomeAfterRegister.route: (context) => HomeAfterRegister(),
                  MakeOrder.route: (context) => MakeOrder(),
                  RentVideoGames.route: (context) => RentVideoGames(),
                  CartScreen.route: (context) => CartScreen(cartItems: cartItems,),
                },
                //home: const HomeScreen()
              ),
            ),
            mobile: (p0) => AnnotatedRegion(
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
                    final String? email =
                        ModalRoute.of(context)?.settings.arguments as String?;
                    return CompleteRegisterMobile(
                      email: email ?? '',
                    ); // Pass the email to CompleteRegister
                  },
                  HomeAfterRegister.route: (context) =>
                      HomeAfterRegisterMobile(),
                  MakeOrder.route: (context) => MakeOrderMobile(),
                  RentVideoGames.route: (context) => RentVideoGamesMobile(),
                  CartScreen.route: (context) => CartScreenMobile(cartItems: cartItems,),
                },
                //home: const HomeScreen()
              ),
            ),
            /*MaterialApp(debugShowCheckedModeBanner: false,
                theme: MyThemeData.lightTheme,
                darkTheme: MyThemeData.darkTheme,
                home: AdminHomeScreen()),*/
            breakpoints: const ScreenBreakpoints(
              desktop: 500,
              watch: 0.0,
              tablet: 0.0,
            ),
          );
        }
      },
    );
  }
}