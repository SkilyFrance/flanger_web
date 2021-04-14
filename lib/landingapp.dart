import 'package:flanger_web_version/inscription/sign.dart';
import 'package:flanger_web_version/inscription/signIn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingApp extends StatefulWidget {
  @override
  LandingAppState createState() => LandingAppState();
}

class LandingAppState extends State<LandingApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: new GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
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
            style: new TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12.0,letterSpacing: 2.0,
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
                      style: new TextStyle(color: Colors.deepPurpleAccent, fontSize: 18.0, fontWeight: FontWeight.w500))),
                      new Text('👋', style: new TextStyle(fontSize: 35.0)),
                  ],
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 80.0),
                  child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: new Text('Discuss.',
                      style: new TextStyle(color: Colors.purpleAccent, fontSize: 18.0, fontWeight: FontWeight.w500))),
                      new Text('💬', style: new TextStyle(fontSize: 35.0)),
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
                      style: new TextStyle(color: Colors.cyanAccent, fontSize: 18.0, fontWeight: FontWeight.w500))),
                      new Text('🚀', style: new TextStyle(fontSize: 35.0)),
                  ],
                ),
                ),
              ],
            ),
          ),
          ),
          new Container(
            constraints: new BoxConstraints(
              minHeight: 50.0,
            ),
            ),
            downloadOnIOS(),
            new Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: downloadOnAndroid(),
            ),
        ],
      ),
      ),
        ),
    );
  }
    downloadOnIOS() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        launch('https://apps.apple.com/us/app/flanger/id1556875695');
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
        child: new Text('Download on IOS',
        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal),
        ),
      ),
    ));

  }
    downloadOnAndroid() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        launch('https://play.google.com/store/apps/details?id=com.flanger.flanger_android');
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
        child: new Text('Download on Android',
        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal),
        ),
      ),
    ));

  }

}