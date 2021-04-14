import 'dart:html';
import 'package:flanger_web_version/inscription/soundCloudLink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;




class UserPhotoPage extends StatefulWidget {

  String currentUser;
  String currentUserEmail;
  String currentUsername;

  UserPhotoPage({Key key,this.currentUser, this.currentUserEmail, this.currentUsername}) : super(key: key);

  @override
  UserPhotoPageState createState() => UserPhotoPageState();
}

class UserPhotoPageState extends State<UserPhotoPage> {

  TextEditingController _usernameTextEditingController = new TextEditingController();
  TextEditingController _soundCloudTextEditingController = new TextEditingController();
  PageController _pageController = new PageController(initialPage: 0);
  File _image;
  String imageName;
  MediaInfo _imageMediaInfo;
  bool _noPhotoSelected = false;
  bool _photoReaded = false;
  var notificationsToken = 'null';
  //Uint8List bytes;





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
            child: new Text('Choose your profile photo.',
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
                new InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () async {
                    if(kIsWeb) {
                      InputElement uploadInput = FileUploadInputElement();
                      uploadInput.accept = '.png,.jpg';
                      uploadInput.click();
                      uploadInput.onChange.listen((event) {
                        final filePhoto = uploadInput.files.first;
                        final reader = FileReader();

                        reader.readAsDataUrl(filePhoto);

                        reader.onLoadEnd.listen((loadEndEvent) async {
                          print('Reader job done');
                          setState(() {
                            _photoReaded = true;
                            _image = filePhoto;
                          });
                        });
                      });
                    } else {
                      print('No ksiweb');
                    }
                  },
                child: new Container(
                  height: MediaQuery.of(context).size.height*0.13,
                  width: MediaQuery.of(context).size.height*0.13,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900],
                    shape: BoxShape.circle,
                  ),
                  child: _photoReaded == true
                  ? new Center(
                    child: new Icon(
                      CupertinoIcons.checkmark,
                      size: 30.0,
                      color: Colors.green,
                    ),
                  ) //new ClipOval(child: new Image.file(_image, fit: BoxFit.cover))
                  : new Container(),
                  ),
                ),
                new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 30.0,
                    ),
                    ),
                  _noPhotoSelected == true 
                  ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Center(
                    child: new Text('Choose a photo before continue.',
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
        if(_image != null) {
        Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
        new SouncCloudLinkPage(
          currentUser: widget.currentUser,
          currentUserEmail: widget.currentUserEmail,
          currentUsername: widget.currentUsername,
          currentUserPhoto: _image,
        )), 
        (route) => false);
        } else {
          setState(() {
            _noPhotoSelected = true;
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
  }