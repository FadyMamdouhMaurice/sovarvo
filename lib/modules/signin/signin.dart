import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sovarvo/modules/auth/login/login_function.dart';
import 'package:Sovarvo/modules/home%20after%20register/home_after_register.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/shared/components.dart';
import '../../shared/my_theme.dart';
import '../complete register/complete_register.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const String route = '/signin';


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  bool? isSelected = false;
  var formKey = GlobalKey<FormState>();
  String login = '';
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // alignment: Alignment.topRight,
                children: [
                  appBarSignInOut(context, "", "assets/images/logo_final.png"),
                  Center(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width * 0.25,
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
                                autofillHints: [AutofillHints.email], // Specify autofill hint for email
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
                                    fontSize: 14),
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
                                        fontSize: 14),
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
                                    fontSize: 14),
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
                                        fontSize: 14),
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
        
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.04,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        login = await loginUser(emailController.text,passwordController.text);
                                        if(login == ''){
                                          // Save the user token to SharedPreferences
                                          //final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          //await prefs.setString(emailController.text, passwordController.text);
                                          getUserData();
                                          Navigator.of(context).pushNamed(
                                              HomeAfterRegister.route);
                                        }
                                        setState(() {

                                        });
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
                                            .copyWith(fontSize: 14))),
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
                                  const Text('New to Sovarvo ? ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CompleteRegister.route,
                                        arguments: ''
                                      );
                                    },
                                    child: const Text('Sign up now',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  )
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
    );
  }
}
