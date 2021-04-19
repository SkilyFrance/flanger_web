import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/inscription/sign.dart';
import 'package:flanger_web_version/inscription/signIn.dart';
import 'package:flutter/material.dart';

import 'sign.dart';

class LandinPage extends StatefulWidget {
  @override
  LandinPageState createState() => LandinPageState();
}

class LandinPageState extends State<LandinPage> {

  @override
  void initState() {
    print(Timestamp.now().microsecondsSinceEpoch);
    super.initState();
  }


  int lastUpdate = 1618841639718000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: new GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
          ),
          new Center(
            child: new Text('Flanger.',
            style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: new Center(
              child: new RichText(
                text: new TextSpan(
                  text: 'Pre-released :  ',
                  style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                  children: [
                    new TextSpan(
                      text: lastUpdate != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inMinutes < 1
                    ? 'few sec ago.'
                    : lastUpdate != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inMinutes < 60
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inMinutes.toString() + ' min ago.'
                    : lastUpdate != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inMinutes >= 60
                    && lastUpdate != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inHours <= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inHours.toString() + ' hours ago.'
                    : lastUpdate != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inHours >= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(lastUpdate)).inDays.toString() + ' days ago.'
                    : '',
                    style:  new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                    height: 1.1,
                    ),
                    ),
                  ]
                ),
              ),

              ),
            ),
          new Container(
            height: MediaQuery.of(context).size.height*0.02,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 50.0,
            ),
            ),
          new Center(
            child: new Text('The new community of electronic music producers.',
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 18.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.02,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 60.0,
            ),
            ),
          new Container(
            child: new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: new Text('Meet.',
                      style: new TextStyle(color: Colors.deepPurpleAccent, fontSize: 25.0, fontWeight: FontWeight.w500))),
                      new Text('👋', style: new TextStyle(fontSize: 45.0)),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 80.0),
                  child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: new Text('Share.',
                      style: new TextStyle(color: Colors.purpleAccent, fontSize: 25.0, fontWeight: FontWeight.w500))),
                      new Text('💬', style: new TextStyle(fontSize: 45.0)),
                  ],
                ),
                ),
               new Padding(
                  padding: EdgeInsets.only(left: 80.0),
                  child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: new Text('Progress.',
                      style: new TextStyle(color: Colors.cyanAccent, fontSize: 25.0, fontWeight: FontWeight.w500))),
                      new Text('🚀', style: new TextStyle(fontSize: 45.0)),
                  ],
                ),
                ),
              ],
            ),
          ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 120.0,
            ),
            ),
            startButtton(),
  
        ],
      ),
      ),
        ),
    );
  }

    startButtton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
        new SignPage()), 
        (route) => false);
      },
    child: new Container(
      constraints: new BoxConstraints(
        minWidth: 250.0,
        maxWidth: 250.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
          width: 1.0,
          color: Colors.grey
        ),
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new Center(
        child: new Text('START',
        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
    ));

  }

  signUpButton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        print('Sign up');
      },
    child: new Container(
      constraints: new BoxConstraints(
        minWidth: 250.0,
        maxWidth: 250.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.purpleAccent[700],
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new Center(
        child: new Text('SIGN UP',
        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}