import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:utility/models/response_list.dart';
import 'package:utility/util/htpp_request.dart';

import 'map_page/structure.dart';

class MainList extends StatefulWidget {
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<ResponseList> responseList = [];
  //List<String> itemsData;
  List<ResponseList> itemsDataToDisplay = [];

  void getPostsData() {
    List<String> listToDisplay = [];
    //List<ResponseList> responseList;

    //Return a list of ResponseList object
    fetchDataWithoutId().then((value) {
      value.forEach((item) {
        listToDisplay.add(
          item.id,
        );
      });

      setState(() {
        //itemsData = listRoute;
        responseList.addAll(value);
        itemsDataToDisplay.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              responseList.length == 0
                  ? Text("Loading")
                  : Expanded(
                      child: ListView.builder(
                          controller: controller,
                          itemCount: itemsDataToDisplay.length + 1,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return index == 0 ? _searchBar() : _itemList(index);
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _searchBar() {
    final border = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            itemsDataToDisplay = responseList.where((item) {
              var itemTitle = item.id.toLowerCase();
              return itemTitle.contains(text);
            }).toList();
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.grey.shade700,
          hintText: 'Ricerca...',
          hintStyle: TextStyle(color: Colors.white),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  _itemList(index) {
    ResponseList toDisplay = itemsDataToDisplay[index - 1];

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) {
            return AppStructure(id: toDisplay.id);
          }),
        );
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 10.0,
            ),
          ],
        ),
        /*child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),*/
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Left column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.asset('assets/images/italy.png'),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 100,
                    height: 25,
                    color: Colors.grey.shade700,
                    child: Center(
                      child: Text(
                        "Itinerario",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Center divider
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              child: Container(
                height: 100,
                child: VerticalDivider(
                  color: Colors.grey.shade300,
                  thickness: 8,
                ),
              ),
            ),
            //Right column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      //Error without -1
                      toDisplay.id,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: Text(
                            toDisplay.difficulty,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Abilitato a:",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text("• Passegini"),
                Text("• Esperti"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 50,
                        height: 15,
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Text(
                            "Miele",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 50,
                        height: 15,
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Text(
                            "Legno",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
