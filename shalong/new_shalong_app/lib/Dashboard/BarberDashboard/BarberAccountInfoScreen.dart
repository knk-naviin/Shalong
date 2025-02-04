import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../UserAuthentication/AuthManager.dart';


class BarberAccountInfoScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<BarberAccountInfoScreen>
    with SingleTickerProviderStateMixin {
  bool isViewMode = true;
  late Profile? profileInfo;
  final FocusNode myFocusNode = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    profile().then((value) => {
          setState(() {
            profileInfo = value;
          })
        });
  }

  Future<void> updatedata() async {
    FirebaseFirestore Firestore = FirebaseFirestore.instance;

    Firestore.collection("user").doc(profileInfo!.docId).update({
      "name": profileInfo!.name,
      "phone": profileInfo!.phone,
      "email": profileInfo!.email,
      "is_barber": true
    });
    Firestore.collection("shop").doc(profileInfo!.docId).update({
      "name": profileInfo!.shops.first.name,
      "address": profileInfo!.shops.first.address,
      "phone": profileInfo!.shops.first.phone
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profileInfo == null) {
      return Scaffold(
        backgroundColor: Colors.white70,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Platform.isAndroid
                ? CircularProgressIndicator(
                    color: Colors.black45,
                  )
                : CupertinoActivityIndicator(
                    animating: true,
                    radius: 12,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading"),
            )
          ],
        )),
      );
    }
    var photo = FirebaseAuth.instance.currentUser!.photoURL;
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Account Info"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.grey, Colors.black26])),
          ),
          backgroundColor: Colors.white10,
          elevation: 0,
        ),
        body: new Container(
          color: Colors.white,
          child: Form(
            key: formkey,
            child:  ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                          radius: 70, backgroundImage: NetworkImage(photo!)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      isViewMode
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return "Enter Your Name";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value != null) {
                                        profileInfo!.name = value;
                                      }
                                    },
                                    initialValue: profileInfo?.name,
                                    enabled: !isViewMode,
                                    autofocus: !isViewMode,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new TextFormField(
                                    initialValue: profileInfo?.email,
                                    enabled: false,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new TextFormField(
                                      initialValue: profileInfo?.phone,
                                      enabled: false),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Shop Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Text(
                                'Shop Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Enter Your Shop Name";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      profileInfo!.shops.first.name = value;
                                    }
                                  },
                                  initialValue:
                                      profileInfo?.shops.first.name,
                                  enabled: !isViewMode,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Text(
                                'Shop Phonenumber',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Enter Your Shop PhoneNumber";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      profileInfo!.shops.first.phone =
                                          value;
                                    }
                                  },
                                  initialValue:
                                      profileInfo?.shops.first.name,
                                  enabled: !isViewMode,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Text(
                                'Shop address',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Enter Your Address";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      profileInfo!.shops.first.address =
                                          value;
                                    }
                                  },
                                  maxLines: 2,
                                  initialValue:
                                      profileInfo?.shops.first.address,
                                  enabled: !isViewMode,
                                ),
                              )),
                          !isViewMode ? _getActionButtons() : new Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    (formkey.currentState!.save());
                    setState(() {
                      updatedata();
                      isViewMode = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  }
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Text("Cancel"),
                onPressed: () {
                  setState(() {
                    isViewMode = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 14.0,
        child: FaIcon(
          FontAwesomeIcons.edit,
          color: Colors.black,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          isViewMode = false;
        });
      },
    );
  }
}
