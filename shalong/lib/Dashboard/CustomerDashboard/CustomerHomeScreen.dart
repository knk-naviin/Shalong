import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shalong/Dashboard/CustomerDashboard/ShopPageScreen.dart';
import 'package:shalong/UserAuthentication/AuthManager.dart';

import 'CustomerAccountInfoScreen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late List<ShopInfo>? shops = null;
  late Map<String, List<Rating>>? ratings = null;
  late Map<String, List<Favorite>>? favorites = null;
  // bool _icon = false;
  var searchText = "";
  var name = FirebaseAuth.instance.currentUser!.displayName;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController editingController = TextEditingController();

  void _onRefresh() async {
    // monitor network fetch
    loadData(true);
    // if failed,use refreshFailed()
  }

  void loadData(bool isRefresh) async {
    shopTuple().then((value) {
      setState(() {
        shops = value.first as List<ShopInfo>;
        ratings = value[1] as Map<String, List<Rating>>;
        favorites = value[2] as Map<String, List<Favorite>>;
      });
      if (isRefresh) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  void _onLoading() async {
    loadData(false);
  }

  @override
  void initState() {
    super.initState();
  }

  getratings(int ratingCount, int userCount) {
    return ratingCount / userCount;
  }

  List<Rating> ratingsForShopId(String shopId) {
    return ratings?[shopId] ?? [];
  }

  Widget shopList(List<ShopInfo>? shops) {
    if (shops == null) {
      _onLoading();
      return Center(
          child: Scaffold(
        backgroundColor: Colors.white70,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(
                    animating: true,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading"),
            )
          ],
        )),
      ));
    }
    List<Widget> widgets = [];
    widgets.add(GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Stack(
              children: [
                new Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.blue])),
                  child: Column(
                    children: [
                      Text(
                        "Welcomes you",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "fonts/TrajanPro.ttf",
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Hi ",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Center(
                              child: Text(
                                name!,
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      height: 54,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Colors.blue.withOpacity(0.23))
                          ]),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: editingController,
                        decoration: InputDecoration(
                            // suffixIcon: Icon(Icons.search,color: Colors.blue,),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.blue),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
    // for (var shop in shops) {
    var dp = FirebaseAuth.instance.currentUser!.photoURL;
    // widgets.add(SmartRefresher(
    //   enablePullDown: true,
    //   enablePullUp: true,
    //   header: WaterDropHeader(
    //     waterDropColor: CupertinoColors.activeBlue,
    //   ),
    //   controller: _refreshController,
    //   onRefresh: _onRefresh,
    //   onLoading: _onRefresh,
    //   child: shopList(shops),
    // ));
    widgets.add(
      Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: shops.length,
            itemBuilder: (context, index) {
              var shop = shops[index];
              if (editingController.text.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopPageScreen(
                                  shop, ratingsForShopId(shop.docId))),
                        );
                      },
                      child: Card(
                        shadowColor: Colors.blue,
                        semanticContainer: false,
                        borderOnForeground: true,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // if you need this
                          side: BorderSide(
                            style: BorderStyle.solid,
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    shop.name,
                                    style: TextStyle(
                                      letterSpacing: 3,
                                      wordSpacing: 2,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 110.0),
                                    child: Text(shop.isOpen ? "Open" : "Closed",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: shop.isOpen
                                                ? Colors.red
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                  )
                                )
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 20, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.address,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2,
                                        wordSpacing: 2),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 20, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Ratings | ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: averageRatingFrom(
                                                    ratingsForShopId(
                                                        shop.docId))
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 100.0
                                          ),
                                          child: Text(
                                            "Add to Favorites",
                                            style: TextStyle(
                                                color: favorites?[shop.docId] ==
                                                        null
                                                    ? CupertinoColors.systemGrey
                                                    : CupertinoColors
                                                        .activeBlue),
                                          ),
                                        ),
                                        IconButton(
                                          autofocus: true,
                                          icon: Icon(
                                              // Icons.favorite_outline
                                              favorites?[shop.docId] == null
                                                  ? CupertinoIcons.heart
                                                  : CupertinoIcons.heart_fill,
                                              color: favorites?[shop.docId] ==
                                                      null
                                                  ? CupertinoColors.systemGrey
                                                  : CupertinoColors.activeBlue),
                                          onPressed: () {
                                            setState(() {
                                              if (favorites?[shop.docId] ==
                                                  null) {
                                                setFavorite(shop);
                                                // favorites.remove(shop.docId);
                                              } else {
                                                removeFavorite(shop);
                                                // favorites.add(shop.docId);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        // child: GFListTile(
                        //
                        //   avatar: Image.network("dp"),
                        //   subTitleText: shop.address,
                        //   title: Text(
                        //     shop.name,
                        //     style: TextStyle(
                        //       letterSpacing: 3,
                        //       wordSpacing: 2,
                        //       fontSize: 25,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   icon: Text(shop.isOpen ? "Open" : "Closed",
                        //       style: TextStyle(
                        //           fontSize: 15,
                        //           color: shop.isOpen ? Colors.red : Colors.grey,
                        //           fontWeight: FontWeight.bold)),
                        //   description: Row(
                        //     children: [
                        //       RichText(
                        //         text: TextSpan(
                        //           text: 'Ratings | ',
                        //           style: DefaultTextStyle.of(context).style,
                        //           children: <TextSpan>[
                        //             TextSpan(
                        //                 text: averageRatingForShopId(
                        //                     ratingsForShopId(shop.docId))
                        //                     .toString() + "⋆",
                        //                 style: TextStyle(
                        //                     color: Colors.blue,
                        //                     fontWeight: FontWeight.bold)),
                        //           ],
                        //         ),
                        //       ),
                        //       // Padding(
                        //       //   padding: const EdgeInsets.only(left: 130.0),
                        //       //   child: Text(
                        //       //     "Add to Favorites",
                        //       //     style: TextStyle(
                        //       //         color: favorites.contains(shop.docId)
                        //       //             ? CupertinoColors.activeBlue
                        //       //             : CupertinoColors.systemGrey),
                        //       //   ),
                        //       // ),
                        //       // IconButton(
                        //       //   autofocus: true,
                        //       //   icon: Icon(
                        //       //       // Icons.favorite_outline
                        //       //       favorites.contains(shop.docId)
                        //       //           ? CupertinoIcons.heart_fill
                        //       //           : CupertinoIcons.heart,
                        //       //       color: favorites.contains(shop.docId)
                        //       //           ? CupertinoColors.systemBlue
                        //       //           : CupertinoColors.systemGrey),
                        //       //   onPressed: () {
                        //       //     setState(() {
                        //       //       if (favorites.contains(shop.docId)) {
                        //       //         favorites.remove(shop.docId);
                        //       //       } else {
                        //       //         favorites.add(shop.docId);
                        //       //       }
                        //       //     });
                        //       //   },
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                );
              } else if (shops[index]
                      .name
                      .toUpperCase()
                      .contains(editingController.text) ||
                  shops[index]
                      .name
                      .toLowerCase()
                      .contains(editingController.text)) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopPageScreen(
                              shop, ratingsForShopId(shop.docId))),
                    );
                  },
                  title: Text(shop.name),
                  trailing: Text(shop.isOpen ? "Open" : "Closed",
                      style: TextStyle(
                          fontSize: 15,
                          color: shop.isOpen ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.bold)),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
    // widgets.add(
    //   SmartRefresher(
    //   enablePullDown: true,
    //   enablePullUp: true,
    //   header: WaterDropHeader(
    //     waterDropColor: CupertinoColors.activeBlue,
    //   ),
    //   controller: _refreshController,
    //   onRefresh: _onRefresh,
    //   onLoading: _onRefresh,
    //   child: shopList(shops),
    // ),);
    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    var photo = FirebaseAuth.instance.currentUser!.photoURL;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Shalong",
              style: TextStyle(
                  fontSize: 51,
                  fontFamily: "SourceCodePro",
                  color: Colors.white),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blue])),
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
            // leading: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child:
            // ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerAccountInfoScreen()),
                    );
                  },
                  child: CircleAvatar(
                      radius: 20, backgroundImage: NetworkImage(photo!)),
                ),
              ),
            ],
          ),
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(
              waterDropColor: CupertinoColors.activeBlue,
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onRefresh,
            child: shopList(shops),
          )),
    );
  }
}
