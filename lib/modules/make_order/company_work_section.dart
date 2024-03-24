import 'package:flutter/material.dart';
import 'package:Sovarvo/modules/realtime_firebase/users.dart';

import '../../shared/my_theme.dart';

class CompanyWorkSection extends StatefulWidget {
  const CompanyWorkSection({super.key});

  @override
  State<CompanyWorkSection> createState() => _CompanyWorkSectionState();
}

class _CompanyWorkSectionState extends State<CompanyWorkSection> {
  /*String? statsbombSelectedValue = "Statsbomb1";

  var statsbombItems = [
    "Statsbomb1",
    "Statsbomb2",
  ];*/
  var codeController = TextEditingController();
  var companyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeController.text = user!.code;
    companyController.text = user!.company;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("The company you work for",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: MyThemeData.greyTextColor)),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border:
                        Border.all(color: MyThemeData.greyTextColor, width: 1),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        MyThemeData.primaryColor,
                        Colors.blue,
                      ],
                    )),
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.06,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_downward_outlined),
                      iconEnabledColor: Colors.black,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                        decoration: BoxDecoration(color: Colors.grey)),
                    isExpanded: true,
                    hint: Text(
                      'Select Item',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(fontWeight: FontWeight.w300),
                      // selectionColor: Colors.red,
                    ),
                    items: statsbombItems
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                // selectionColor: Colors.teal,
                                item,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ))
                        .toList(),
                    value: statsbombSelectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        statsbombSelectedValue = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      // overlayColor: MaterialStatePropertyAll(Colors.green),
                      // decoration: BoxDecoration(color: Colors.green,),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      // overlayColor: MaterialStatePropertyAll(Colors.deepOrange),

                      height: 40,
                    ),
                  ),
                ),
              ),*/
              /*SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "please enter your code";
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: companyController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: const BorderSide(
                          color:
                          Colors.grey), // White border color when focused
                    ),
                    hintText: "Your company",
                    hintStyle:
                    Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),*/
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      MyThemeData.primaryColor,
                      Colors.blue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                width: MediaQuery.of(context).size.width * 0.17,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Center(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "please enter your code";
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: companyController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                            color:
                            Colors.grey), // White border color when focused
                      ),
                      hintText: "Your company",
                      hintStyle:
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "please enter your code";
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: codeController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: const BorderSide(
                          color:
                              Colors.grey), // White border color when focused
                    ),
                    hintText: "Your code",
                    hintStyle:
                        Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: Colors.grey,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
