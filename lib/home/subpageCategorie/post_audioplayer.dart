import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../bodyEditing.dart';
import '../../requestList.dart';
import '../../subjectEditing.dart';


class PostAudioPlayer extends StatefulWidget {

  //ChannelDiscussion
  String channelDiscussion;
  Color colorSentButton;

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
  

  PostAudioPlayer({
    Key key,
    this.channelDiscussion,
    this.colorSentButton,
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
  PostAudioPlayerState createState() => PostAudioPlayerState();
}

class PostAudioPlayerState extends State<PostAudioPlayer> {

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

  // FOR IMAGE
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;
  ///////////////////////////////////////

  FocusNode _bodyFocusNode = new FocusNode();
  TextEditingController _bodyTextEditingController = new TextEditingController();
  FocusNode _subjectFocusNode = new FocusNode();
  TextEditingController _subjectTextEditingController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new Center(
            child: new Container(
              child: new Text('Ask for feedback',
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _musicIsUploaded == false
          ? new Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: new Center(
              child: new Text(
                _musicUploadedInProgress == true && _musicIsUploaded == false
                ? 'This may take a few minutes'
                : 'Select a track from desktop',
              style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: _musicUploadedInProgress == true && _musicIsUploaded == false ? FontWeight.normal : FontWeight.bold),
              ),
            ),
          )
          : new Container(),
          new Padding(
            padding: EdgeInsets.only(top: _musicIsUploaded == true ? 0 : 20.0),
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
                      setState(() {
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
                            setState(() {
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
                            setState((){
                              currentBufferingFeedbackPlayer = event;
                            });
                          //  print('currentBufferingFeedbackPlayer = ' + currentBufferingFeedbackPlayer.inMilliseconds.toString());
                          });
                        _feedbackAudioPlayer.positionStream.listen((event) {
                            setState((){
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
                color: Color(0xff0d1117),
                borderRadius: new BorderRadius.circular(10.0),
                border: new Border.all(
                  width: 1.0,
                  color: widget.colorSentButton,
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
                color: Color(0xff21262D),
                borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: _musicUploadedInProgress == true && _musicIsUploaded == false
                  ? new Container(
                    height: 20.0,
                    width: 20.0,
                    child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton),
                  )
                  )
                  : new Container(),
                   /*new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text('Successfully uploaded', 
                      style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(CupertinoIcons.check_mark_circled, color: widget.colorSentButton, size: 20.0),
                      ),
                  ],
                  ),*/
                  
                ),
            ),
            ),
          _musicIsUploaded == true
        ? new Padding(
          padding: EdgeInsets.only(top: 0.0),
        child: new Container(
          height: 150.0,
          decoration: new BoxDecoration(
          color: Color(0xff0d1117),
          borderRadius: new BorderRadius.circular(10.0)
          ),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          new Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: new Center(
              child: new Text('Put forward a particular part ?',
              style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
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
                              trackHeight: 7.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0), 
                              thumbColor: Colors.cyanAccent,
                              //disabledThumbColor: Colors.transparent,
                              //trackShape: RoundedRectSliderTrackShape(),
                              inactiveTrackColor: Color(0xff21262D),
                              activeTrackColor: Colors.cyanAccent.withOpacity(0.2),
                            // disabledInactiveTickMarkColor: Colors.transparent,
                              activeTickMarkColor: Colors.cyanAccent.withOpacity(0.6),
                              inactiveTickMarkColor: Colors.grey[900],
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
                              setState((){
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
                    icon: Icon(CupertinoIcons.minus_circled, color: Colors.cyanAccent.withOpacity(0.5), size: 30.0), 
                    onPressed: () {
                      if(_trackSplitFeedback > 2) {
                        setState((){
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
                    icon: Icon(CupertinoIcons.add_circled, color: Colors.cyanAccent.withOpacity(0.8), size: 30.0), 
                    onPressed: () {
                      if(_trackSplitFeedback <= 9) {
                        setState((){
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
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold),
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
            currentFocusNode: _subjectFocusNode,
            currentTextEditingController: _subjectTextEditingController,
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
                setState(() {
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
                 setState(() {
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
             color: Color(0xff0d1117),
             borderRadius: new BorderRadius.circular(10.0),
             border: new Border.all(
               width: 1.0,
               color: widget.colorSentButton,
             ),
             ),
             child: new Center(
               child: new Text('Add an image', 
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
             color: Color(0xff0d1117),
             borderRadius: new BorderRadius.circular(10.0),
             border: new Border.all(
               width: 1.0,
               color: Colors.transparent,
             ),
             ),
             child: new Center(
               child: new Container(
               height: 20.0,
               width: 20.0,
                 child: new CircularProgressIndicator(
                   valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton),
                 ),
               ),
             ),
           )
           : new Container(
           height: 45.0,
           width: 200.0,
           decoration: new BoxDecoration(
             color: Color(0xff0d1117),
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
                 child: new Icon(CupertinoIcons.check_mark_circled, color: widget.colorSentButton, size: 20.0),
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
            currentFocusNode: _bodyFocusNode,
            currentTextEditingController: _bodyTextEditingController,
        ),
        ),
      ),
      new Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: new InkWell(
          onTap: () {
            if(_bodyTextEditingController.value.text.length > 0 && _subjectTextEditingController.value.text.length > 0) {
              requestPost(
                widget.channelDiscussion, 
                _fileURLPhotoUploaded != 'null' ? true : false, 
                _fileURLPhotoUploaded != 'null' ? _fileURLPhotoUploaded : null, 
                _musicURLuploadedInStorage != null ? true : false, 
                _musicURLuploadedInStorage != null ? _musicURLuploadedInStorage : null, 
                durationFileUploaded.inMilliseconds.toDouble(), 
                _trackSplitFeedback, 
                _dragValueStartFeedback, 
                _dragValueEndFeedback, 
                widget.currentUser, 
                widget.currentUserUsername, 
                widget.currentUserPhoto, 
                widget.currentNotificationsToken, 
                _bodyTextEditingController.value.text, 
                _subjectTextEditingController.value.text, 
                setState, 
                context, 
                _subjectTextEditingController, 
                _bodyTextEditingController);
            }
          },
        child: new Container(
          height: 45.0,
          width: 100.0,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(40.0),
            color: widget.colorSentButton,
           ),
           child: new Center(
             child: new Text('Publish',
             style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
             )
           ),
         ),
        ),
      ),
        ],
      ),
    );
  }
}