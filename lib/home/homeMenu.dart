import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flanger_web_version/home/list_following.dart';
import 'package:flanger_web_version/home/list_users.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/home/homeFeedback.dart';
import 'package:flanger_web_version/home/homeAllposts.dart';
import 'package:flanger_web_version/home/listCategorieDiscussion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as Im;
import 'package:http/http.dart' as http;
import '../bodyEditing.dart';
import '../requestList.dart';
import '../subjectEditing.dart';

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

 //Dicussion categories variables //
 ScrollController _categorieDiscussionScrollController = new ScrollController();
 ScrollController _listViewNewsScrollController = new ScrollController();
 //////////////////////////////////



  //PostEditing controller
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _subjectEditingFocusNode = new FocusNode();
  TextEditingController _bodyEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  int categoryPosted = 0;
  bool _lackOfSubjectOrBody = false;
  bool publishingInProgress = false;
  bool _searchingInProgress = false;
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;

  // VARIABLES FOR POST A TRACK FOR FEEDBACK //
  AudioPlayer _feedbackAudioPlayer = new AudioPlayer();
  bool _musicIsUploaded = false;
  bool _musicUploadedInProgress = false;
  File _musicUploaded;
  String _musicURLuploadedInStorage;
  Duration durationFileUploaded; //= Duration(milliseconds: 120);
  Duration currentPositionFeedbackPlayer;//= = Duration(milliseconds: 10);
  Duration currentBufferingFeedbackPlayer;//= = Duration(milliseconds: 10);
  double _dragValueStartFeedback = 0;
  double _dragValueEndFeedback; //222693;
  int _trackSplitFeedback = 6;
  ///////////////////////////////////////

@override
  void initState() {
    _selectedIndex = 0;
    print('newDate = $newDate');
    _controller = new TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _feedbackAudioPlayer.dispose();
    super.dispose();
  }

  var newDate = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-3);
  var newDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-7)).toString();
  var dateToday = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  String apiURL = 'https://newsapi.org/v2/everything?domains=edm.com,djmag.com&from=${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-3)).toString()}&to=${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}&sortBy=publishedAt&apiKey=41f01ac496d04712980b1d09c9c7d93a';
  http.Response response;
  var responseConverted;
  var articlesData;

   fetchData() async {
   response = await http.get(Uri.parse(apiURL)).catchError((error) {print(error);});
   if(response.statusCode == 200) {
     print(response.statusCode);
     print(response.body);
     setState(() {
       responseConverted = json.decode(response.body);
       articlesData = responseConverted['articles'];
     });
   } else {
     print('Some error : ${response.statusCode}');
   }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      /*floatingActionButton: new FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.red,
        onPressed: () {
          fetchData();
        },
      ),*/
      /*floatingActionButton: new FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          /*FirebaseFirestore.instance
            .collection('posts')
            .get()
            .then((value) {
              value.docs.forEach((element) {
                element.reference.update({
                  'withImage': false,
                  'imageURL': null,
                });
              });
            });*/
            
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
                             child: new StatefulBuilder(
                               builder: (BuildContext audioContext, StateSetter audioSetState) {
                             return new Column(
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
                                  ?  new InkWell(
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
                                            audioSetState(() {
                                              _musicUploadedInProgress = true;
                                              _musicUploaded = musicFile;
                                            });
                                            int _timeStampFileURL = DateTime.now().microsecondsSinceEpoch;
                                            final _storage = firebase_storage.FirebaseStorage.instance;
                                            var ref = _storage.refFromURL('gs://flanger-39465.appspot.com');
                                            var snapshot = await ref.child('${widget.currentUser}/feedbacktrack/$_timeStampFileURL').putBlob(_musicUploaded);
                                            //var snapshot = await ref.child('${widget.currentUser}/temporaryPathTrackUploaded').putBlob(_musicUploaded);
                                            print('Firebase storage (real path) : Track uploaded.');
                                            var downloadUrl = await snapshot.ref.getDownloadURL().then((fileURL) async {
                                            await _feedbackAudioPlayer.setUrl(fileURL).whenComplete(() async {
                                                _feedbackAudioPlayer.durationStream.listen((event) {
                                                  audioSetState(() {
                                                _musicURLuploadedInStorage = fileURL;
                                                 _musicUploadedInProgress  = false;
                                                 durationFileUploaded = _feedbackAudioPlayer.duration;
                                                 _dragValueEndFeedback = _feedbackAudioPlayer.duration.inMilliseconds.toDouble();
                                                 //_feedbackAudioPlayer.play();
                                                 _musicIsUploaded = true;
                                                 print('"durationFileUploaded = ${durationFileUploaded.inMilliseconds.toString()}');
                                                // 
                                                
                                                  });
                                                 _feedbackAudioPlayer.bufferedPositionStream.listen((event) {
                                                   audioSetState((){
                                                     currentBufferingFeedbackPlayer = event;
                                                   });
                                                 //  print('currentBufferingFeedbackPlayer = ' + currentBufferingFeedbackPlayer.inMilliseconds.toString());
                                                 });
                                               _feedbackAudioPlayer.positionStream.listen((event) {
                                                   audioSetState((){
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
                                    child: new Text('Put forward a particular part ?',
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
                                                    audioSetState((){
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
                                               audioSetState((){
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
                                               audioSetState((){
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
                             );
                              }),
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
                            padding: EdgeInsets.only(top: 20.0),
                            child: _photoUploadInProgress == false && _fileURLPhotoUploaded == 'null'
                            ? new InkWell(
                              onTap: () {
                              if(kIsWeb) {
                                InputElement uploadInput = FileUploadInputElement();
                                uploadInput.accept = '.png,.jpg';
                                uploadInput.click();
                                uploadInput.onChange.listen((event) {
                                  final filePhoto = uploadInput.files.first;
                                  final reader = FileReader();
                                  reader.readAsDataUrl(filePhoto);
                                  reader.onLoadEnd.listen((loadEndEvent) async {
                                   dialogSetState(() {
                                      _imageUploadedToPost = filePhoto;
                                      _photoUploadInProgress = true;
                                    });
                                    int _timeStampFileURL = DateTime.now().microsecondsSinceEpoch;
                                    final _storage = firebase_storage.FirebaseStorage.instance;
                                    var ref = _storage.refFromURL('gs://flanger-39465.appspot.com');
                                    var snapshot = await ref.child('${widget.currentUser}/imagePost/$_timeStampFileURL').putBlob(_imageUploadedToPost);
                                    //var snapshot = await ref.child('${widget.currentUser}/temporaryPathTrackUploaded').putBlob(_musicUploaded);
                                    print('Firebase storage (real path) : Image uploaded.');
                                    var downloadUrl = await snapshot.ref.getDownloadURL().then((fileURL) {
                                    dialogSetState(() {
                                        _fileURLPhotoUploaded = fileURL;
                                        _photoUploadInProgress = false;
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
                              width: 200.0,
                              decoration: new BoxDecoration(
                                color: Colors.grey[900].withOpacity(0.5),
                                borderRadius: new BorderRadius.circular(10.0),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.deepPurpleAccent,
                                ),
                                ),
                                child: new Center(
                                  child: new Text('Add a file image', 
                                  style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                                  ),
                                ),
                              ),
                              )
                              : _photoUploadInProgress == true && _fileURLPhotoUploaded == 'null'
                              ? new Container(
                              height: 45.0,
                              width: 200.0,
                              decoration: new BoxDecoration(
                                color: Colors.grey[900].withOpacity(0.5),
                                borderRadius: new BorderRadius.circular(10.0),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.transparent,
                                ),
                                ),
                                child: new Container(
                                  height: 30.0,
                                  width: 30.0,
                                  child: new Center(
                                    child: new CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
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
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.transparent,
                                ),
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  new Text('Uploaded ', 
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new Icon(CupertinoIcons.check_mark_circled, color: Colors.green, size: 20.0),
                                    ),
                                  ],
                                ),
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
                      child: new Container(
                        child: new StatefulBuilder(
                          builder: (BuildContext contextButton, StateSetter publicationButtonSetState) {
                            return new InkWell(
                        onTap: () async  {
                          if(categoryPosted == 3 && _musicUploaded != null && _bodyEditingController.text.length > 3) {
                          _feedbackAudioPlayer.stop();
                            publicationRequestForFeedback(
                            _musicURLuploadedInStorage,
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
                            publicationButtonSetState, 
                            publishingInProgress, 
                            contextButton, 
                            _subjectEditingController,
                            _bodyEditingController, 
                            categoryPosted);
                          } else if((categoryPosted == 0 || categoryPosted == 1 || categoryPosted == 2) &&_subjectEditingController.text.length > 3 && _bodyEditingController.text.length > 3 && categoryPosted != null) {
                          publicationPostWithOrWithoutPhoto(
                            _fileURLPhotoUploaded != '' ? true : false,
                            _fileURLPhotoUploaded != '' ? _fileURLPhotoUploaded : null,
                            widget.currentUser, 
                            widget.currentUserUsername, 
                            widget.currentUserPhoto, 
                            widget.currentNotificationsToken, 
                            widget.currentSoundCloud,
                            _bodyEditingController.value.text, 
                            _subjectEditingController.value.text, 
                            publicationButtonSetState, 
                            publishingInProgress, 
                            contextButton, 
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
                      );
                          }
                      ),

                    ),
                  //   ),
                    //  ),
                  ));
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
                _fileURLPhotoUploaded = 'null';
              });
            });
        },
        child: new Icon(CupertinoIcons.bolt_horizontal_circle_fill, color: Colors.white),
        ),*/
           /*appBar: new AppBar(
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
                 new Tab(text: 'All posts'),
                 new Tab(text: 'Feedbacks section'),
               ]
             ),
             ),
           ),*/
           body: new Container(
             child: new SingleChildScrollView(
               padding: EdgeInsets.only(bottom: 80.0),
               scrollDirection: Axis.vertical,
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 new Padding(
                   padding: EdgeInsets.only(top: 50.0, left: 40.0),
                   child: new Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       new Text("Producers on Flanger",
                       style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold,
                       letterSpacing: 0.4,
                       ),
                       ),
                     ],
                   )
                   ),
                   new ListOfUsers(
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
                
                 new Padding(
                   padding: EdgeInsets.only(top: 50.0, left: 40.0),
                   child: new Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       new Text('Select discussions',
                       style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold,
                       letterSpacing: 0.4,
                       ),
                       ),
                     ],
                   )
                   ),
                   new ListCategorieDiscussion(
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
                 new Padding(
                   padding: EdgeInsets.only(top: 50.0, left: 40.0),
                   child: new Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       new Text('My following',
                       style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold,
                       letterSpacing: 0.4,
                       ),
                       ),
                     ],
                   ),
                  ),
                   new ListFollowing(
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
               ],
             ),
             ),
           ),
            /*new TabBarView(
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
             ]),*/
    );
  }
}