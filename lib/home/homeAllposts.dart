import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/bodyEditing.dart';
import 'package:flanger_web_version/home/postContainer.dart';
import 'package:flanger_web_version/requestList.dart';
import 'package:flanger_web_version/subjectEditing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../requestList.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../requestList.dart';



class HomeAllPosts extends StatefulWidget {

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

  HomeAllPosts({
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
  HomeAllPostsState createState() => HomeAllPostsState();
}


class HomeAllPostsState extends State<HomeAllPosts> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  //BodyController Page view
  PageController _pageViewBodyController;



  //Variables to change screen
  //
  bool issuesIsCurrentScreen = false;
  bool tipsIsCurrentScreen = false;
  bool projectIsCurrentScreen = false;
  bool feedbackIsCurrentScreen = false;

  int tabChoosen = 0;
  ScrollController _listPostScrollController = new ScrollController();
  List<bool> listIsExpanded = [];
  List<TextEditingController> listTextEditingController = [];
  List<FocusNode> listFocusNodeController = [];
  ScrollController _feedScrollController = new ScrollController();



  // VARIABLES FOR PLAY A TRACK ON POST CONTAINER //
  AudioPlayer postContainerAudioPlayer = new AudioPlayer();
  List<int> subListFeedbackCategorie = [];
  Duration postContainerDurationTrack = new Duration(milliseconds: 10);
  Duration postContainerCurrentPositionTrack = new Duration(milliseconds: 10);
  double postContainerTrackDragStart = 0.0;
  ///////////////////////////////////////

  bool _searchingInProgress = false;
  Stream<dynamic> _fetchTips;
  Stream<dynamic> fetchTips() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
    }
  

  initializationTimer() {
  return Timer(Duration(seconds: 10), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }

 bool _showStopAudioPlayer = false;

@override
  void initState() {
    tipsIsCurrentScreen = true;
    _fetchTips = fetchTips();
    _pageViewBodyController = new PageController(initialPage: 0, viewportFraction: 1);
    print('soundCloud = ' + widget.currentSoundCloud);
    print('Spotify = ' + widget.currentSpotify);
    _feedScrollController = new ScrollController();
    _listPostScrollController = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    postContainerAudioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      backgroundColor: Color(0xff121212),
      body:
      new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
       child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
        child: new GestureDetector(
          onTap: (){
            print('ok');
            FocusScope.of(context).requestFocus(new FocusNode());
            },
        child: new SingleChildScrollView(
          controller: _feedScrollController,
          scrollDirection: Axis.vertical,
          physics: new AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('All posts',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Your feed is automatically up to date.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 20.0),
                    ),
                  ],
                )
              ),

                                  /*new Padding(
                                    padding: EdgeInsets.only(top: 40.0, bottom: 0.0),
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(20.0),

                                      ),
                                      child: new CupertinoSegmentedControl(
                                          unselectedColor: Colors.transparent,
                                          borderColor: Colors.grey[900],
                                          selectedColor: Colors.deepPurpleAccent,
                                          children: <int, Widget>{
                                            0: new Padding(
                                              padding: EdgeInsets.all(8.0),
                                            child: new Container(
                                              child: new Text("NEW",
                                              style: new TextStyle(color: tabChoosen == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                            ),
                                            1: new Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: new Container(
                                              child:  new Text("TREND",
                                              style: new TextStyle(color: tabChoosen == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                            ),
                                          },
                                          groupValue: tabChoosen,
                                          onValueChanged: (value) {
                                            setState(() {
                                            tabChoosen = value;
                                            print('tabChoosen = $tabChoosen');
                                          });
                                        }),
                                    ),
                                  ),*/
              //TipsContainer
               new Container(
               child: new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                  /*constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 850.0,
                  ),*/
                //child: 
                /*new StreamBuilder(
                      stream: _fetchTips,
                      builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                      );
                      }
                      if(snapshot.hasError) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                new Text('No data, please restart.',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              child: new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0)),
                            ],
                          ),
                      ));
                      }
                      if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                new Text('No data, please restart.',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              child: new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0)),
                            ],
                          ),
                      ));
                      }
                     return new Container(
                       height: 300.0,
                       width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _listPostScrollController,
                          physics: new NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var ds = snapshot.data.docs[index];
                            List<dynamic> arrayOfLikes = ds['likedBy'];
                            List<dynamic> arrayOfFires = ds['firedBy'];
                            List<dynamic> arrayOfRockets = ds['rocketedBy'];
                            List<dynamic> arrayOfSavedBy = ds['savedBy'];
                            listIsExpanded.add(false);
                            listTextEditingController.add(TextEditingController());
                            listFocusNodeController.add(FocusNode());
                            //
                            //
                           //List<double> postContainerTrackDragStart = List<double>.filled(snapshot.data.docs.length, subPostContainerTrackDragStart, growable: true);
                           // List<Duration> postContainerCurrentPositionTrack = List<Duration>.filled(snapshot.data.docs.length, subPostContainerCurrentPositionTrack, growable: true);
                           // List<Duration> postContainerDurationTrack = List<Duration>.filled(snapshot.data.docs.length, subPostContainerDurationTrack, growable: true);
                           // List<AudioPlayer> postContainerAudioPlayer = List<AudioPlayer>.filled(snapshot.data.docs.length, subPostContainerAudioPlayer, growable: true);
                            List<List<int>> listfeedbackCategories = List<List<int>>.filled(snapshot.data.docs.length, subListFeedbackCategorie, growable: true);
                            postContainerAudioPlayer = new AudioPlayer();
                            Duration postContainerDurationTrack;
                            postContainerCurrentPositionTrack = new Duration(milliseconds: 10);
                            postContainerTrackDragStart = 0.0;
                            //
                            return new Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new PostContainer(
                                    comesFromHome: true,
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
                                    listIsExpanded: listIsExpanded,
                                    index: index,
                                    listTextEditingController: listTextEditingController,
                                    listFocusNodeController: listFocusNodeController,
                                    listfeedbackCategories: listfeedbackCategories,
                                    postID: ds['postID'],
                                    typeOfPost: ds['typeOfPost'],
                                    timestamp: ds['timestamp'],
                                    adminUID: ds['adminUID'],
                                    subject: ds['subject'],
                                    body: ds['body'],
                                    trackURL: ds['typeOfPost'] == 'feedback' ? ds['trackURL'] : 'null',
                                    trackDuration: ds['typeOfPost'] == 'feedback' ? ds['trackDuration'] : 0.0,
                                    postContainerTrackDivisions: ds['typeOfPost'] == 'feedback' ? ds['divisions'] : 0,
                                    postContainerTrackStartParticular: ds['typeOfPost'] == 'feedback' ? ds['startParticularPart'] : 0.0,
                                    postContainerTrackEndParticular: ds['typeOfPost'] == 'feedback' ? ds['endParticularPart'] : 0.0,
                                    likes: ds['likes'],
                                    likedBy: arrayOfLikes,
                                    fires: ds['fires'],
                                    firedBy: arrayOfFires,
                                    rockets: ds['rockets'],
                                    rocketedBy: arrayOfRockets,
                                    comments: ds['comments'],
                                    commentedBy: ds['commentedBy'],
                                    reactedBy: ds['reactedBy'],
                                    savedBy: arrayOfSavedBy,
                                    postContainerAudioPlayer: postContainerAudioPlayer,
                                    postContainerDurationTrack: postContainerDurationTrack,
                                    postContainerCurrentPositionTrack: postContainerCurrentPositionTrack,
                                    postContainerTrackDragStart: postContainerTrackDragStart,
                                    adminProfilephoto: ds['adminProfilephoto'],
                                    adminUsername: ds['adminUsername'],
                                    adminNotificationsToken: ds['adminNotificationsToken'],
                                    homeContext: contex,
                                    withImage: ds['withImage'],
                                    imageURL: ds['imageURL'],
                                  ),
                                ],
                              ),
                            );
                          }),
                      );
                      }),*/
                      ),
                     ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: _searchingInProgress == true
              ? new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     new Container(
                        height: MediaQuery.of(context).size.height*0.50,
                        width: MediaQuery.of(context).size.width*0.60,
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
                                          duration: const Duration(milliseconds: 10000),
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