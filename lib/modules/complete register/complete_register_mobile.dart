import 'package:flutter/material.dart';
import 'package:Sovarvo/layout/home_Screen_mobile.dart';
import 'package:Sovarvo/modules/auth/register/register_function.dart';
import 'package:Sovarvo/modules/home%20screen/bottom_navigation_bar.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:Sovarvo/shared/components.dart';
import 'package:Sovarvo/shared/my_theme.dart';
import 'package:email_validator/email_validator.dart';


class CompleteRegisterMobile extends StatefulWidget {
  String email;
  static const String route = '/signup';

  CompleteRegisterMobile({Key? key, required this.email}) : super(key: key);

  @override
  State<CompleteRegisterMobile> createState() => _CompleteRegisterMobileState();
}

class _CompleteRegisterMobileState extends State<CompleteRegisterMobile> {
  var usernameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  var companyController = TextEditingController();

  var companyCodeController = TextEditingController();
  bool isSelected = false;
  bool code = true;
  bool isPasswordShow = true;
  var formKey = GlobalKey<FormState>();
  String _errorMessage = ''; // Add a variable to hold error messages

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = widget.email;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            appBarSignInOutMobile(context, "Sign in", "assets/images/LOGOS-02.png"),
            Container(height: 5, color: Colors.grey[300]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Create a password to start your Journey",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.black)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      Text("Just a few more steps and you're done!",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.black)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      Text("We hate paperwork, too.",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.black)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      defaultTextFeild(
                          autofill: [AutofillHints.username],
                          validateFunction: (p0) {
                            if (p0 != null && p0.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          controller: usernameController,
                          keyboardType: TextInputType.name,
                          lableText: "Full Name"),
                      defaultTextFeild(
                        autofill: [AutofillHints.email],
                          readOnly: true,
                          validateFunction: (p0) {
                            if (p0 != null && p0.isEmpty) {
                              return "Please enter your e-mail";
                            } else if (!EmailValidator.validate(p0!)) {
                              return "Please enter a valid e-mail address";
                            }
                            return null;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          lableText: "Email address"),
                      defaultTextFeild(
                          validateFunction: (p0) {
                            if (p0 != null && p0.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          controller: passwordController,
                          isObscure: isPasswordShow,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: isPasswordShow
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                          suffixPressed: () {
                            setState(() {
                              isPasswordShow = !isPasswordShow;
                            });
                          },
                          lableText: "Password"),
                      defaultTextFeild(
                          validateFunction: (value) {
                            var orange = phoneController.text.split('');
                            if (value!.trim().isEmpty) {
                              return 'Please enter your phone number';
                            } else if (phoneController.text.length < 11) {
                              return 'Phone Number must be 11 number';
                            } else if (!(orange[0].contains('0') &&
                                orange[1].contains('1') &&
                                (orange[2].contains('0') ||
                                    orange[2].contains('1') ||
                                    orange[2].contains('2') ||
                                    orange[2].contains('5')))) {
                              return 'This is invalid Number';
                            }
                            return null;
                          },
                          maxLength: 11,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          lableText: "Phone number"),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: defaultTextFeild(
                              controller: companyController,
                              keyboardType: TextInputType.text,
                              lableText: "Your Company name (optional)",),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                          Expanded(
                            flex: 3,
                            child: defaultTextFeild(
                                controller: companyCodeController,
                                keyboardType: TextInputType.text,
                                lableText: "Your Code (optional)"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              //only check box
                              value: isSelected, //unchecked
                              onChanged: (value) {
                                //value returned when checkbox is clicked
                                setState(() {
                                  isSelected = value!;
                                });
                              }),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.005),
                          const Text("Please don't email me sovarvo special offers",
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                      // Display error message
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width * 0.03),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    _errorMessage = await registerUser(emailController.text, passwordController.text);
                                    setState(() {

                                    });
                                    if(_errorMessage == '') {
                                      await addUser(usernameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          phoneController.text,
                                          companyController.text, companyCodeController.text, isSelected);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 4),
                                          content: Text(
                                              'Please check your email to verify your account.'),
                                        ),
                                      );
                                      Navigator.of(context).pushNamed(
                                          HomeScreenMobile.route,
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: MyThemeData.primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text("Let's do it",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const bottomNavigationBar(),
          ]),
        ),
      ),
    );
  }
}
