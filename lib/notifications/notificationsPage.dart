import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/notifications/notificationsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class NotificationsPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentAboutMe;
  String currentSoundCloud;
  String currentSpotify;
  String currentInstagram;
  String currentYoutube;
  String currentTwitter;
  String currentTwitch;
  String currentMixcloud;
  String currentNotificationsToken;


  NotificationsPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentAboutMe,
    this.currentSoundCloud,
    this.currentSpotify,
    this.currentInstagram,
    this.currentYoutube,
    this.currentTwitter,
    this.currentTwitch,
    this.currentMixcloud,
    this.currentNotificationsToken,
    }) : super(key: key);


  @override
  NotificationsPageState createState() => NotificationsPageState();
}


class NotificationsPageState extends State<NotificationsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<NotificationsPageState> notificationsPageKey = GlobalKey();

  Stream<dynamic> _fetchAllNotifications;
  ScrollController _notificationsListViewController = new ScrollController();


 bool _searchingInProgress = false; 

  String _postIDSelected = '';
  int listTileSelected;
  Stream<dynamic> fetchAllNotifcations() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('notifications')
      .orderBy('postID', descending: true)
      .snapshots();
  }

  String postIDSelected;
  Stream<dynamic> _fetchPostsDatas;

  Stream<dynamic> fetchPostsDatas(String dsUID, String collection) {
    return FirebaseFirestore.instance
      .collection(collection)
      .doc(dsUID)
      .snapshots();
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
    print(widget.currentUser);
    _fetchAllNotifications = fetchAllNotifcations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      backgroundColor: Color(0xff121212),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
       child: new Stack(
         children: [
           new Positioned(
             top: 0.0,
             left: 0.0,
             right: 0.0,
             bottom: 0.0,
            child: new SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: new StreamBuilder(
                        stream: _fetchAllNotifications,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                            return  new Container(
                              height: MediaQuery.of(context).size.height*0.40,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                            );
                            }
                            if(snapshot.hasError) {
                            return  new Container(
                              height: MediaQuery.of(context).size.height*0.40,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: new Center(
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      new Text('No data, please restart.',
                                      style: new TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0)
                                  ],
                                ),
                            ));
                            }
                            if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
                              return new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*0.30,
                                  constraints: new BoxConstraints(
                                    minWidth: 200.0,
                                    maxWidth: 400.0),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      new Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                      child: new Text('Notifications',
                                      style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                                      )),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: new Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            new Text('Automatically up to date.',
                                          style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.normal),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(top: 15.0),
                                            child: new Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 17.0),
                                            ),
                                          ],
                                        )
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 100.0),
                                        child: new Center(
                                          child: new Text('Empty.',
                                          style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*0.70,
                                  color: Colors.grey[900].withOpacity(0.3),
                                  constraints: new BoxConstraints(
                                    minWidth: 350.0,
                                  ),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.50,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: new Center(
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            new Text('Choose a notification to display',
                                            style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                          child: new Icon(CupertinoIcons.tv, color: Colors.grey[600], size: 30.0))
                                        ],
                                  )
                                  ),
                                  ),
                                    ],
                                  )
                                  ),
                                ],
                              );
                            }
                            return new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*0.30,
                                  constraints: new BoxConstraints(
                                    minWidth: 200.0,
                                    maxWidth: 400.0
                                  ),
                                  color: Colors.transparent,
                                  child: new SingleChildScrollView(
                                    controller: _notificationsListViewController,
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                      child: new Text('Notifications',
                                      style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                                      )),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: new Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            new Text('Automatically up to date.',
                                          style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.normal),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(top: 15.0),
                                            child: new Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 17.0),
                                            ),
                                          ],
                                        )
                                      ),
                                  new ListView.builder(
                                    shrinkWrap: true,
                                    physics: new NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var ds = snapshot.data.docs[index];
                                      return new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Container(
                                          color: listTileSelected == index ? Colors.grey[900].withOpacity(0.7) : Colors.transparent,
                                            child: new InkWell(
                                              splashColor: Colors.grey[900],
                                              highlightColor: Colors.grey[900],
                                              focusColor: Colors.grey[900],
                                          child: new ListTile(
                                            onTap: () {
                                              setState(() {
                                                _postIDSelected = ds['postID'];
                                                listTileSelected = index;
                                                _fetchPostsDatas = fetchPostsDatas(ds['postID'], ds['body'] == 'has commented this feedback request 🎹 : '? 'feedbacks' : 'posts');
                                                print('_postIDSelected = $_postIDSelected');
                                                if(ds['alreadySeen'] == false) {
                                                  FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(widget.currentUser)
                                                    .collection('notifications')
                                                    .doc(ds['notificationID'])
                                                    .update({
                                                      'alreadySeen': true
                                                    }).whenComplete(() => print('Cloud Firestore : notificationID, already seen set to true'));
                                                } else {print('AlreadySeen');}
                                              });
                                            },
                                            focusColor: Colors.grey[900],
                                            leading: new Container(
                                              height: MediaQuery.of(context).size.height*0.05,
                                              width: MediaQuery.of(context).size.height*0.05,
                                              decoration: new BoxDecoration(
                                                color: Colors.grey[900],
                                                shape: BoxShape.circle,
                                              ),
                                              child: new ClipOval(
                                              child: ds['lastUserProfilephoto'] != null
                                              ? new Image.network(ds['lastUserProfilephoto'], fit: BoxFit.cover)
                                              : new Container(),
                                            )),
                                            title: new Text(
                                              ds['title'] != null
                                              ? ds['title']
                                              : 'No title',
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.normal),
                                            ),
                                            subtitle: new Text(
                                              ds['body'] != null
                                              ? ds['lastUserUsername'] + ' ' + ds['body']
                                              : 'new action on this post',
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: ds['alreadySeen'] == false
                                            ? new Container(
                                              height: 10.0,
                                              width: 10.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.cyanAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                            : new Icon(CupertinoIcons.chevron_right, color: Colors.grey[900])
                                          ))),
                                          new Divider(height: 1.0, color: Colors.grey[900].withOpacity(0.8)),
                                        ],
                                      );
                                    },
                                  ),
                                  ],
                                  ),
                                  ),
                                ),
                                _postIDSelected == ''
                                ? new Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*0.70,
                                  color: Colors.grey[900].withOpacity(0.3),
                                  constraints: new BoxConstraints(
                                    minWidth: 350.0,
                                  ),
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: new Container(
                                    height: MediaQuery.of(context).size.height*0.50,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: new Center(
                                      child: 
                                      _searchingInProgress == false ?
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            new Text('Choose a notification to display',
                                            style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                          child: new Icon(CupertinoIcons.tv, color: Colors.grey[600], size: 30.0))
                                        ],
                                      )
                                      : new Container(),
                                  )),
                                  ),
                                )
                                : new Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*0.70,
                                  color: Colors.grey[900].withOpacity(0.3),
                                  constraints: new BoxConstraints(
                                    minWidth: 350.0,
                                  ),
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: new StreamBuilder(
                                      stream: _fetchPostsDatas,
                                      builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
                                          if(snapshot.connectionState == ConnectionState.waiting) {
                                          return  new Container(
                                            height: MediaQuery.of(context).size.height*0.40,
                                            width: MediaQuery.of(context).size.width,
                                            color: Colors.transparent,
                                            child: new Center(
                                              child: new CircularProgressIndicator(
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                              ),
                                            ),
                                          );
                                          }
                                          if(!snapshot.data.exists || !snapshot.hasData) {
                                          return  new Container(
                                            height: MediaQuery.of(context).size.height*0.40,
                                            width: MediaQuery.of(context).size.width,
                                            color: Colors.transparent,
                                            child: new Center(
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    new Text('This post may have been deleted.',
                                                    style: new TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  new Padding(
                                                    padding: EdgeInsets.only(top: 10.0),
                                                  child: new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0))
                                                ],
                                              ),
                                          ));
                                          }
                                          return new NotificationsDetails(
                                            currentUser: widget.currentUser,
                                            currentUserPhoto: widget.currentUserPhoto,
                                            currentUserUsername: widget.currentUserUsername,
                                            currentAboutMe: widget.currentAboutMe,
                                            currentSoundCloud: widget.currentSoundCloud,
                                            currentSpotify: widget.currentSpotify,
                                            currentInstagram: widget.currentInstagram,
                                            currentYoutube: widget.currentYoutube,
                                            currentTwitter: widget.currentTwitter,
                                            currentTwitch: widget.currentTwitch,
                                            currentMixcloud: widget.currentMixcloud,
                                            currentNotificationsToken: widget.currentNotificationsToken,
                                            snapshot: snapshot,
                                          );
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            );
                        },          
                      ),
                    ),
                  ],
                ),
              ),
             ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: _searchingInProgress == true
              ?  new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     new Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width*0.70,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Container(
                            height: 150.0,
                            width: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: new BorderRadius.circular(5.0),
                            ),
                            child: new Center(
                              child: new Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: new Stack(
                                  children: [
                                    new Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: new ClipOval(
                                        child: new Image.asset('web/icons/flanger512px.png', fit: BoxFit.cover),
                                      ),
                                    ),
                                    new Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                          child: new Center(
                                          child: TweenAnimationBuilder<double>(
                                              tween: Tween<double>(begin: 0.0, end: 1),
                                              duration: const Duration(milliseconds: 5000),
                                              curve: Curves.linear,
                                              builder: (context, value, _) => 
                                              new  CircularProgressIndicator(
                                                value: value,
                                                strokeWidth: 1.5,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent
                                              ),
                                            ),
                                            ),
                                          ),
                                          ),
                                        ],
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : new Container(),
            ),

         ],
       ),
      ),
    );
  }
}