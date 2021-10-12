import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shalong/Dashboard/CustomerDashboard/CustomerDashboardScreen.dart';
import 'package:shalong/UserAuthentication/AuthManager.dart';
import 'AfterRegistration/ProfileUpdateScreen.dart';
import 'Dashboard/BarberDashboard/BarberDashBoardScreen.dart';
import 'StartingScreen/StartingScreen.dart';
import 'UserAuthentication/UserAuthScreen.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShalongApp(),
      routes: <String, WidgetBuilder>{
        '/launch': (BuildContext context) => LaunchScreen(),
        '/barberdashboardscreen': (BuildContext context) =>
            BarberDashboardScreen(),
        '/profileupdatescreen': (BuildContext context) => ProfileUpdateScreen(),
        '/userauthscreen': (BuildContext context) => UserAuthScreen()
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
                pageTransitionType: PageTransitionType.rightToLeftWithFade,
                nextScreen: LaunchScreen(),
                splash: Stack(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 80.0),
                    //   child: Text(
                    //     "We'll style while you smile!",
                    //     style: TextStyle(color: Colors.black, fontSize: 22),
                    //   ),
                    // ),
                    RichText(
                      text: TextSpan(
                        text: 'Shalon',
                        style: TextStyle(
                            fontFamily: "Bunya-Regular_PERSONAL",
                            color: Colors.black,
                            fontSize: 60),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'g',
                              style: TextStyle(
                                  fontFamily: "Bunya-Regular_PERSONAL",
                                  color: CupertinoColors.systemRed,
                                  fontSize: 70))
                        ],
                      ),
                    ),
                  ],
                )
              );
            } else {
              return Scaffold(
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
            return Scaffold(
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
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var profile = snapshot.data;
            if (profile == null) {
              return ProfileUpdateScreen();
            } else if (profile.isBarber) {
              return BarberDashboardScreen();
            } else {
              return CustomerDashboardScreen();
            }
          } else {
            return UserAuthScreen();
          }
        },
      );
    }
  }
}
