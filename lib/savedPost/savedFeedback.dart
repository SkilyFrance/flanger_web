import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/home/postContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class SavedFeedback extends StatefulWidget {

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


  SavedFeedback({
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
  SavedFeedbackState createState() => SavedFeedbackState();
}


class SavedFeedbackState extends State<SavedFeedback> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool feedbackPostShowing = false;

  ScrollController _listPostScrollController = ScrollController();
  ScrollController _listFeedbackScrollController = ScrollController();
  List<bool> listIsExpanded = [];
  List<TextEditingController> listTextEditingController = [];
  List<FocusNode> listFocusNodeController = [];

  //PostEditing controller
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _subjectEditingFocusNode = new FocusNode();
  List<int> subListFeedbackCategorie = [];
  TextEditingController _bodyEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  int categoryPosted = 0;

  bool _searchingInProgress = false;

  // VARIABLES FOR PLAY A TRACK ON POST CONTAINER //
  AudioPlayer postContainerAudioPlayer = new AudioPlayer();
  Duration postContainerDurationTrack;
  Duration postContainerCurrentPositionTrack;
  double postContainerTrackDragStart = 0.0;
  ///////////////////////////////////////
  
  Stream<dynamic> _fetchAllSavedPosts;
  Stream<dynamic> fetchAllSavedPosts() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('feedbacks')
      .where('savedBy', arrayContains: widget.currentUser)
      .snapshots();
  }





  initializationTimer() {
  return Timer(Duration(seconds: 10), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }


@override
  void initState() {
    _fetchAllSavedPosts = fetchAllSavedPosts();
    _listPostScrollController = new ScrollController();
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
        child: new GestureDetector(
          onTap: (){
            print('ok');
            FocusScope.of(context).requestFocus(new FocusNode());
            },
        child: new SingleChildScrollView(
          physics: new AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('All saved feedbacks',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Add here all feedbacks you want to track.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.eye, color: Colors.greenAccent, size: 20.0),
                    ),
                  ],
                )
              ),
               new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Container(
                  constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 850.0,
                  ),
                child: new StreamBuilder(
                  stream: _fetchAllSavedPosts,
                  builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        /*child: new Center(
                          child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                          ),
                        ),*/
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
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.20,
                        width: MediaQuery.of(context).size.width*0.50,
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(10.0)
                        ),
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                new Text('Add your first saved feedback by clicking on',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 16.0, fontWeight: FontWeight.normal,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              child: new Icon(Icons.more_horiz, color: Colors.grey[600], size: 30.0),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child:new Text('from the home tab.',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 16.0, fontWeight: FontWeight.normal,
                                ),
                               ),
                              ),
                            ],
                          ),
                      ));
                      }
                      return new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
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
                            List<List<int>> listfeedbackCategories = List<List<int>>.filled(snapshot.data.docs.length, subListFeedbackCategorie, growable: true);
                            return new Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new PostContainer(
                                    comesFromHome: false,
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
                                  ),
                                ],
                              ),
                            );
                          }),
                      );
                      }),
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
              ?  new Column(
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