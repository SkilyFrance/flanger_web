import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/home/subpageUsers.dart';
import 'package:flanger_web_version/transition/fadeRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class ListOfUsers extends StatefulWidget {

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

  ListOfUsers({
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
  ListOfUsersState createState() => ListOfUsersState();
}

class ListOfUsersState extends State<ListOfUsers> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

 ScrollController _listOfUsersScrollController;
 int categoriePointed;

 Stream<dynamic> _fetchAllUsers;

 Stream<dynamic> fetchAllUsers() {
   return FirebaseFirestore.instance
    .collection('users')
    .limit(10)
    .snapshots();
 }


@override
  void initState() {
    _listOfUsersScrollController = new ScrollController();
   // _fetchAllUsers = fetchAllUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: new Container(
      height: 220.0,
      width: MediaQuery.of(context).size.width,
      child: new StreamBuilder(
        stream: _fetchAllUsers,
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasError || !snapshot.hasData) {
            return new Container(
              child: new Text('Error', style: new TextStyle(color: Colors.white)),
            );
          }
      return new Container(
      child: new ListView.builder(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      controller: _listOfUsersScrollController,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (BuildContext context, int indexUsers) {
        var ds = snapshot.data.docs[indexUsers];
        return new Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: new Tooltip(
            message: 'Tap to discover',
            textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context, 
                new FadeRoute(page: new SubPageUsers(
                  indexCategories: indexUsers,
                    currentUser: widget.currentUser,
                    currentUserPhoto:  widget.currentUserPhoto,
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
                    userProfileUID: ds['uid'],
                    userProfileUsername: ds['username'],
                    userProfileLevel: 'Ninja',
                    userProfilePhoto: ds['profilePhoto'] , 
                )));
            },
            child: new Container(
              height: 220.0,
              width: 170.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900],
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: categoriePointed == indexUsers
              ?  new Container(
              height: 200.0,
              width: 200.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.4),
                 ),
                 child: new Center(
                   child: new Icon(CupertinoIcons.eye_fill, color: Colors.white, size: 20.0),
                 ),
               )
              : new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  child: new Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: new ClipOval(
                    child: ds['profilePhoto'] != null
                    ? Image.network(
                      ds['profilePhoto'],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    )
                     /*FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, 
                      image: ds['profilePhoto'])*/
                    : new Container(
                      color: Colors.red,
                    ),
                  ),
                  ),
                  ),
                  new Container(
                    height: 100.0,
                    width: 200.0,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text(ds['username'] != null
                        ? ds['username']
                        : 'Username',
                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new RichText(
                          text: new TextSpan(
                            text: 'Lvl ',
                            style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal),
                            children: [
                              new TextSpan(
                                text: ' Newbie',
                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
          //),
        );
      }),
          );
        }),
      ),
    );
  }
}