import 'package:Sovarvo/shared/my_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class videoGamesScreen extends StatefulWidget {
  const videoGamesScreen({super.key});

  @override
  _videoGamesScreenState createState() => _videoGamesScreenState();
}

class _videoGamesScreenState extends State<videoGamesScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Map<dynamic, dynamic> videoGames = {};
  String newVideoGameName = '';
  String newVideoGameImageUrl = '';
  int newVideoGamePrice = 0;
  int rentVideoGamePrice = 0;
  int usedVideoGamePrice = 0;
  int videoGameCount = 0;
  int insurancevideoGamePrice = 0;
  String availableDate = '';

  @override
  void initState() {
    super.initState();
    _getVideoGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Video Games", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff8F3D96),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: videoGames.entries.map((entry) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(

                                child: Row(

                                  children: <Widget>[
                                    Image.network(
                                      entry.value["image-url"],
                                      height: MediaQuery.of(context).size.height * 0.2,
                                    ),
                                    SizedBox(width: 16,),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Available Date: ${entry.value["available-date"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdateDateDialog(entry.key, entry.value["available-date"]);
                                              },
                                              icon: const Icon(Icons.date_range, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02 ,),
                                        Row(
                                          children: [
                                            Text(
                                              "Count: ${entry.value["Count"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdateCountDialog(entry.key);
                                              },
                                              icon: const Icon(Icons.shopping_cart, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02 ,),
                                        Row(
                                          children: [
                                            Text(
                                              "Price: ${entry.value["price"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdatePriceDialog(entry.key);
                                              },
                                              icon: const Icon(Icons.monetization_on, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02 ,),
                                        Row(
                                          children: [
                                            Text(
                                              "Rent Price: ${entry.value["rent-price"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdateRentPriceDialog(entry.key);
                                              },
                                              icon: const Icon(Icons.monetization_on, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02 ,),
                                        Row(
                                          children: [
                                            Text(
                                              "Used Price: ${entry.value["used-price"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdateUsedPriceDialog(entry.key);
                                              },
                                              icon: const Icon(Icons.monetization_on, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02 ,),
                                        Row(
                                          children: [
                                            Text(
                                              "Insurance Price: ${entry.value["insurance-price"]}",
                                              style: TextStyle(fontSize: 20, color: MyThemeData.primaryColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showUpdateInsurancePriceDialog(entry.key);
                                              },
                                              icon: const Icon(Icons.monetization_on, size: 30),
                                              color: const Color(0xff8F3D96),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16,),

                                    IconButton(
                                        onPressed: () {
                                          _deleteVideoGame(entry.key);
                                        },
                                        icon: const Icon(Icons.delete_forever),
                                        color: Colors.red),
                                  ],
                                ),
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            Divider(
                              height: MediaQuery.of(context).size.height * 0.01,
                              color: const Color(0xff8F3D96),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8F3D96),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Add New Video Game",
                              style: TextStyle(color: Colors.black)),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'Video Game Name'),
                                  onChanged: (value) {
                                    // Update game name when text changes
                                    setState(() {
                                      newVideoGameName = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      newVideoGameImageUrl = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'Count'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      videoGameCount = int.parse(value);
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'price'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      newVideoGamePrice = int.parse(value);
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'rent price'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      rentVideoGamePrice = int.parse(value);
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'used price'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      usedVideoGamePrice = int.parse(value);
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'insurance price'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      insurancevideoGamePrice = int.parse(value);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.05 ,
                                ),

                                Text('Available Date', style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: MyThemeData.greyTextColor,
                                    fontWeight: FontWeight.w700)),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.5 ,
                                    height: MediaQuery.of(context).size.height * 0.5 ,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey,
                                    ),
                                    child: SfDateRangePicker(
                                      initialSelectedDate: DateTime.now(),
                                      selectionMode: DateRangePickerSelectionMode.range,
                                      onSelectionChanged: _onSelectionChanged,
                                    )),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Add",
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).size.height *
                                          0.02)),
                              onPressed: () {
                                // Add new game to the database
                                _addNewVidoeGame(newVideoGameName, newVideoGameImageUrl,videoGameCount, newVideoGamePrice, rentVideoGamePrice, usedVideoGamePrice,availableDate, insurancevideoGamePrice);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Add New Video Game",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getVideoGames() {
    databaseReference.child("VideoGames").once().then((DatabaseEvent event) {
      setState(() {
        videoGames = (event.snapshot.value) as Map<dynamic, dynamic>;
      });
    });
  }

  void _addNewVidoeGame(String videoGameName, String imageUrl, int count, int price, int rentPrice, int usedPrice, String availableDate, int insurancevideoGamePrice) {
    databaseReference.child("VideoGames").child(videoGameName).set({
      "image-url": imageUrl,
      "Count": count,
      "price": price,
      "rent-price": rentPrice,
      "used-price": usedPrice,
      "available-date": availableDate,
      "insurance-price": insurancevideoGamePrice
    }).then((_) {
      setState(() {
        videoGames[videoGameName] = {
          "image-url": imageUrl,
          "Count": count,
          "price": price,
          "rent-price": rentPrice,
          "used-price": usedPrice,
          "available-date": availableDate,
          "insurance-price": insurancevideoGamePrice
        };
      });
      //print("$gameName added successfully.");
    }).catchError((error) {
      //print("Failed to add $gameName: $error");
    });
  }

  void _deleteVideoGame(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          const Text("Confirm Deletion", style: TextStyle(color: Colors.black)),
          content: Text("Are you sure you want to delete $videoGameName?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03)),
              onPressed: () {
                databaseReference
                    .child("VideoGames")
                    .child(videoGameName)
                    .remove()
                    .then((_) {
                  setState(() {
                    videoGames.remove(videoGameName);
                  });
                  //print("$gameName deleted successfully.");
                  Navigator.of(context).pop();
                }).catchError((error) {
                  //print("Failed to delete $gameName: $error");
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      availableDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);;
    });
  }

  void _showUpdateCountDialog(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newCount = videoGames[videoGameName]["Count"];
        return AlertDialog(
          title: Text("Update Count",
              style: const TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Count'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newCount = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameCount(videoGameName, newCount);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameCount(String videoGameName, int newCount) {
    databaseReference.child("VideoGames").child(videoGameName).update({
      "Count": newCount,
    }).then((_) {
      setState(() {
        videoGames[videoGameName]["Count"] = newCount;
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

  void _showUpdatePriceDialog(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newPrice = videoGames[videoGameName]["price"];
        return AlertDialog(
          title: const Text("Update Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newPrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGamePrice(videoGameName, newPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGamePrice(String videoGameName, int newPrice) {
    databaseReference.child("VideoGames").child(videoGameName).update({
      "price": newPrice,
    }).then((_) {
      setState(() {
        videoGames[videoGameName]["price"] = newPrice;
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

  void _showUpdateRentPriceDialog(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newRentPrice = videoGames[videoGameName]["rent-price"];
        return AlertDialog(
          title: const Text("Update Rent Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Rent Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newRentPrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameRentPrice(videoGameName, newRentPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameRentPrice(String videoGameName, int newRentPrice) {
    databaseReference.child("VideoGames").child(videoGameName).update({
      "rent-price": newRentPrice,
    }).then((_) {
      setState(() {
        videoGames[videoGameName]["rent-price"] = newRentPrice;
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

  void _showUpdateUsedPriceDialog(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newUsedPrice = videoGames[videoGameName]["used-price"];
        return AlertDialog(
          title: const Text("Update Used Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Used Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newUsedPrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameUsedPrice(videoGameName, newUsedPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameUsedPrice(String videoGameName, int newUsedPrice) {
    databaseReference.child("VideoGames").child(videoGameName).update({
      "used-price": newUsedPrice,
    }).then((_) {
      setState(() {
        videoGames[videoGameName]["used-price"] = newUsedPrice;
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

  void _showUpdateDateDialog(String gameKey, String currentDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Available Date", style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Current Date: $currentDate', style: TextStyle(fontSize: 16, color: Colors.black)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: SfDateRangePicker(
                    initialSelectedDate: DateTime.tryParse(currentDate) ?? DateTime.now(),
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      if (args.value is DateTime) {
                        setState(() {
                          availableDate = DateFormat('yyyy-MM-dd').format(args.value);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameDate(gameKey, availableDate);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameDate(String gameKey, String newDate) {
    databaseReference.child("VideoGames").child(gameKey).update({
      "available-date": newDate,
    }).then((_) {
      setState(() {
        videoGames[gameKey]["available-date"] = newDate;
      });
      //print("$gameKey date updated successfully.");
    }).catchError((error) {
      //print("Failed to update $gameKey date: $error");
    });
  }

  void _showUpdateInsurancePriceDialog(String videoGameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newInsurancePrice = videoGames[videoGameName]["insurance-price"];
        return AlertDialog(
          title: const Text("Update Insurance Price",
              style: TextStyle(color: Colors.black)),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Insurance Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newInsurancePrice = int.parse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateVideoGameInsurancePrice(videoGameName, newInsurancePrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVideoGameInsurancePrice(String videoGameName, int newInsurancePrice) {
    databaseReference.child("VideoGames").child(videoGameName).update({
      "insurance-price": newInsurancePrice,
    }).then((_) {
      setState(() {
        videoGames[videoGameName]["insurance-price"] = newInsurancePrice;
      });
      //print("Count updated successfully.");
    }).catchError((error) {
      //print("Failed to update count: $error");
    });
  }

}