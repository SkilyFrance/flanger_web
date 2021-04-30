import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogProfile extends StatefulWidget {

  String adminUID;
  String adminProfilephoto;
  String adminUsername;


  DialogProfile({
    Key key,
    this.adminUID,
    this.adminProfilephoto,
    this.adminUsername
  }) : super(key: key);


  @override
  DialogProfileState createState() => DialogProfileState();
}

class DialogProfileState extends State<DialogProfile> {
  @override
  Widget build(BuildContext context) {
    return new Container(
    child: new FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(widget.adminUID).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError || !snapshot.hasData) {
          return new Container(
            height: 300.0,
            width: 300.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Text('',
                style: new TextStyle(color: Colors.grey[600], fontSize: 17.0, fontWeight: FontWeight.normal),
                ),
                new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent)
                ),
              ],
            ),
          );
        }
        return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new Center(
            child: new Container(
              height: 60.0,
              width: 60.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900], 
                shape: BoxShape.circle,
              ),
              child: widget.adminProfilephoto != null
              ? new ClipOval(
                child: new Image.network(widget.adminProfilephoto, fit: BoxFit.cover),
              )
              : new Container(),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Center(
              child: new Text(
                widget.adminUsername != null
                ? widget.adminUsername
                : 'Username',
              style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)
              ),
            ),
            ),
            snapshot.data['aboutMe'] != 'null' && snapshot.data['aboutMe'] != null
            ? new Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: new Container(
                width: 350.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Center(
                      child: new Text('About me',
                      style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Text(snapshot.data['aboutMe'],
                      textAlign: TextAlign.justify,
                      style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal,
                      wordSpacing: 1.0,
                      letterSpacing: 1.0,
                      height: 1.5,
                      ),
                      ),
                      ),
                  ],
                )
              ),
            )
            : new Container(),
     new Padding(
       padding: EdgeInsets.only(top: 30.0),
     child: new Container(
        height: 40.0,
        decoration: new BoxDecoration(
          color: Colors.transparent,
          borderRadius: new BorderRadius.circular(40.0),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            snapshot.data['soundCloud'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['soundCloud'])) {
                await launch(snapshot.data['soundCloud']);
              } else {
                print(snapshot.data['soundCloud'] + ' error to launch');
              }
              },
            child: new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                child: new ClipOval(
                  child: new Image.asset('web/icons/soundCloud.png', fit: BoxFit.cover)),
              )))
            : new Container(),
            snapshot.data['spotify'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['spotify'])) {
                await launch(snapshot.data['spotify']);
              } else {
                print(snapshot.data['spotify'] + ' error to launch');
              }
              },
            child: new Container(
                height: 45.0,
                width: 45.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                child: new ClipOval(
                  child: new Image.asset('web/icons/spotify.png', fit: BoxFit.cover)),
              )))
            : new Container(),
          
            snapshot.data['instagram'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['instagram'])) {
                await launch(snapshot.data['instagram']);
              } else {
                print(snapshot.data['instagram'] + ' error to launch');
              }
              },
            child: new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                child: new ClipOval(
                  child: new Image.asset('web/icons/instagram.png', fit: BoxFit.cover)),
              )))
            : new Container(),
          
            snapshot.data['youtube'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['youtube'])) {
                await launch(snapshot.data['youtube']);
              } else {
                print(snapshot.data['youtube'] + ' error to launch');
              }
              },
            child: new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                child: new ClipOval(
                  child: new Image.asset('web/icons/youtube.png', fit: BoxFit.cover)),
              )))
            : new Container(),
          
            snapshot.data['twitter'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['twitter'])) {
                await launch(snapshot.data['twitter']);
              } else {
                print(snapshot.data['twitter'] + ' error to launch');
              }
              },
            child: new Container(
                height: 48.0,
                width: 48.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(1.5),
                child: new ClipOval(
                  child: new Image.asset('web/icons/twitter.png', fit: BoxFit.cover)),
              )))
            : new Container(),

            snapshot.data['twitch'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['twitch'])) {
                await launch(snapshot.data['twitch']);
              } else {
                print(snapshot.data['twitch'] + ' error to launch');
              }
              },
            child: new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                child: new ClipOval(
                  child: new Image.asset('web/icons/twitch.png', fit: BoxFit.cover)),
              )))
            : new Container(),
          
           snapshot.data['mixcloud'] != 'null'
            ? new InkWell(
              onTap: () async {
              if(await canLaunch(snapshot.data['mixcloud'])) {
                await launch(snapshot.data['mixcloud']);
              } else {
                print(snapshot.data['mixcloud'] + ' error to launch');
              }
              },
            child: new Container(
                height: 48.0,
                width: 48.0,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: new Padding(
                  padding: EdgeInsets.all(0.5),
                child: new ClipOval(
                  child: new Image.asset('web/icons/mixcloud.png', fit: BoxFit.cover)),
              )))
            : new Container(),

          ],
        )
      ),
     ),
      ],
      );

      })
    );
  }
}