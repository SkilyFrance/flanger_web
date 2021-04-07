import 'dart:io';

import 'package:flanger_web_version/inscription/userphotoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class UsernamePage extends StatefulWidget {

  String currentUser;
  String currentUserEmail;

  UsernamePage({Key key,this.currentUser, this.currentUserEmail}) : super(key: key);

  @override
  UsernamePageState createState() => UsernamePageState();
}

class UsernamePageState extends State<UsernamePage> {

  TextEditingController _usernameTextEditingController = new TextEditingController();
  TextEditingController _soundCloudTextEditingController = new TextEditingController();
  PageController _pageController = new PageController(initialPage: 0);
  File _image;
  bool _usernameTooShord = false;
  var notificationsToken = 'null';



  @override
  void initState() {
    _usernameTextEditingController = new TextEditingController();
    _soundCloudTextEditingController = new TextEditingController();
    super.initState();
  }


  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: new GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
      child: new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
          ),
          new Center(
            child: new Text("Let's start.",
            style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.04,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 50.0,
            ),
            ),
          new Center(
            child: new Text('Choose your username.',
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal, fontSize: 18.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.02,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 60.0,
            ),
            ),
          new Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height*0.30,
            constraints: new BoxConstraints(
              minWidth: 250.0,
              minHeight: 280.0,
              maxHeight: 400.0
            ),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  usernameInput(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 30.0,
                    ),
                    ),
                  _usernameTooShord == true 
                  ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Center(
                    child: new Text('More than 1 character please.',
                    style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                    ],
                  )
                  : new Container(),
                  nextButton(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                ],
              ),
          ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 120.0,
            ),
            ),
        ],
        ),
        ),
        ),
    );
  }


  nextButton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        if(_usernameTextEditingController.text.length > 1) {
        Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
        new UserPhotoPage(
          currentUser: widget.currentUser,
          currentUserEmail: widget.currentUserEmail,
          currentUsername: _usernameTextEditingController.value.text,
        )), 
        (route) => false);
        } else {
          setState(() {
            _usernameTooShord = true;
          });
        }
      },
    child: new Container(
      constraints: new BoxConstraints(
        minWidth: 250.0,
        maxWidth: 250.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(50.0),
        border: new Border.all(
          color: Colors.purpleAccent,
          width: 1.0,
        ),
      ),
      child: new Center(
        child: new Text('CONTINUE',
        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }


  usernameInput() {
    return new Container(
      constraints: new BoxConstraints(
        minWidth: 350.0,
        maxWidth: 350.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 15.0),
        keyboardType: TextInputType.text,
        scrollPhysics: new ScrollPhysics(),
        keyboardAppearance: Brightness.dark,
        minLines: 1,
        maxLines: 1,
        controller: _usernameTextEditingController,
        cursorColor: Colors.white,
        obscureText: false,
        decoration: new InputDecoration(
          prefixIcon: Icon(CupertinoIcons.profile_circled, color: Colors.white),
          contentPadding: EdgeInsets.only(left: 20.0),
          border: InputBorder.none,
          hintText: 'Email',
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    );

  }
 
}