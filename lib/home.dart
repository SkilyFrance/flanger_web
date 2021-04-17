import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/bodyEditing.dart';
import 'package:flanger_web_version/postContainer.dart';
import 'package:flanger_web_version/requestList.dart';
import 'package:flanger_web_version/subjectEditing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'requestList.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'requestList.dart';



class HomePage extends StatefulWidget {

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

  HomePage({
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
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  //BodyController Page view
  PageController _pageViewBodyController;


  Stream<dynamic> _fetchIssuesPosts;
  Stream<dynamic> _fetchTipsPosts;
  Stream<dynamic> _fetchProjectPosts;
  Stream<dynamic> _fetchTestFeedback;

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





  //PostEditing controller
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _subjectEditingFocusNode = new FocusNode();
  TextEditingController _bodyEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  int categoryPosted = 0;
  bool _lackOfSubjectOrBody = false;
  bool publishingInProgress = false;
  bool _searchingInProgress = false;

  // VARIABLES FOR POST A TRACK FOR FEEDBACK //
  AudioPlayer _feedbackAudioPlayer = new AudioPlayer();
  bool _musicIsUploaded = false;
  bool _musicUploadedInProgress = false;
  File _musicUploaded;
  Duration durationFileUploaded; //= Duration(milliseconds: 120);
  Duration currentPositionFeedbackPlayer;//= = Duration(milliseconds: 10);
  Duration currentBufferingFeedbackPlayer;//= = Duration(milliseconds: 10);
  double _dragValueStartFeedback = 0;
  double _dragValueEndFeedback = 60000; //222693;
  int _trackSplitFeedback = 6;
  ///////////////////////////////////////
  
  // VARIABLES FOR PLAY A TRACK ON POST CONTAINER //
  AudioPlayer postContainerAudioPlayer = new AudioPlayer();
  List<int> subListFeedbackCategorie = [];
  Duration postContainerDurationTrack = new Duration(milliseconds: 10);
  Duration postContainerCurrentPositionTrack = new Duration(milliseconds: 10);
  double postContainerTrackDragStart = 0.0;
  ///////////////////////////////////////

  
  
  /*Stream<dynamic> fetchAllPostsRecent() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
    }*/


  Stream<dynamic> fetchTestForFeedback() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('test')
      .orderBy('timestamp', descending: true)
      .snapshots();
    }
  

  Stream<dynamic> fetchIssuesPosts() {
    return FirebaseFirestore.instance
      .collection('posts')
      .where('typeOfPost', isEqualTo: 'issue')
      .snapshots();
  }

  Stream<dynamic> fetchTipsPosts() {
    return FirebaseFirestore.instance
      .collection('posts')
      .where('typeOfPost', isEqualTo: 'tip')
      .snapshots();
  }

  Stream<dynamic> fetchProjectPosts() {
    return FirebaseFirestore.instance
      .collection('posts')
      .where('typeOfPost', isEqualTo: 'project')
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
    _pageViewBodyController = new PageController(initialPage: 0, viewportFraction: 1);
    _fetchTipsPosts = fetchTipsPosts();
    _fetchTestFeedback = fetchTestForFeedback();
    _fetchIssuesPosts = fetchIssuesPosts();
    _fetchProjectPosts = fetchProjectPosts();
    print('soundCloud = ' + widget.currentSoundCloud);
    print('Spotify = ' + widget.currentSpotify);
    _feedScrollController = new ScrollController();
    _listPostScrollController = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _feedbackAudioPlayer.dispose();
    postContainerAudioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
        showDialog(
          barrierDismissible: true,
              context: context,
              builder: (context) {
                return new StatefulBuilder(
                  builder: (contextDialog, dialogSetState) {
                    return new AlertDialog(
                    backgroundColor: Color(0xff121212),
                      title: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Center(
                            child: new Container(
                              child: new Text('New post',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Center(
                              child: new Text('Your post is about',
                              style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Container(
                            child: new CupertinoSlidingSegmentedControl(
                              thumbColor: Colors.deepPurpleAccent,
                              backgroundColor: Colors.grey[900],
                              children: <int, Widget>{
                                0: new Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
                                child: new Container(
                                  child: new Text("Issue 💥",
                                  style: new TextStyle(color: categoryPosted == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                                1: new Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
                                  child: new Container(
                                  child:  new Text("Tip 💡",
                                  style: new TextStyle(color: categoryPosted == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                                2: new Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
                                  child: new Container(
                                  child:  new Text("Project 🚀",
                                  style: new TextStyle(color: categoryPosted == 2 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                                3: new Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
                                  child: new Container(
                                  child:  new Text("Feedback 🎹",
                                  style: new TextStyle(color: categoryPosted == 3 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                              },
                              groupValue: categoryPosted,
                              onValueChanged: (value) {
                                dialogSetState(() {
                                categoryPosted = value;
                                });
                            }),
                            ),
                            ),
                           categoryPosted == 3
                           ? new Container(
                             child: new Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: new Center(
                                    child: new Text(
                                      _musicUploadedInProgress == true && _musicIsUploaded == false
                                      ? 'This may take a few minutes'
                                      : 'Select a track from desktop',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: _musicUploadedInProgress == true && _musicIsUploaded == false ? FontWeight.normal : FontWeight.bold),
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: 
                                  _musicIsUploaded == false && _musicUploadedInProgress == false
                                  ? new InkWell(
                                    onTap: () async {
                                    if(kIsWeb) {
                                        InputElement uploadInput = FileUploadInputElement();
                                        uploadInput.accept = '.mp3,.aav,.wav';
                                        uploadInput.click();
                                        uploadInput.onChange.listen((event) async {
                                          final musicFile = uploadInput.files.first;
                                          final reader = FileReader();
                                          reader.readAsDataUrl(musicFile);
                                          reader.onLoadEnd.listen((loadEndEvent) async {
                                            print('Reader job done');
                                            dialogSetState(() {
                                              _musicUploadedInProgress = true;
                                              _musicUploaded = musicFile;
                                            });
                                            final _storage = firebase_storage.FirebaseStorage.instance;
                                            var ref = _storage.refFromURL('gs://flanger-39465.appspot.com');
                                            var snapshot = await ref.child('${widget.currentUser}/temporaryPathTrackUploaded').putBlob(_musicUploaded);
                                            print('Firebase storage (Temporary path) : Track uploaded.');
                                            var downloadUrl = await snapshot.ref.getDownloadURL().then((fileURL) async {
                                            await _feedbackAudioPlayer.setUrl(fileURL).whenComplete(() async {
                                                _feedbackAudioPlayer.durationStream.listen((event) {
                                                  dialogSetState((){
                                                 _musicUploadedInProgress  = false;
                                                 durationFileUploaded = _feedbackAudioPlayer.duration;
                                                 _dragValueEndFeedback = _feedbackAudioPlayer.duration.inMilliseconds.toDouble();
                                                 //_feedbackAudioPlayer.play();
                                                 _musicIsUploaded = true;
                                                 print('"durationFileUploaded = ${durationFileUploaded.inMilliseconds.toString()}');
                                                // 
                                                
                                                  });
                                                 _feedbackAudioPlayer.bufferedPositionStream.listen((event) {
                                                   dialogSetState((){
                                                     currentBufferingFeedbackPlayer = event;
                                                   });
                                                 //  print('currentBufferingFeedbackPlayer = ' + currentBufferingFeedbackPlayer.inMilliseconds.toString());
                                                 });
                                               _feedbackAudioPlayer.positionStream.listen((event) {
                                                   dialogSetState((){
                                                     currentPositionFeedbackPlayer = event;
                                                   });
                                                   print('_dragValueEndFeedback = ' + Duration(milliseconds: _dragValueEndFeedback.toInt()).toString());
                                                   print('currentPositionFeedbackPlayer = $currentPositionFeedbackPlayer');
                                                 if(currentPositionFeedbackPlayer >= Duration(milliseconds: _dragValueEndFeedback.toInt())) {
                                                   print('AudioPlayer: Extract finished');
                                                   _feedbackAudioPlayer.pause();
                                                  
                                                  }
                                               });
                                               });

                                              });
                                            });
                                          });
                                        });
                                      } else {
                                        print('No ksiweb');
                                      }
                                    },
                                  child: new Container(
                                    height: 45.0,
                                    width: 150.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900].withOpacity(0.5),
                                      borderRadius: new BorderRadius.circular(10.0),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      ),
                                      child: new Center(
                                        child: new Text('Tap to upload', 
                                        style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                                  )
                                  : new Container(
                                    height: 45.0,
                                    width: 200.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900].withOpacity(0.5),
                                      borderRadius: new BorderRadius.circular(10.0),
                                      ),
                                      child: new Center(
                                        child: _musicUploadedInProgress == true && _musicIsUploaded == false
                                        ? new CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                        )
                                        : new Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            new Text('Successfully uploaded', 
                                            style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(left: 10.0),
                                            child: Icon(CupertinoIcons.check_mark_circled, color: Colors.cyanAccent, size: 20.0),
                                            ),
                                        ],
                                        ),
                                      ),
                                    ),
                                  ),
                                _musicIsUploaded == true
                               ? new Padding(
                                 padding: EdgeInsets.only(top: 20.0),
                               child: new Container(
                                 height: 150.0,
                                 decoration: new BoxDecoration(
                                 color: Colors.grey[900].withOpacity(0.5),
                                 borderRadius: new BorderRadius.circular(10.0)
                                 ),
                               child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: new Center(
                                    child: new Text('Get a feedback from a particular part ?',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                      child: new IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        icon: new Icon(
                                       _feedbackAudioPlayer.playerState.playing == true 
                                       ? CupertinoIcons.pause_circle_fill
                                       : CupertinoIcons.play_circle_fill,
                                        size: 30.0,
                                        color: Colors.white,
                                        ), 
                                        onPressed: () {
                                          if(_feedbackAudioPlayer.playerState.playing == true) {
                                            _feedbackAudioPlayer.pause();
                                          } else {
                                            _feedbackAudioPlayer.seek(Duration(milliseconds: _dragValueStartFeedback.toInt())).whenComplete(() {
                                              print('AudioPlayer: Start is seeked');
                                            _feedbackAudioPlayer.play();
                                            });
                                          }
                                        },
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: new Container(
                                          height: 50.0,
                                          width: 450.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: new BorderRadius.circular(40.0)
                                          ),
                                          child: new Stack(
                                            children: [
                                                new SliderTheme(
                                                  data: Theme.of(context).sliderTheme.copyWith(
                                                    trackHeight: 10.0,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0), 
                                                    thumbColor: Colors.deepPurpleAccent,
                                                    //disabledThumbColor: Colors.transparent,
                                                    //trackShape: RoundedRectSliderTrackShape(),
                                                    inactiveTrackColor: Colors.grey[900],
                                                    activeTrackColor: Colors.deepPurple.withOpacity(0.2),
                                                   // disabledInactiveTickMarkColor: Colors.transparent,
                                                    activeTickMarkColor: Colors.deepPurpleAccent.withOpacity(0.6),
                                                    inactiveTickMarkColor: Colors.grey[600],
                                                   // tickMarkShape: SliderTickMarkShape.noTickMark,
                                                  ),
                                                child: new RangeSlider(
                                                  labels: new RangeLabels(Duration(milliseconds: _dragValueStartFeedback.toInt().round()).toString().split('.')[0],Duration(milliseconds: _dragValueEndFeedback.toInt().round()).toString().split('.')[0]),
                                                  min: 0.0,
                                                  max: durationFileUploaded != null ? durationFileUploaded.inMilliseconds.toDouble() : 120000,
                                                  values: new RangeValues(_dragValueStartFeedback, _dragValueEndFeedback),
                                                  onChangeStart: (value) {
                                                    if(_feedbackAudioPlayer.playerState.playing == true) {
                                                      _feedbackAudioPlayer.pause();
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    dialogSetState((){
                                                      _dragValueStartFeedback = value.start;
                                                      _dragValueEndFeedback = value.end;
                                                    });
                                                  },
                                                  divisions: _trackSplitFeedback,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        ),
                                   new Padding(
                                     padding: EdgeInsets.only(bottom: 10.0),
                                     child: new Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         new IconButton(
                                           focusColor: Colors.transparent,
                                           splashColor: Colors.transparent,
                                           highlightColor: Colors.transparent,
                                           icon: Icon(CupertinoIcons.minus_circled, color: Colors.deepPurpleAccent.withOpacity(0.5), size: 30.0), 
                                           onPressed: () {
                                             if(_trackSplitFeedback > 2) {
                                               dialogSetState((){
                                                 _trackSplitFeedback--;
                                               });
                                             } else {
                                               print('sorry minimum 2');
                                             }
                                           }),
                                         new IconButton(
                                           focusColor: Colors.transparent,
                                           splashColor: Colors.transparent,
                                           highlightColor: Colors.transparent,
                                           icon: Icon(CupertinoIcons.add_circled, color: Colors.deepPurpleAccent.withOpacity(0.8), size: 30.0), 
                                           onPressed: () {
                                             if(_trackSplitFeedback <= 9) {
                                               dialogSetState((){
                                                 _trackSplitFeedback++;
                                               });
                                             } else {
                                               print('sorry maximum 10');
                                             }
                                           }),
                                       ],
                                     ),
                                   ),
                                    ],
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        new Text('Duration :',
                                        style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.bold),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: new Text(
                                          _feedbackAudioPlayer.playerState.playing == true
                                          ? Duration(milliseconds: (_dragValueEndFeedback-currentPositionFeedbackPlayer.inMilliseconds).toInt()).toString().split('.')[0]
                                          : Duration(milliseconds: (_dragValueEndFeedback-_dragValueStartFeedback).toInt()).toString().split('.')[0],
                                          style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.normal),
                                        // _dragValueEndFeedback.toInt().round()).toString().split('.')[0]
                                        ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ],
                                ),
                               ),
                               )
                                : new Container(),
                              new Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: new Center(
                                  child: new Text('About this track',
                                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              new Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                                child: new Container(
                                  height: 100.0,
                                child: new BodyEditingController(
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
                                  currentFocusNode: _bodyEditingFocusNode,
                                  currentTextEditingController: _bodyEditingController,
                              ),
                              ),
                              ),
                               ],
                             ),
                           )
                           /// VIEW CATEGORY POST 1 - 3
                           : new Container(
                             child: new Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                           new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                              child: new Text('Subject',
                              style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                            child: new SubjectEditingController(
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
                              currentFocusNode: _subjectEditingFocusNode,
                              currentTextEditingController: _subjectEditingController,
                          ),
                        ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                              child: new Text('Body',
                              style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                            child: new BodyEditingController(
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
                              currentFocusNode: _bodyEditingFocusNode,
                              currentTextEditingController: _bodyEditingController,
                          ),
                        ),
                        _lackOfSubjectOrBody == true
                        ? new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: new Text('All fields are required.',
                          style: new TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.normal),
                          ),
                          )
                        : new Container(),
                               ],
                             )
                           ),
                        ],
                      ),
                      content: new Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: new InkWell(
                        onTap: () async  {
                          if(categoryPosted == 3 && _musicUploaded != null && _bodyEditingController.text.length > 3) {
                          _feedbackAudioPlayer.stop();
                          int _timeStampFileURL = DateTime.now().microsecondsSinceEpoch;
                           final _storage = firebase_storage.FirebaseStorage.instance;
                           var ref = _storage.refFromURL('gs://flanger-39465.appspot.com');
                           var snapshot = await ref.child('${widget.currentUser}/feedbacktrack/$_timeStampFileURL').putBlob(_musicUploaded);
                           print('Firebase storage (Temporary path) : Track uploaded.');
                           var downloadUrl = await snapshot.ref.getDownloadURL().then((fileURL) async {
                            feedbackPublication(
                            fileURL,
                            durationFileUploaded.inMilliseconds.toDouble(),
                            _trackSplitFeedback,
                            _dragValueStartFeedback,
                            _dragValueEndFeedback,
                            widget.currentUser, 
                            widget.currentUserUsername, 
                            widget.currentUserPhoto, 
                            widget.currentNotificationsToken, 
                            widget.currentSoundCloud,
                            _bodyEditingController.value.text, 
                            'Feedback section', 
                            dialogSetState, 
                            publishingInProgress, 
                            contextDialog, 
                            _subjectEditingController,
                            _bodyEditingController, 
                            categoryPosted);
                           });
                          } else if((categoryPosted == 0 || categoryPosted == 1 || categoryPosted == 2) &&_subjectEditingController.text.length > 3 && _bodyEditingController.text.length > 3 && categoryPosted != null) {
                          publicationRequest(
                            widget.currentUser, 
                            widget.currentUserUsername, 
                            widget.currentUserPhoto, 
                            widget.currentNotificationsToken, 
                            widget.currentSoundCloud,
                            _bodyEditingController.value.text, 
                            _subjectEditingController.value.text, 
                            dialogSetState, 
                            publishingInProgress, 
                            contextDialog, 
                            _subjectEditingController,
                            _bodyEditingController, 
                            categoryPosted);
                          } else {
                            dialogSetState((){
                              _lackOfSubjectOrBody = true;
                            });
                          }
                        },
                        child: new Container(
                          height: 45.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(40.0),
                            border: new Border.all(
                              width: 1.0,
                              color: Colors.deepPurpleAccent,
                            )
                          ),
                          child: new Center(
                            child: publishingInProgress == false
                            ? new Text('Publish',
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                            )
                            : new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                  //   ),
                    //  ),
                  );
                  });
              } 
            ).whenComplete(() {
              if(_feedbackAudioPlayer.playerState.playing == true) {
                _feedbackAudioPlayer.stop();
              }
              setState(() {
                publishingInProgress = false;
                _lackOfSubjectOrBody = false;
                _musicIsUploaded = false;
                categoryPosted = 0;
              });
            });
        },
        child: new Icon(CupertinoIcons.bolt_horizontal_circle_fill, color: Colors.white),
        ),
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
                  child: new Text('Home',
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
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Center(
                  child: new Container(
                    height: 40.0,
                    width: 450.0,
                    color: Colors.transparent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new InkWell(
                          onTap: () {
                            setState(() {
                              issuesIsCurrentScreen = false;
                              tipsIsCurrentScreen = true;
                              projectIsCurrentScreen = false;
                              feedbackIsCurrentScreen = false;
                            });
                          },
                        child: new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: tipsIsCurrentScreen == true ?  Color(0xff62DDF9) : Colors.grey[900],
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Tips',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        )),
                        new InkWell(
                          onTap: () {
                            setState(() { 
                              issuesIsCurrentScreen = false;
                              tipsIsCurrentScreen = false;
                              projectIsCurrentScreen = false;
                              feedbackIsCurrentScreen = true;
                            });
                          },
                        child: new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: feedbackIsCurrentScreen == true ? Colors.purpleAccent : Colors.grey[900],
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Feedbacks',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        )),
                        new InkWell(
                          onTap: () {
                            setState(() {
                              issuesIsCurrentScreen = true;
                              tipsIsCurrentScreen = false;
                              projectIsCurrentScreen = false;
                              feedbackIsCurrentScreen = false;
                            });
                          },
                        child: new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: Colors.grey[900], //currentScreen == issuesScreen ? Color(0xff7360FC) : Colors.grey[900],
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Issues',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        )),
                        new InkWell(
                          onTap: () {
                            setState(() {
                      
                            });
                          },
                        child: new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color:  Colors.grey[900], // currentScreen == projectScreen ? Color(0xffBF88FF) : Colors.grey[900],
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Projects',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        ),
                        ),
                      ],
                    )
                  ),
                ),
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
                  constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 850.0,
                  ),
                child: new StreamBuilder(
                      stream: _fetchTestFeedback,
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
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
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
                                  ),
                                ],
                              ),
                            );
                          }),
                      );
                      }),
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