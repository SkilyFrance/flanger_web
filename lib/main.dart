import 'package:flanger_web_version/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
        if(snapshot.connectionState == ConnectionState.done) {
          return new SplashPage();
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
