import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shalong/Dashboard/BarberDashBoardScreen.dart';
import 'package:shalong/UserAuthentication/AuthManager.dart';
import 'AfterRegistration/ProfileUpdateScreen.dart';
import 'UserAuthentication/UserAuthScreen.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShalongApp(),
      routes: <String, WidgetBuilder>{
        '/launch': (BuildContext context) => LaunchScreen(),
        '/barberdashboardscreen': (BuildContext context) =>
            BarberDashboardScreen(),
        '/profileupdatescreen': (BuildContext context) => ProfileUpdateScreen()
      }));
}

class ShalongApp extends StatefulWidget {
  const ShalongApp({Key? key}) : super(key: key);

  @override
  _ShalongAppState createState() => _ShalongAppState();
}

class _ShalongAppState extends State<ShalongApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.hasData || snapshot.hasError) {
              return AnimatedSplashScreen(
                  nextScreen: LaunchScreen(), splash: Text("Shalong App"));
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ),
              );
            }
          }),
      // body: LogIn(),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return UserAuthScreen();
    } else {
      return FutureBuilder(
        future: profile(),
        builder: (BuildContext context, AsyncSnapshot<Profile?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                  width: 30,
                  height: 30,
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var profile = snapshot.data;
            if (profile == null) {
              return ProfileUpdateScreen();
            } else if (profile.isBarber) {
              return BarberDashboardScreen();
            } else {
              return BarberDashboardScreen();
            }
          } else {
            return UserAuthScreen();
          }
        },
      );
    }
  }
}
