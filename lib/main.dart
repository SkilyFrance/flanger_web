import 'package:flanger_web_version/landingapp.dart';
import 'package:flanger_web_version/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'landingapp.dart';
import 'splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flanger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        //checkErrors
        if(snapshot.hasError) {
          return new Container(
            color: Colors.black,
            child: new CupertinoActivityIndicator(
              animating: true,
            ),
            );
        }
        if(kIsWeb) {
          if(MediaQuery.of(context).devicePixelRatio > 2.0) {
            return LandingApp();
          } else {
            return SplashPage();
          }
        }
         return new Container(
         color: Colors.black,
         child: new CupertinoActivityIndicator(
           animating: true,
         ),
         );
      }
      ),
    );
  }
}
