import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'inscription/landingPage.dart';
import 'inscription/landingPage.dart';
import 'inscription/usernamePage.dart';
import 'mainView.dart';



class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  {


  @override
  void initState() {
    //checkAuthState();
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
         return Scaffold(
         body: new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: new Container(
              height: 200.0,
              width: 350.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900].withOpacity(0.5),
              ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Connection on Flanger',
                    style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Container(
                        height: 25.0,
                        width: 25.0,
                      child: new Image.asset('web/icons/watermelon.png', fit: BoxFit.cover, height: 25.0, width: 25.0),
                    ),
                    ),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: new Container(
                    height: 50.0,
                    width: 50.0,
                    child: new Center(
                      child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent)),
                    ),
                  ),
                  ),
              ],
            ),
            ),
         ),
          );
        }
        if((snapshot.hasError || !snapshot.hasData) && snapshot.connectionState == ConnectionState.active) {
          return new LandinPage();
        }
        if(snapshot.data is User && snapshot.data != null) {
        print('authStateChanges : user is still connected');
        print('authStateChanges : user = ${snapshot.data.uid}');
          FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data.uid)
            .get()
            .then((value) {
              if(value.exists) {
                Navigator.pushReplacement(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                new MainViewPage(
                  currentUser: snapshot.data.uid,
                  currentUserUsername: value.data()['username'],
                  currentUserPhoto: value.data()['profilePhoto'],
                  notificationsToken: value.data()['notificationsToken'],
                  )));
              } else {
                //Value No exist
                Navigator.pushReplacement(
                  context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                  new UsernamePage(
                    currentUser: snapshot.data.uid, 
                    currentUserEmail: snapshot.data.email)));
              }
            }).catchError((error) => print(error));
        }
         return Scaffold(
         body: new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: new Container(
              height: 200.0,
              width: 350.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900].withOpacity(0.5),
              ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Connection on Flanger',
                    style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Container(
                        height: 25.0,
                        width: 25.0,
                      child: new Image.asset('web/icons/watermelon.png', fit: BoxFit.cover, height: 25.0, width: 25.0),
                    ),
                    ),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: new Container(
                    height: 50.0,
                    width: 50.0,
                    child: new Center(
                      child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent)),
                    ),
                  ),
                  ),
              ],
            ),
            ),
         ),
          );
      });
  }
}