import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../bodyEditing.dart';
import '../../requestList.dart';
import '../../subjectEditing.dart';


class PostSimple extends StatefulWidget {

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
  

  PostSimple({
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
  PostSimpleState createState() => PostSimpleState();
}

class PostSimpleState extends State<PostSimple> {

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
              width: MediaQuery.of(context).size.height*0.70,
              child: new Center(
              child: new Text('New post',
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              ),
            ),
        ),
          new Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: new Center(
              child: new Text('About',
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
                  color: widget.colorSentButton
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
        new Padding(
          padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: new InkWell(
            onTap: () {
              if(_bodyTextEditingController.value.text.length > 0 && _subjectTextEditingController.value.text.length > 0) {
              requestPost(
                widget.channelDiscussion, 
                _fileURLPhotoUploaded != 'null' ? true : false, 
                _fileURLPhotoUploaded != 'null' ? _fileURLPhotoUploaded : null, 
                false, 
                null, 
                null, 
                null, 
                null, 
                null, 
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
              } else {
              }
            },
        child: new Container(
          height: 45.0,
          width: 100.0,
          decoration: new BoxDecoration(
            color: widget.colorSentButton,
            borderRadius: new BorderRadius.circular(40.0),
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