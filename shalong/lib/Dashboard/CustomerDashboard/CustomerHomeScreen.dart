import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shalong/Dashboard/CustomerDashboard/ShopPageScreen.dart';
import 'package:shalong/UserAuthentication/AuthManager.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late List<ShopInfo>? shops = null;
  List<String> favorites = [];
  // bool _icon = false;
  var searchText = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController editingController = TextEditingController();

  void _onRefresh() async {
    // monitor network fetch
    fetchShops().then((value) {
      setState(() {
        shops = value;
      });
      _refreshController.refreshCompleted();
    });
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    fetchShops().then((value) {
      setState(() {
        shops = value;
      });
      _refreshController.loadComplete();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  getratings(int ratingCount, int userCount) {
    return ratingCount / userCount;
  }

  Widget shopList(List<ShopInfo>? shops) {
    if (shops == null) {
      _onLoading();
      return Center(child: CircularProgressIndicator());
    }
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            setState(() {});
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)))),
        ),
      ),
      /*  Padding(
      padding: const EdgeInsets.all(10.0),
      child: CupertinoSearchTextField(
        onChanged: (String value)
        {

          print(value);
        }
        /*{
    shops.forEach((userDetail) {
    if (userDetail.name.contains(value) ||
    userDetail.name.contains(value)) shops.add(userDetail);
    });

    setState(() {

    });
    }*/,
        onSubmitted: (String value) {
          print('Submitted text: $value');
        },
    // backgroundColor: Colors.blue,
      ),
    )*/
    );
    // for (var shop in shops) {
      widgets.add(
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: (context, index) {
                var shop = shops[index];
                if (editingController.text.isEmpty) {
                  return Card(
                    borderOnForeground: true,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopPageScreen(
                                    shopname: shop.name,
                                    shopadd: shop.address,
                                    isopen: shop.isOpen,
                                    phoneno: shop.phone,
                                  )),
                        );
                      },
                      title: Text(
                        shop.name,
                        style: TextStyle(
                          letterSpacing: 2,
                          wordSpacing: 2,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            shop.address,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                wordSpacing: 2),
                          ),
                          Divider(),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Ratings | ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${shop.shopratings}★',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 67,
                              ),
                              Text("Add to Favorites"),
                              IconButton(
                                autofocus: true,
                                icon: Icon(
                                  // Icons.favorite_outline
                                  favorites.contains(shop.docId)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: favorites.contains(shop.docId) ? Colors.blue : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (favorites.contains(shop.docId)) {
                                      favorites.remove(shop.docId);
                                    } else {
                                      favorites.add(shop.docId);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(shop.isOpen ? "Open" : "Closed",
                          style: TextStyle(
                              color: shop.isOpen ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                } else if (shops[index]
                        .name
                        .toLowerCase()
                        .contains(editingController.text) ||
                    shops[index]
                        .name
                        .toLowerCase()
                        .contains(editingController.text)) {
                  return ListTile(
                    title: Text(shop.name),
                  );
                } else {
                  return Container();
                }
              }),
        ),
        /**/
      );
      //);
    // }

    return Column(children: widgets,);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      // footer: CustomFooter(
      //   builder: (BuildContext context, LoadStatus mode) {
      //     Widget body;
      //     if (mode == LoadStatus.idle) {
      //       body = Text("pull up load");
      //     }
      //     else if (mode == LoadStatus.loading) {
      //       body = CupertinoActivityIndicator();
      //     }
      //     else if (mode == LoadStatus.failed) {
      //       body = Text("Load Failed!Click retry!");
      //     }
      //     else if (mode == LoadStatus.canLoading) {
      //       body = Text("release to load more");
      //     }
      //     else {
      //       body = Text("No more Data");
      //     }
      //     return Container(
      //       height: 55.0,
      //       child: Center(child: body),
      //     );
      //   },
      // ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onRefresh,
      child: shopList(shops),
    );
  }

  //   if (shops == null) {
  //     fetchShops().then((value) => setState((){
  //       if (value != null) {
  //         shops = value;
  //       }
  //     }));
  //     return Center(child: CircularProgressIndicator());
  //   } else {
  //     return shopList(shops!);
  //   }
  // }

}
