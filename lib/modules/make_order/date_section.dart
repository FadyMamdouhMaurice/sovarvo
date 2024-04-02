import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:Sovarvo/modules/make_order/make_order.dart';
import '../../shared/my_theme.dart';
import 'make_order_functions.dart';

class DateSection extends StatefulWidget {
  final void Function(DateTime?) onStartDateSelected;
  final void Function(DateTime?) onEndDateSelected;
  final void Function(String?) onControllerSelected;
  final void Function(String?) onStationSelected;
  final void Function(int) onNumberOfDaysCalculated;


  const DateSection({
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onControllerSelected,
    required this.onStationSelected,
    required this.onNumberOfDaysCalculated,
    Key? key,
  }) : super(key: key);

  @override
  State<DateSection> createState() => _DateSectionState();
}

class _DateSectionState extends State<DateSection> {

  String? controllerSelectedValue;
  String? stationSelectedValue;
  late DateTime? startDate;
  late DateTime? endDate;
  List<String> controllerItems = ['1 Controller']; // Initialize controllerItems as an empty list
  List<String> stationItems = []; // Initialize stationItems as an empty list

  late DateTime? _previousStartDate;
  late DateTime? _previousEndDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPickupStations(); // Call function to fetch Pickup Stations
    fetchSpareController();
    // Initialize startDate and endDate with default values
    startDate = DateTime.now();
    endDate = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.009,
          ),
          child: Text("Rental period",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: MyThemeData.greyTextColor,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: DateTime.now().add(const Duration(days: 1)), // Minimum date set to next day
              maxDate: DateTime.now().add(const Duration(days: 21)), // Limit to next 21 days
              onSelectionChanged:
              _onSelectionChanged,
                  /*(DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  startDate = args.value.startDate!;
                  endDate = args.value.endDate!;
                });
                // Call the callback functions with selected start and end dates
                widget.onStartDateSelected(startDate);
                widget.onEndDateSelected(endDate);
              },*/
              // Disable dates based on the disabledDates list
              selectableDayPredicate: isDateSelectable,

            )),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.009,
          ),
          child: Text("How many Controllers do you want",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: MyThemeData.greyTextColor,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          width: 400,
          //width: MediaQuery.of(context).size.width * 0.2,
          padding: const EdgeInsetsDirectional.only(start: 30, end: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: MyThemeData.greyTextColor),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              dropdownStyleData: const DropdownStyleData(
                  decoration: BoxDecoration(color: Colors.grey)),
              // barrierColor:Colors.deepOrange ,
              // style: TextStyle(color: Colors.brown),
              isExpanded: true,
              hint: Text(
                'Select item',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.w300,),
                // selectionColor: Colors.red,
              ),
              items: controllerItems
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          // selectionColor: Colors.teal,
                          item,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ))
                  .toList(),
              value: controllerSelectedValue,
              onChanged: (String? value) {
                setState(() {
                  controllerSelectedValue = value;
                });
                widget.onControllerSelected(value);
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
        ),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.009,
          ),
          child: Text("Pick up location",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: MyThemeData.greyTextColor,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          width: 400,
          padding: const EdgeInsetsDirectional.only(start: 30, end: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: MyThemeData.greyTextColor),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              dropdownStyleData: const DropdownStyleData(
                  decoration: BoxDecoration(color: Colors.grey)),
              isExpanded: true,
              hint: Text(
                'Select item',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.w300,),
                // selectionColor: Colors.red,
              ),
              items: stationItems
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ))
                  .toList(),
              value: stationSelectedValue,
              onChanged: (String? value) {
                setState(() {
                  stationSelectedValue = value;
                });
                widget.onStationSelected(stationSelectedValue);

              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Text("The device will be picked up from 7:00 PM to 12 AM. \n We'll call you to set a specific time once your order is complete.",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyThemeData.primaryColor,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ),

      ],
    );
  }

  int calculateNumberOfDays() {
    if (startDate != null && endDate != null) {
      final difference = endDate?.difference(startDate!).inDays;
      return difference! + 1; // Add 1 to include both start and end dates
    }
    return 0;
  }

  void fetchPickupStations() {
    DatabaseReference pickupStationsRef = FirebaseDatabase.instance.ref().child('Pickup Stations');
    pickupStationsRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<dynamic, dynamic> pickupStationsData = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          stationItems = pickupStationsData.values.cast<String>().toList();
        });
      }
    }).catchError((error) {
      //print("Error fetching Pickup Stations: $error");
    });

  }

  void fetchSpareController() {
    DatabaseReference spareControllerRef = FirebaseDatabase.instance.ref().child('SpareController');
    spareControllerRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        int spareControllerCount = databaseEvent.snapshot.value as int;
        int totalControllerCount = spareControllerCount + 2; // Adding default controllers
        List<int> evenNumbers = List.generate(totalControllerCount, (index) => index + 1)
            .where((number) => number % 2 == 0)
            .toList();
        setState(() {
          controllerItems.addAll(evenNumbers.map((number) => '$number Controllers').toList());
        });
      }
    }).catchError((error) {
      //print("Error fetching Spare Controller: $error");
    });
  }

  bool isDateSelectable(DateTime date){
    // Your logic to determine if the date should be selectable or not
    // For example, you can check if the date is in the disabledDates list
// Check if the date itself is in the disabledDates list
    if (datesWithoutPS.contains(date)) {
      return false;
    }

    // Check if the next day is in the disabledDates list
    DateTime nextDay = date.add(const Duration(days: -1));
    if (datesWithoutPS.contains(nextDay)) {
      return false;
    }

    // If both the current date and the next day are not in the disabledDates list, return true
    return true;  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // Get the selected start and end dates
    DateTime selectedStartDate = args.value.startDate!;
    DateTime selectedEndDate = args.value.endDate!;

    // Check if the selected range contains any disabled dates
    bool containsDisabledDates = false;
    for (DateTime date = selectedStartDate; date.isBefore(selectedEndDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (!isDateSelectable(date)) {
        containsDisabledDates = true;
        break;
      }
    }

    // If the selected range contains disabled dates, revert the selection
    if (containsDisabledDates) {
      // Revert the selection to the previous valid range
      setState(() {
        startDate = _previousStartDate ?? startDate;
        endDate = _previousEndDate ?? endDate;
      });

      availableDate = false;
      // Show a message to the user indicating that the selected range contains disabled dates
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The selected range contains disabled dates. Please choose a different range.'),
        ),
      );
    } else {
      availableDate = true;
      // If the selected range is valid, update the selected start and end dates
      setState(() {
        startDate = selectedStartDate;
        endDate = selectedEndDate;
        _previousStartDate = selectedStartDate;
        _previousEndDate = selectedEndDate;
      });
      // Call the callback functions with selected start and end dates
      widget.onStartDateSelected(startDate);
      widget.onEndDateSelected(endDate);
    }
  }
}