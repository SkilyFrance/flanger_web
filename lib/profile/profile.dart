import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;


  ProfilePage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {

  Stream<dynamic> _fetchCurrentUserDatas;
  bool _searchingInProgress = false;

  Stream<dynamic> fetchCurrentUserDatas() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
     return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .snapshots();
  }

  String currentSoundCloud;
  String currentNotificationsToken;
  getCurrentSoundCloud() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          setState(() {
            currentSoundCloud = value.data()['soundCloud'];
            currentNotificationsToken = value.data()['notificationsToken'];
          });
        }
      });
  }

  initializationTimer() {
  return Timer(Duration(seconds: 5), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }

@override
  void initState() {
    _fetchCurrentUserDatas = fetchCurrentUserDatas();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff121212),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('Profile',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Manage here all your profile parameters.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.settings, color: Colors.greenAccent, size: 20.0),
                    ),
                  new Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: new StreamBuilder(
                      stream: _fetchCurrentUserDatas,
                      builder: (BuildContext context, snapshot) {

                        // Create profile container
                        return new Container();
                      }),
                   ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}