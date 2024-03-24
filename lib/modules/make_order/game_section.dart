import 'package:flutter/material.dart';
import '../../shared/my_theme.dart';
import 'make_order_functions.dart';

class GameSection extends StatefulWidget {
  //TextEditingController controller;

  final void Function(List<String>, List<double>) onGamesSelected;

  const GameSection({
    required this.onGamesSelected,
    super.key,
  });

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  //Map<String, String> gameImageUrls = {};
  List<String> gamesSelected = [];
  List<double> gamesSelectedPrices = [];

  //get onGamesSelected => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Choose the games you want",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: MyThemeData.greyTextColor,
                  fontWeight: FontWeight.w700)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          /*          SizedBox(
                width: MediaQuery.of(context).size.width * 0.17,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: MyThemeData.whiteTextColor, fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: MyThemeData.greyTextColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color:Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(color:Colors.grey), // White border color when focused
                    ),
                    hintText: "Search",
                    prefixIcon:
                        Icon(Icons.search, color: MyThemeData.whiteTextColor),
                    hintStyle: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),*/
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                //childAspectRatio: 0.8,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0),
            itemCount: gamesData.length,
            itemBuilder: (context, index) {
              String gameName = gamesData.keys.elementAt(index);
              int available = gamesData[gameName]?['count'] ?? 0;
              String imageUrl = gamesData[gameName]?['image-url'] ?? '';
              double price = gamesData[gameName]?['price'] ?? 0;

              bool isSelected = gamesSelected
                  .contains(gameName); //List<String> gamesSelected = [];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: isSelected ? Colors.blue.withOpacity(0.8) : null,
                      child: InkWell(
                        onTap: () {
                          if (available > 0) {
                            setState(() {
                              if (!gamesSelected.contains(gameName)) {
                                gamesSelected.add(gameName);
                                gamesSelectedPrices.add(price);
                              } else {
                                gamesSelected.remove(gameName);
                                gamesSelectedPrices.remove(price);
                              }
                              isSelected = gamesSelected.contains(gameName);
                            });
                            widget.onGamesSelected(gamesSelected, gamesSelectedPrices);
                            //print('Selected games: $gamesSelected');
                          }
                        },
                        child: imageUrl.isNotEmpty
                            ?  Image.network(
                          imageUrl,
                          width: 75,
                          height: 75,
                          fit: BoxFit.contain,
                          // You might want to adjust the width and height
                          // according to your UI requirements
                        )
                            : const CircularProgressIndicator(), // Placeholder until image is loaded
                      ),
                    ),
                    if (available == 0)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    if (available == 0)
                      const Center(
                        child: Text('Not Available',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center),
                      ),
                    if (isSelected)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 24, // Adjust the size as needed
                          height: 24, // Adjust the size as needed
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
/*
  Future<void> fetchGameImageUrls() async {
    gameImageUrls = {};
    FirebaseStorage storage = FirebaseStorage.instance;
    Map<String, String> urls = {};

    for (String gameName in gamesData.keys) {
      Reference ref = storage.ref().child('Games').child('$gameName.png');
      String url = await ref.getDownloadURL();
      urls[gameName] = url;
    }
    gameImageUrls = urls;
  }
*/
}
