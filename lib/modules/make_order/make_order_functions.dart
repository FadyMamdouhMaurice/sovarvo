// Initialize an empty map to store key-value pairs
import 'package:firebase_database/firebase_database.dart';

Map<String, Map<String, dynamic>> gamesData = {};

List<DateTime> datesWithoutPS = [];
List<List<DateTime>> rentalDates = [];
int psCount = 0;
final _rentalsRef = FirebaseDatabase.instance.ref().child('Rentals');
final _psRef = FirebaseDatabase.instance.ref().child('PS');


Future<Map<String, Map<String, dynamic>>> getGamesData() async {
  DatabaseReference gamesRef = FirebaseDatabase.instance.ref().child('MyGames');
  DatabaseEvent databaseEvent = await gamesRef.once();

  Map<String, Map<String, dynamic>> gamesData = {};

  if (databaseEvent.snapshot.value != null) {
    Map<dynamic, dynamic> gamesSnapshot =
    databaseEvent.snapshot.value as Map<dynamic, dynamic>;

    gamesSnapshot.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        gamesData[key] = {
          'count': value['count'] ?? 0,
          'image-url': value['image-url'] ?? '',
          'price': value['price'] ?? 0,
        };
      }
    });
    return gamesData;
  } else {
    return {};
  }
}

Future<void> initializeGamesData() async {
  gamesData = await getGamesData();
  //await fetchGameImageUrls();
}

Future<void> getRentalDatesFromFirebase() async{
  await _rentalsRef.once().then((DatabaseEvent event) {
    Map<dynamic, dynamic> rentals = event.snapshot.value as Map<dynamic, dynamic>;
    List<List<DateTime>> fetchedRentalDates = [];
    rentals.forEach((key, value) {
      value.forEach((dateKey, rentalData) {
        DateTime startDate = DateTime.parse(rentalData["Start Date"]);
        DateTime endDate = DateTime.parse(rentalData["End Date"]);
        fetchedRentalDates.add([startDate, endDate]);
      });
    });
    rentalDates = fetchedRentalDates;
  }).catchError((error) {
    //print("Failed to retrieve rental data: $error");
  });
}

Future<void> getPSCount() async {
  try {
    DatabaseEvent event = await _psRef.once();
    Map<dynamic, dynamic> ps = event.snapshot.value as Map<dynamic, dynamic>;
    int count = ps['count'];
    psCount = count;

    await checkAvailability(); // Wait for checkAvailability to complete
  } catch (error) {
    //print("Failed to retrieve PS data: $error");
  }
}

Future<void> checkAvailability() async {
  for (List<DateTime> rentalPeriod in rentalDates) {
    DateTime startDate = rentalPeriod[0];
    DateTime endDate = rentalPeriod[1];

    for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (!isPSAvailable(date)) {
        datesWithoutPS.add(date);
      }
    }
  }

  // Print the dates without PS available
  //print("Dates without PS available: $datesWithoutPS");

}

bool isPSAvailable(DateTime date) {
  // Convert psCount to an integer if it's not already
  int availablePSCount = psCount - 1;

  // Get the total number of PS units needed for all rental periods on the given date
  int totalPSNeeded = rentalDates
      .where((rentalPeriod) => date.isAfter(rentalPeriod[0].subtract(const Duration(days: 1))) && date.isBefore(rentalPeriod[1].add(const Duration(days: 1))))
      .length;

  // Check if there are enough PS units available for the given date
  return availablePSCount >= totalPSNeeded;
}