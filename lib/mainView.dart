import 'dart:html';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_web_version/home/homeAllposts.dart';
import 'package:flanger_web_version/home/homeMenu.dart';
import 'package:flanger_web_version/profile/profile.dart';
import 'package:flanger_web_version/savedPost/savedAllposts.dart';
import 'package:flanger_web_version/savedPost/savedMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'home/homeAllposts.dart';
import 'home/homeAllposts.dart';
import 'home/homeAllposts.dart';
import 'home/homeMenu.dart';
import 'inscription/landingPage.dart';
import 'inscription/landingPage.dart';
import 'notifications/notificationsPage.dart';
import 'profile/profile.dart';
import 'savedPost/savedAllposts.dart';


class MainViewPage extends StatefulWidget {

  //InjectionsDatas
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;

  MainViewPage({
    Key key,
    this.currentUser,
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  MainViewPageState createState() => MainViewPageState();
}

class MainViewPageState extends State<MainViewPage> with SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  //Notifications listener
  bool newNotification = false;
  CollectionReference reference = FirebaseFirestore.instance.collection('users');
  notificationListener() {
    reference.doc(widget.currentUser).collection('notifications').snapshots().listen((event) {
      event.docChanges.forEach((element) {
        if(element.doc['alreadySeen'] == false) {
          setState(() {
            newNotification = true;
          });
        } else {
          setState(() {
            newNotification = false;
          });
        }
       });
    });
  }
  
  //CurrentUserData listener
 /* String currentAboutMe;
  String currentSoundCloud;
  String currentSpotify;
  String currentInstagram;
  String currentYoutube;
  String currentTwitter;
  String currentTwitch;
  String currentMixcloud;
  String currentNotificationsToken;*/
  Stream<dynamic> _fetchCurrentUserDatas;
  
  Stream<dynamic> fetchCurrentUserDatas() {
    return FirebaseFirestore.instance
    .collection('users')
    .doc(widget.currentUser)
    .snapshots();
  }
  /*currentDataListener() {
    reference.doc(widget.currentUser).snapshots().listen((DocumentSnapshot documentSnapshot) {
      setState(() {
        currentSoundCloud = documentSnapshot.data()['soundCloud'];
        currentSpotify = documentSnapshot.data()['spotify'];
        currentInstagram = documentSnapshot.data()['instagram'];
        currentYoutube = documentSnapshot.data()['youtube'];
        currentTwitter = documentSnapshot.data()['twitter'];
        currentTwitch = documentSnapshot.data()['twitch'];
        currentMixcloud = documentSnapshot.data()['mixcloud'];
        currentNotificationsToken = documentSnapshot.data()['notificationsToken'];
      });
    });
  }*/



  signOut() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LandinPage()),
            (_) => false));
  }
  

  TabController _controller;
  int _selectedIndex = 0;


  @override
  void initState() {
    _fetchCurrentUserDatas = fetchCurrentUserDatas();
    notificationListener();
    _selectedIndex = 0;
    _controller = new TabController(length: 4, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fetchCurrentUserDatas,
      builder: (BuildContext context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
        return  new Container(
          height: MediaQuery.of(context).size.height*0.40,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
        );
        }
       if(snapshot.hasError || !snapshot.hasData) {
       return new Container(
        height: MediaQuery.of(context).size.height*0.50,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: new Center(
          child: 
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                new Text('An error occured.',
                style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
              child: new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0))
            ],
          ),
        ));
       }
       return MaterialApp(
         color: Colors.black,
         debugShowCheckedModeBanner: false,
         home: new Scaffold(
           appBar: new AppBar(
             elevation: 10.0,
             backgroundColor: Color(0xff121212),
             bottom: new PreferredSize(
               preferredSize: new Size(0.0, 0.0),
               child: new TabBar(
               unselectedLabelColor: Colors.grey[800],
               indicatorSize: TabBarIndicatorSize.label,
               indicatorColor: Colors.deepPurpleAccent,
               controller: _controller,
               tabs: [
                 Tab(icon: new Icon(CupertinoIcons.house)),
                 Tab(icon: new Badge(shape: BadgeShape.circle,badgeColor: newNotification == true ? Colors.red : Colors.transparent, position: BadgePosition.topEnd(top: 0, end: -10), padding: EdgeInsets.all(6),
                 child: new Icon(CupertinoIcons.bell))),
                 Tab(icon: new Icon(CupertinoIcons.cloud_download)),
                 Tab(icon: new Icon(CupertinoIcons.person)),
               ]
             ),
             ),
            /* actions: [
               new Padding(
               padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
               child: new Material(
               color: Colors.transparent,
               child: new PopupMenuButton(
                 child: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0),
                 color: Colors.grey[400],
                 shape: new RoundedRectangleBorder(
                   borderRadius: new BorderRadius.circular(5.0)
                 ),
                 onSelected: (selectedValue)  {
                 return showDialog(
                   context: context,
                   builder: (context) {
                     return StatefulBuilder(
                       builder: (BuildContext dialoContext, StateSetter dialogSeState){
                         return new AlertDialog(
                           backgroundColor: Color(0xff121212),
                           title: new Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                             new Center(
                               child: new Container(
                                 child: new Text('Are you sure to quit ?',
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Padding(
                               padding: EdgeInsets.only(top: 30.0),
                               child: new Center(
                                 child: new Icon(Icons.logout, color: Colors.grey[600], size: 30.0),
                               ),
                             ),
                             new Padding(
                               padding: EdgeInsets.only(top: 30.0),
                               child: new Container(
                                 height: 38.0,
                                 width: 220.0,
                                 color: Colors.transparent,
                                 child: new Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     new InkWell(
                                       onTap: () {
                                         signOut();
                                       },
                                     child: new Container(
                                       height: 38.0,
                                       width: 100.0,
                                       decoration: new BoxDecoration(
                                         borderRadius: new BorderRadius.circular(5.0),
                                         color: Colors.transparent,
                                       ),
                                       child: new Center(
                                         child: new Text('Yes, please',
                                         style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                                         ),
                                       ),
                                     ),
                                     ),
                                     new InkWell(
                                       onTap: () {
                                         Navigator.pop(dialoContext);
                                       },
                                     child: new Container(
                                       height: 38.0,
                                       width: 100.0,
                                       decoration: new BoxDecoration(
                                         borderRadius: new BorderRadius.circular(5.0),
                                         color: Colors.deepPurpleAccent,
                                       ),
                                       child: new Center(
                                         child: new Text('No, thanks',
                                         style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                         ),
                                       ),
                                     ),
                                     ),
                                   ],
                                 )
                               ),
                             ),
                             ],
                           ),
                         );
                       });
                   }
                 );
                 },
                 itemBuilder: (BuildContext ctx) => [
                   new PopupMenuItem(
                     mouseCursor: MouseCursor.defer,
                     child: new Row(
                       children: [
                         new Text('Log out',
                         style: new TextStyle(fontSize: 12.0),
                         ),
                         new Padding(padding: EdgeInsets.only(left: 5.0),
                         child: new Icon(Icons.logout, size: 20.0, color: Colors.black))]
                         ), value: '1'),
                         ]
               ),
             ),
               ),
             ],*/
            /* title: new Padding(
               padding: EdgeInsets.only(left: 0.0),
               child: new Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
             new Container(
               color: Colors.transparent,
               width: 150.0,
             child: new Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 new Container(
                   height: 40.0,
                   width: 40.0,
                 child: new ClipOval(
               child: new Image.asset('web/icons/flanger512px.png', fit: BoxFit.cover)),
               ),
               new Padding(
                 padding: EdgeInsets.only(left: 17.0),
                 child: new Text('Flanger.', style: new TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
                 ),
               ],
             )
           ),
                 ],
               ),
               )*/
               ),
           body: new TabBarView(
             physics: new NeverScrollableScrollPhysics(),
             controller: _controller,
             children: [
               new HomeMenu(
                 currentUser: widget.currentUser,
                 currentUserPhoto: snapshot.data['profilePhoto'],
                 currentUserUsername: snapshot.data['username'],
                 currentAboutMe: snapshot.data['aboutMe'],
                 currentSoundCloud: snapshot.data['soundCloud'],
                 currentSpotify: snapshot.data['spotify'],
                 currentInstagram: snapshot.data['instagram'],
                 currentYoutube: snapshot.data['youtube'],
                 currentTwitter: snapshot.data['twitter'],
                 currentTwitch: snapshot.data['twitch'],
                 currentMixcloud: snapshot.data['mixcloud'],
                 currentNotificationsToken: snapshot.data['notificationsToken'],
               ),
               new NotificationsPage(
                 currentUser: widget.currentUser,
                 currentUserPhoto: snapshot.data['profilePhoto'],
                 currentUserUsername: snapshot.data['username'],
                 currentAboutMe: snapshot.data['aboutMe'],
                 currentSoundCloud: snapshot.data['soundCloud'],
                 currentSpotify: snapshot.data['spotify'],
                 currentInstagram: snapshot.data['instagram'],
                 currentYoutube: snapshot.data['youtube'],
                 currentTwitter: snapshot.data['twitter'],
                 currentTwitch: snapshot.data['twitch'],
                 currentMixcloud: snapshot.data['mixcloud'],
                 currentNotificationsToken: snapshot.data['notificationsToken'],
               ),
               new SavedMenu(
                 currentUser: widget.currentUser,
                 currentUserPhoto: snapshot.data['profilePhoto'],
                 currentUserUsername: snapshot.data['username'],
                 currentAboutMe: snapshot.data['aboutMe'],
                 currentSoundCloud: snapshot.data['soundCloud'],
                 currentSpotify: snapshot.data['spotify'],
                 currentInstagram: snapshot.data['instagram'],
                 currentYoutube: snapshot.data['youtube'],
                 currentTwitter: snapshot.data['twitter'],
                 currentTwitch: snapshot.data['twitch'],
                 currentMixcloud: snapshot.data['mixcloud'],
                 currentNotificationsToken: snapshot.data['notificationsToken'],
               ),
               new ProfilePage(
                 currentUser: widget.currentUser,
                 currentUserPhoto: snapshot.data['profilePhoto'],
                 currentUserUsername: snapshot.data['username'],
                 currentAboutMe: snapshot.data['aboutMe'],
                 currentSoundCloud: snapshot.data['soundCloud'],
                 currentSpotify: snapshot.data['spotify'],
                 currentInstagram: snapshot.data['instagram'],
                 currentYoutube: snapshot.data['youtube'],
                 currentTwitter: snapshot.data['twitter'],
                 currentTwitch: snapshot.data['twitch'],
                 currentMixcloud: snapshot.data['mixcloud'],
                 currentNotificationsToken: snapshot.data['notificationsToken'],
               ),
             ],
           ),
         ),
       );
      });
  }

}