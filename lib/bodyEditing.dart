import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyEditingController extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;
  String currentSoundCloud;
  String currentNotificationsToken;
  TextEditingController currentTextEditingController;
  FocusNode currentFocusNode;

  BodyEditingController({
    Key key,
    this.currentUser,
    this.currentUserPhoto,
    this.currentUserUsername,
    this.currentSoundCloud,
    this.currentNotificationsToken,
    this.currentTextEditingController,
    this.currentFocusNode,
    }) : super(key: key);


  @override
  BodyEditingControllerState createState() => BodyEditingControllerState();
}

class BodyEditingControllerState extends State<BodyEditingController> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
    child: new Container(
      height: 200.0,
      decoration: new BoxDecoration(
        color: Colors.grey[900],
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: new TextField(
        focusNode: widget.currentFocusNode,
        showCursor: true,
        //textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 13.0),
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