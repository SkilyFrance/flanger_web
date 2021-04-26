import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubjectEditingController extends StatefulWidget {

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
  TextEditingController currentTextEditingController;
  FocusNode currentFocusNode;

  SubjectEditingController({
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
    this.currentTextEditingController,
    this.currentFocusNode,
    }) : super(key: key);


  @override
  SubjectEditingControllerState createState() => SubjectEditingControllerState();
}

class SubjectEditingControllerState extends State<SubjectEditingController> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
    child: new Container(
      height: 50.0,
      decoration: new BoxDecoration(
        color: Colors.grey[800],
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: new TextField(
        focusNode: widget.currentFocusNode,
        showCursor: true,
        //textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 16.0),
        keyboardType: TextInputType.multiline,
        scrollPhysics: new ScrollPhysics(),
        keyboardAppearance: Brightness.dark,
        minLines: null,
        maxLines: null,
        controller: widget.currentTextEditingController,
        cursorColor: Colors.white,
        obscureText: false,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          border: InputBorder.none,
          hintText: 'Aa',
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    ),
    ),
    );
  }
}