import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  List<String> itemsData;
  List<String> itemsDataToDisplay = [];

  void getPostsData() {
    List<String> listRoute = [];
    List<dynamic> responseList;

    fetchDataWithoutId().then((value) {
      responseList = value.id;

      responseList.forEach((post) {
        listRoute.add(
          post['id'],
        );
      });
      setState(() {
        itemsData = listRoute;
        itemsDataToDisplay.addAll(listRoute);
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
    //final double categoryHeight = size.height * 0.30;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),*/
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              itemsData == null
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Inserisci il nome da cercare...',
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            itemsDataToDisplay = itemsData.where((item) {
              var itemTitle = item.toLowerCase();
              return itemTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _itemList(index) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) {
            return AppStructure(id: itemsDataToDisplay[index]);
          }),
        );
        debugPrint("TAPPED");
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    //Error without -1
                    itemsDataToDisplay[index - 1],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
