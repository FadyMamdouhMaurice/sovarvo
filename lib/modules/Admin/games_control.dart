import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GameCountScreen extends StatefulWidget {
  const GameCountScreen({super.key});

  @override
  _GameCountScreenState createState() => _GameCountScreenState();
}

class _GameCountScreenState extends State<GameCountScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Map<dynamic, dynamic> games = {};
  String newGameName = '';
  int newGameInitialCount = 0;
  String newGameImageUrl = '';
  int newGamePrice = 0;

  @override
  void initState() {
    super.initState();
    _getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Game", style: TextStyle(color: Colors.white)),
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
                      children: games.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Image.network(
                                entry.value["image-url"],
                                height: 100,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${entry.value["count"]}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  _changeGameCount(entry.key);
                                },
                                icon: const Icon(Icons.shopping_cart, size: 30),
                                color: const Color(0xff8F3D96),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                onPressed: () {
                                  _changeGamePrice(entry.key);
                                },
                                icon: const Icon(Icons.monetization_on, size: 30),
                                color: const Color(0xff8F3D96),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                  onPressed: () {
                                    _deleteGame(entry.key);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  color: Colors.red),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                          title: const Text("Add New Game",
                              style: TextStyle(color: Colors.black)),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration:
                                      const InputDecoration(labelText: 'Game Name'),
                                  onChanged: (value) {
                                    // Update game name when text changes
                                    setState(() {
                                      newGameName = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                      const InputDecoration(labelText: 'Initial Count'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // Update initial count when text changes
                                    setState(() {
                                      newGameInitialCount =
                                          int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                      const InputDecoration(labelText: 'Image URL'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      newGameImageUrl = value;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration:
                                  const InputDecoration(labelText: 'price'),
                                  onChanged: (value) {
                                    // Update image URL when text changes
                                    setState(() {
                                      newGamePrice = value as int;
                                    });
                                  },
                                ),
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
                                _addNewGame(newGameName, newGameInitialCount,
                                    newGameImageUrl, newGamePrice);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Add New Game",
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

  void _getGames() {
    databaseReference.child("MyGames").once().then((DatabaseEvent event) {
      setState(() {
        games = (event.snapshot.value) as Map<dynamic, dynamic>;
      });
    });
  }

  void _addNewGame(String gameName, int initialCount, String imageUrl, int price) {
    databaseReference.child("MyGames").child(gameName).set({
      "count": initialCount,
      "image-url": imageUrl,
      "price": price,
    }).then((_) {
      setState(() {
        games[gameName] = {
          "count": initialCount,
          "image-url": imageUrl,
          "price": price,
        };
      });
      //print("$gameName added successfully.");
    }).catchError((error) {
      //print("Failed to add $gameName: $error");
    });
  }

  void _deleteGame(String gameName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text("Confirm Deletion", style: TextStyle(color: Colors.black)),
          content: Text("Are you sure you want to delete $gameName?"),
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
                    .child("MyGames")
                    .child(gameName)
                    .remove()
                    .then((_) {
                  setState(() {
                    games.remove(gameName);
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

  void _changeGameCount(String gameKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update $gameKey Count",
              style: const TextStyle(color: Colors.black)),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              games[gameKey]?["count"] = int.tryParse(value) ?? 0;
            },
            decoration: const InputDecoration(hintText: "Enter new count"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                // Pop the dialog using the context from the parent widget
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateGameCount(gameKey, games[gameKey]?["count"]);
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {

                });
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGameCount(String game, int newCount) {
    databaseReference
        .child("MyGames")
        .child(game)
        .update({"count": newCount}).then((_) {
      setState(() {
        games[game]?["count"] = newCount;
      });
      //print("$game count updated successfully.");
    }).catchError((error) {
      //print("Failed to update $game count: $error");
    });
  }

  void _changeGamePrice(String gameKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update $gameKey Price",
              style: const TextStyle(color: Colors.black)),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              games[gameKey]?["price"] = int.tryParse(value) ?? 0;
            },
            decoration: const InputDecoration(hintText: "Enter new price"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                // Pop the dialog using the context from the parent widget
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text("Update",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02)),
              onPressed: () {
                _updateGamePrice(gameKey, games[gameKey]?["price"]);
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {

                });
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGamePrice(String game, int newPrice) {
    databaseReference
        .child("MyGames")
        .child(game)
        .update({"price": newPrice}).then((_) {
      setState(() {
        games[game]?["price"] = newPrice;
      });
      //print("$game count updated successfully.");
    }).catchError((error) {
      //print("Failed to update $game count: $error");
    });
  }

}
