import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_web_version/home.dart';
import 'package:flanger_web_version/profile/profile.dart';
import 'package:flanger_web_version/savedPost/savedPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'home.dart';
import 'home.dart';
import 'inscription/landingPage.dart';
import 'inscription/landingPage.dart';
import 'notifications/notificationsPage.dart';
import 'profile/profile.dart';
import 'savedPost/savedPost.dart';


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


    signOut() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LandinPage()),
            (_) => false));
  }
  

  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(icon: new Icon(CupertinoIcons.house)),
    Tab(icon: new Icon(CupertinoIcons.bell)),
    Tab(icon: new Icon(CupertinoIcons.cloud_download)),
    Tab(icon: new Icon(CupertinoIcons.person)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = new TabController(length: list.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.black,
          bottom: new TabBar(
            unselectedLabelColor: Colors.grey[800],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.deepPurpleAccent,
            controller: _controller,
            tabs: list,
          ),
          actions: [
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
                 if(selectedValue == 1) {
                   signOut();
                 }
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
            /*child: new Container(
              height: 35.0,
              width: 35.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
              ),
              ),*/
            ),
          ],
          title: new Padding(
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
            )),
        body: new TabBarView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
             new HomePage(
              currentUser: widget.currentUser,
              currentUserPhoto: widget.currentUserPhoto,
              currentUserUsername: widget.currentUserUsername,
            ),
            new NotificationsPage(
              currentUser: widget.currentUser,
              currentUserPhoto: widget.currentUserPhoto,
              currentUserUsername: widget.currentUserUsername,
            ),
            new SavedPostPage(
              currentUser: widget.currentUser,
              currentUserPhoto: widget.currentUserPhoto,
              currentUserUsername: widget.currentUserUsername,
            ),
             new ProfilePage(
              currentUser: widget.currentUser,
              currentUserPhoto: widget.currentUserPhoto,
              currentUserUsername: widget.currentUserUsername,
             ),
          ],
        ),
      ),
    );
  }

  
    /* new Scaffold(
        backgroundColor: Color(0xff121212),
        appBar: new AppBar(
          backgroundColor: Colors.black,
          leading: new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
            child: new ClipOval(
            child: new Image.asset('web/icons/flanger512px.png', fit: BoxFit.cover)
            ),
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: new IconButton(
                  icon: new Icon(currentTab == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
                    color: currentTab == 0 ? Colors.white :  Colors.grey,
                    ), 
                  onPressed: () {
                    setState(() {
                      currentScreen = new HomePage(
                        currentUser: widget.currentUser,
                        currentUserPhoto: widget.currentUserPhoto,
                        currentUserUsername: widget.currentUserUsername,
                      );
                      currentTab = 0;
                    });
                  },
                  ),
                ),
              new Container(
                height: MediaQuery.of(context).size.height*0.01,
                width: MediaQuery.of(context).size.width*0.08,
              ),
              new Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: new IconButton(
                  icon: new Icon(currentTab == 1 ? CupertinoIcons.bell_solid : CupertinoIcons.bell,
                    color: currentTab == 1 ? Colors.white :  Colors.grey,
                    ), 
                  onPressed: () {
                    setState(() {
                      currentScreen = new NotificationsPage(
                        currentUser: widget.currentUser,
                        currentUserPhoto: widget.currentUserPhoto,
                        currentUserUsername: widget.currentUserUsername,
                      );
                      currentTab = 1;
                    });
                  },
                  ),
                ),
              new Container(
                height: MediaQuery.of(context).size.height*0.01,
                width: MediaQuery.of(context).size.width*0.08,
              ),
              new Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: new IconButton(
                  icon: new Icon(currentTab == 2 ? CupertinoIcons.cloud_download_fill : CupertinoIcons.cloud_download,
                    color: currentTab == 2 ? Colors.white :  Colors.grey,
                    ), 
                  onPressed: () {
                    setState(() {
                      currentScreen = new SavedPostPage(
                        currentUser: widget.currentUser,
                        currentUserPhoto: widget.currentUserPhoto,
                        currentUserUsername: widget.currentUserUsername,
                      );
                      currentTab = 2;
                    });
                  },
                  ),
                ),
              new Container(
                height: MediaQuery.of(context).size.height*0.01,
                width: MediaQuery.of(context).size.width*0.08,
              ),
              new Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: new IconButton(
                  icon: new Icon(currentTab == 3 ? CupertinoIcons.person_fill : CupertinoIcons.person,
                    color: currentTab == 3 ? Colors.white :  Colors.grey,
                    ), 
                  onPressed: () {
                    setState(() {
                      currentScreen = new ProfilePage();
                      currentTab = 3;
                    });
                  },
                  ),
                ),
            ],
          ),
          actions: [
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
               onSelected: (selectedValue) {
                 signOut();
               },
               itemBuilder: (BuildContext ctx) => [
                new PopupMenuItem(
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
            /*child: new Container(
              height: 35.0,
              width: 35.0,
              decoration: new BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
              ),
              ),*/
            ),
          ],
        ),
        body: new PageStorage(
          bucket: bucket, 
          child: currentScreen,
        ),
      );*/

}