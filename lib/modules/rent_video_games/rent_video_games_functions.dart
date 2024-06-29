import 'package:firebase_database/firebase_database.dart';

Map<String, Map<String, dynamic>> videoGamesData = {};

Future<Map<String, Map<String, dynamic>>> getVideoGamesData() async {
  DatabaseReference videoGamesRef = FirebaseDatabase.instance.ref().child('VideoGames');
  DatabaseEvent databaseEvent = await videoGamesRef.once();

  Map<String, Map<String, dynamic>> videoGamesData = {};

  if (databaseEvent.snapshot.value != null) {
    Map<dynamic, dynamic> videoGamesSnapshot =
    databaseEvent.snapshot.value as Map<dynamic, dynamic>;

    videoGamesSnapshot.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        videoGamesData[key] = {
          'available-date': value['available-date'] ?? '',
          'count': value['Count'] ?? 0,
          'image-url': value['image-url'] ?? '',
          'price': value['price'] ?? 0,
          'rent-price': value['rent-price'] ?? 0,
          'used-price': value['used-price'] ?? 0,
        };
      }
    });
    return videoGamesData;
  } else {
    return {};
  }
}

Future<void> initializeVideoGamesData() async {
  videoGamesData = await getVideoGamesData();
}

// sort_functions
Map<String, Map<String, dynamic>> sortVideoGames(
    Map<String, Map<String, dynamic>> videoGamesData,
    String sortOption,
    {bool ascending = true}) {

  // Convert the map entries to a list for sorting
  List<MapEntry<String, Map<String, dynamic>>> entries = videoGamesData.entries.toList();

  // Sort based on the provided option and order
  switch (sortOption) {
    case 'Name':
      entries.sort((a, b) => ascending ? a.key.compareTo(b.key) : b.key.compareTo(a.key));
      break;
    case 'Price':
      entries.sort((a, b) => !ascending
          ? (a.value['price'] ?? 0).compareTo(b.value['price'] ?? 0)
          : (b.value['price'] ?? 0).compareTo(a.value['price'] ?? 0));
      break;
    case 'Availability':
      entries.sort((a, b) => ascending
          ? (b.value['count'] ?? 0).compareTo(a.value['count'] ?? 0)
          : (a.value['count'] ?? 0).compareTo(b.value['count'] ?? 0));
      break;
    default:
      throw ArgumentError('Invalid sort option');
  }

  // Convert the sorted list back to a map and return
  return Map<String, Map<String, dynamic>>.fromEntries(entries);
}

// search_functions.dart
Map<String, Map<String, dynamic>> searchVideoGames(
    String query, Map<String, Map<String, dynamic>> videoGamesData) {
  if (query.isEmpty) {
    return videoGamesData;
  }

  final Map<String, Map<String, dynamic>> filteredVideoGames = {};

  videoGamesData.forEach((key, value) {
    if (key.toLowerCase().contains(query.toLowerCase())) {
      filteredVideoGames[key] = value;
    }
  });

  return filteredVideoGames;
}

//Add to cart Function
List<Map<String, dynamic>> cartItems = [];
