import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/auth/login/login_function.dart';
import 'package:Sovarvo/modules/complete%20register/complete_register_mobile.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register_mobile.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import '../../shared/my_theme.dart';

class SignInMobile extends StatefulWidget {
  const SignInMobile({super.key});
  static const String route = '/signin';

  @override
  State<SignInMobile> createState() => _SignInMobileState();
}

class _SignInMobileState extends State<SignInMobile> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  bool? isSelected = false;
  var formKey = GlobalKey<FormState>();
  String login = '';
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Website-10.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    //appBarSignInOutMobile(context, "", "assets/images/logo_final.png"),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(
                          HomeScreenMobile.route,
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset('assets/images/logo_final.png'),
                      ),
                    ),
                    Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        width: 300,
                        child: Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.04,
                              vertical: MediaQuery.of(context).size.height * 0.07),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                TextFormField(
                                  autofillHints: [AutofillHints.email],
                                  validator: (p0) {
                                    if (p0 != null && p0.isEmpty) {
                                      return "please enter the Email";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  style: TextStyle(
                                      color: MyThemeData.whiteTextColor,
                                      fontSize: MediaQuery.of(context).size.width * 0.03),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: MyThemeData.whiteTextColor)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: MyThemeData
                                                .whiteTextColor), // White border color when focused
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          color: MyThemeData.greyTextColor,
                                          fontSize: MediaQuery.of(context).size.height * 0.015),
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      filled: true),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.02,
                                ),
                                TextFormField(
                                  autofillHints: [AutofillHints.password],
                                  onEditingComplete: () =>
                                      TextInput.finishAutofillContext(),
                                  validator: (p0) {
                                    if (p0 != null && p0.isEmpty) {
                                      return "please enter the password";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isPasswordShow,
                                  controller: passwordController,
                                  style: TextStyle(
                                      color: MyThemeData.whiteTextColor,
                                      fontSize: MediaQuery.of(context).size.width * 0.03),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: MyThemeData.whiteTextColor)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: MyThemeData
                                              .whiteTextColor), // White border color when focused
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: MyThemeData.greyTextColor,
                                        fontSize: MediaQuery.of(context).size.height * 0.015),
                                    fillColor: Colors.grey.withOpacity(0.3),
                                    filled: true,
                                    suffixIcon: IconButton(
                                      icon: isPasswordShow? const Icon(Icons.visibility,color: Colors.white,) :const Icon(Icons.visibility_off,color: Colors.white,) , // You can use any icon you want here
                                      onPressed: () {
                                        isPasswordShow = !isPasswordShow;
                                        setState(() {
          
                                        });
                                        // Toggle password visibility logic here
                                      },
                                    ),
                                  ),
          
                                ),Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        child: Text('Forgot password?',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white)),
                                        onTap: () async {
                                          if(emailController.text == ''){
                                            AwesomeDialog(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.scale,
                                              title: 'Error',
                                              titleTextStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              desc: 'Please enter your email then click Forgot Password',
                                              //btnCancelOnPress: () {},
                                              btnOkOnPress: () {},
                                              btnOkColor: MyThemeData.primaryColor,
                                            )..show();
                                            return;
                                          }
                                          try {
                                            await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                                            AwesomeDialog(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.rightSlide,
                                              title: 'Success',
                                              titleTextStyle: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              desc: 'A link to reset your password has been sent to your email. Please go to your email and click on the link',
                                              //btnCancelOnPress: () {},
                                              btnOkOnPress: () {},
                                              btnOkColor: MyThemeData.primaryColor,
                                            )..show();
                                          }
                                          catch (e){
                                            AwesomeDialog(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.rightSlide,
                                              title: 'Error',
                                              titleTextStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              desc: e.toString(),
                                              //btnCancelOnPress: () {},
                                              btnOkOnPress: () {},
                                              btnOkColor: MyThemeData.primaryColor,
                                            )..show();
                                          }

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.02,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          login = await loginUser(emailController.text,passwordController.text);
                                          setState(() {
                                          });
                                          if(login == ''){
                                            getUserData();
                                            Navigator.of(context).pushNamed(
                                              HomeAfterRegisterMobile.route,
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Text("Sign In",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(fontSize: MediaQuery.of(context).size.width * 0.05))),
                                ),
                                // Display error message
                                if (login.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      login,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height * 0.005,
                                ),
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            //only check box
                                            value: isSelected, //unchecked
                                            onChanged: (bool? value) {
                                              //value returned when checkbox is clicked
                                              setState(() {
                                                isSelected = value;
                                              });
                                            }),
                                        Text('Remember me',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey))
                                      ],
                                    ),
                                    Text('Need help',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey))
                                  ],
                                ),*/
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                ),
                                Row(
                                  children: [
                                    Text('New to Sovarvo ? ',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.03, color: Colors.grey)),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          CompleteRegisterMobile.route,
                                          arguments: '',
                                        );
                                      },
                                      child: Text('Sign up now',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.03, color: Colors.white)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            const bottomNavigationBar(),
          ]),
        ),
      ),
    );
  }
}