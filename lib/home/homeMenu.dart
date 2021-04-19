import 'package:flanger_web_version/home/homeFeedback.dart';
import 'package:flanger_web_version/home/homeAllposts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeMenu extends StatefulWidget {

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

  HomeMenu({
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
  HomeMenuState createState() => HomeMenuState();
}

class HomeMenuState extends State<HomeMenu> with SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

 int _selectedIndex = 0;
 TabController _controller;

@override
  void initState() {
    _selectedIndex = 0;
    _controller = new TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(0xff121212),
      debugShowCheckedModeBanner: false,
         home: new Scaffold(
           appBar: new AppBar(
             backgroundColor: Color(0xff181819),
             bottom: new PreferredSize(
               preferredSize: Size.fromHeight(0.0),
             child: new TabBar(
               labelStyle: new TextStyle(fontWeight: FontWeight.bold),
               unselectedLabelColor: Colors.grey[800],
               indicatorSize: TabBarIndicatorSize.tab,
               indicatorColor: Colors.purple,
               controller: _controller,
               tabs: [
                 Tab(text: 'All posts'),
                 Tab(text: 'Feedbacks section'),
               ]
             ),
             ),
           ),
           body: new TabBarView(
             physics: new NeverScrollableScrollPhysics(),
             controller: _controller,
             children: [
              new HomeAllPosts(
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
              ),
              new HomeFeedback(
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
              ),
             ]),
         )
    );
  }
}