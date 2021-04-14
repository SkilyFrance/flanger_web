import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../mainView.dart';




class SouncCloudLinkPage extends StatefulWidget {

  String currentUser;
  String currentUserEmail;
  String currentUsername;
  File currentUserPhoto;

  SouncCloudLinkPage({Key key,
  this.currentUser, 
  this.currentUserEmail,
  this.currentUsername,
  this.currentUserPhoto,
  }) : super(key: key);

  @override
  SouncCloudLinkPageState createState() => SouncCloudLinkPageState();
}

class SouncCloudLinkPageState extends State<SouncCloudLinkPage> {

  TextEditingController _soundCloudTextEditingController = new TextEditingController();
 
  var notificationsToken = 'null';
  bool _profileInCreation = false;
  bool _flagUrl = false;



  @override
  void initState() {
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
      child: _profileInCreation == false
      ? new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
          ),
          new Center(
            child: new Text("Last thing.",
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
            child: new Text('Paste here your SoundCloud link.',
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
                  soundCloudInput(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 30.0,
                    ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: new Text('Has to start by https://soundcloud.com/',
                      style: new TextStyle(color: _flagUrl == true ? Colors.red : Colors.grey[700], fontSize: 13.0, fontWeight: FontWeight.normal)
                      ),
                    ),
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
        )
      : new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
          ),
          new Center(
            child: new Text("Great work.",
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
            child: new Text('Creation in progress.',
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
                  new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                    backgroundColor: Colors.transparent,
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 40.0,
                    ),
                    ),
                    new Center(
                      child: new Text('Redirected automatically.',
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal, fontSize: 15.0,letterSpacing: 2.0,
                      ),
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
        )
        ),
        )
    );

  }

  nextButton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () async {
        if((_soundCloudTextEditingController.value.text.length > 0 && _soundCloudTextEditingController.value.text.startsWith('https://soundcloud.com/')) || _soundCloudTextEditingController.value.text.length == 0) {
        if(kIsWeb) {
        print('Profile in creation');
        setState(() {
          _profileInCreation = true;
        });
        final _storage = firebase_storage.FirebaseStorage.instance;
        var ref = _storage.refFromURL('gs://flanger-39465.appspot.com');
        var snapshot = await ref.child('${widget.currentUser}/profilePhoto.png').putBlob(widget.currentUserPhoto);
        print('Firebase storage : Photo uploaded.');
        var downloadUrl = await snapshot.ref.getDownloadURL().then((filePhotoURL) async {
             FirebaseFirestore.instance
               .collection('users')
               .doc(widget.currentUser)
               .set({
                 'notificationsToken': notificationsToken,
                 'uid': widget.currentUser,
                 'email': widget.currentUserEmail,
                 'username': widget.currentUsername,
                 'aboutMe': 'null',
                 'soundCloud': _soundCloudTextEditingController.value.text.length > 10 ?  _soundCloudTextEditingController.value.text.toString() : 'null',
                 'spotify': 'null',
                 'instagram': 'null',
                 'youtube': 'null',
                 'twitter': 'null',
                 'twitch': 'null',
                 'mixcloud': 'null',
                 'profilePhoto': filePhotoURL,
               }).whenComplete(() {
                //Go to creationProcess
                Navigator.pushAndRemoveUntil(
                context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                new MainViewPage(
                  currentUser: widget.currentUser,
                  currentUserUsername: widget.currentUser,
                  currentUserPhoto: filePhotoURL,
                  notificationsToken: notificationsToken,
                )),
                (route) => false);
            });
            });
            } else {
          print('No web here');
        }
        } else {
          setState(() {
            _flagUrl = true;
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
 

  soundCloudInput() {
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
        controller: _soundCloudTextEditingController,
        cursorColor: Colors.white,
        obscureText: false,
        onChanged: (value) {
         if(_soundCloudTextEditingController.text.length > 0 && _soundCloudTextEditingController.text.length == 1) {
           setState(() {});
         } else if (_soundCloudTextEditingController.text.length == 0) {
           setState(() {});
         }
        },
        decoration: new InputDecoration(
          prefixIcon: Icon(CupertinoIcons.profile_circled, color: Colors.white),
          contentPadding: EdgeInsets.only(left: 20.0),
          border: InputBorder.none,
          hintText: 'https://soundcloud.com/example',
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    );

  }
}