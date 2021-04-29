import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';


class LiveTextEditing extends StatefulWidget {

  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;
  String answerToMessageID;
  String answerToUsername;
  String answerToBody;



  LiveTextEditing({Key key,
   this.currentUser,
   this.currentUserUsername,
   this.currentUserPhoto,
   this.currentNotificationsToken,
   this.answerToMessageID,
   this.answerToUsername,
   this.answerToBody,
  }) : super(key: key);



  @override
  LiveTextEditingState createState() => LiveTextEditingState();
}

class LiveTextEditingState extends State<LiveTextEditing> {

  //PostPhoto case //
  TextEditingController dialogTextEditingController = new TextEditingController();
  FocusNode dialogFocusNode = new FocusNode();

  TextEditingController liveTextEditingController = new TextEditingController();
  FocusNode liveFocusNode = new FocusNode();
  


  bool inPosting = false;
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;
  
  @override
  Widget build(BuildContext context) {
    print('answerToMessageID = ${widget.answerToMessageID}');
    print('answerToUsername = ${widget.answerToUsername}');
    print('answerToBody = ${widget.answerToBody}');
    return new Container(
      child: new Padding(
    padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
    child: new Container(
      constraints: new BoxConstraints(
        minHeight: 30.0,
        maxHeight: 200.0,
      ),
      decoration: new BoxDecoration(
        color: Color(0xff0d1117),
        border: new Border.all(
          width: 1.0,
          color: Color(0xff21262D),
        ),
        borderRadius: new BorderRadius.circular(10.0),
      ),
    child: new TextField(
        focusNode: liveFocusNode,
        showCursor: true,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 16.0),
        keyboardType: TextInputType.multiline,
        scrollPhysics: new ScrollPhysics(),
        keyboardAppearance: Brightness.dark,
        minLines: null,
        maxLines: null,
        controller: liveTextEditingController,
        cursorColor: Colors.white,
        obscureText: false,
        onChanged: (value) {
          if(liveTextEditingController.text.length > 0 && liveTextEditingController.text.length == 1) {
            setState(() {});
          } else if (liveTextEditingController.text.length == 0) {
            setState(() {});
          }
        },
        decoration: new InputDecoration(
          prefixIcon: _photoUploadInProgress == false
          ? new IconButton(
            icon: new Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 25.0),
            onPressed: () {
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
                    var snapshot = await ref.child('${widget.currentUser}/generalDiscussion/$_timeStampFileURL').putBlob(_imageUploadedToPost);
                    print('Firebase storage (real path) : Image uploaded.');
                    var downloadUrl = await snapshot.ref.getDownloadURL().then((fileURL) {
                    setState(() {
                        _fileURLPhotoUploaded = fileURL;
                        _photoUploadInProgress = false;
                      });
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return new StatefulBuilder(
                          builder: (contextDialog, dialogSetState){
                            return new AlertDialog(
                              backgroundColor: Color(0xff212121),
                              title: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    new Center(
                                      child: new Container(
                                        width: MediaQuery.of(context).size.height*0.70,
                                        child: new Center(
                                        child: new Text(widget.answerToUsername != 'null' ? 'Reply to ${widget.answerToUsername}' : 'Send an image',
                                        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                        ),
                                      ),
                                  ),
                                    new Padding(
                                      padding: EdgeInsets.only(top: 30.0),
                                      child: new Center(
                                        child: new Container(
                                          height: 300.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: new BorderRadius.circular(10.0),
                                            ),
                                            child: new ClipRRect(
                                              borderRadius: new BorderRadius.circular(10.0),
                                              child: new Image.network(_fileURLPhotoUploaded, fit: BoxFit.cover),
                                            )
                                        ),
                                      ),
                                  ),
                                  new Container(
                                        child: new Padding(
                                      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 0.0),
                                      child: new Container(
                                        height: 100.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: new BorderRadius.circular(10.0),
                                        ),
                                        child: new TextField(
                                          focusNode: dialogFocusNode,
                                          showCursor: true,
                                          //textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(color: Colors.white, fontSize: 16.0),
                                          keyboardType: TextInputType.multiline,
                                          scrollPhysics: new ScrollPhysics(),
                                          keyboardAppearance: Brightness.dark,
                                          minLines: null,
                                          maxLines: null,
                                          controller: dialogTextEditingController,
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
                                      ),
                                  new Padding(
                                    padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                      int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                                        FirebaseFirestore.instance
                                          .collection('generalDiscussion')
                                          .doc('$_timeStampFileURL${widget.currentUser}')
                                          .set({
                                            'userID': widget.currentUser,
                                            'profilePhoto': widget.currentUserPhoto,
                                            'username': widget.currentUserUsername,
                                            'type': 'image',
                                            'body': dialogTextEditingController.value.text.length > 0 || dialogTextEditingController.value.text != ' ' ? dialogTextEditingController.value.text : null,
                                            'imageURL': _fileURLPhotoUploaded != 'null' ? _fileURLPhotoUploaded : null,
                                            'timestamp': _timeStampFileURL,
                                            'replyToSomeone': widget.answerToMessageID != 'null' ? true : false,
                                            'answerToMessageID': widget.answerToMessageID != 'null' ? widget.answerToMessageID : null,
                                            'answerToUsername': widget.answerToUsername != 'null' ? widget.answerToUsername : null,
                                            'answerToBody': widget.answerToBody != 'null' ? widget.answerToBody : null,
                                          }).whenComplete(() {
                                            print('GeneralDisccusion : message sent');
                                            Navigator.pop(context);
                                            liveTextEditingController.clear();
                                          });
                                      },
                                  child: new Container(
                                    height: 45.0,
                                    width: 100.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.deepPurpleAccent,
                                      borderRadius: new BorderRadius.circular(40.0),
                                    ),
                                    child: new Center(
                                      child: new Text('Send',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                                      )
                                    ),
                                  ),
                                ),
                                ),
                                ],
                              ),
                            );
                          });
                      }).whenComplete(() {
                        setState(() {
                          _fileURLPhotoUploaded = 'null';
                        });
                      });
                    });
                  });
                });
              } else {
                print('No ksiweb');
              }

            }
            )
            : new Container(height: 20.0, width: 20.0,
            child: new CircularProgressIndicator(backgroundColor: Colors.grey[900], valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
            ),
          suffixIcon: new IconButton(
            icon: inPosting == false 
            ? new Icon(CupertinoIcons.arrow_up_circle_fill, color: liveTextEditingController.text.length > 0 ? Colors.cyanAccent :  Colors.grey[600], size: 25.0)
            : new Container(height: 20.0, width: 20.0,
            child: new CircularProgressIndicator(backgroundColor: Colors.grey[900], valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
            ),
            onPressed: () {
              if(liveTextEditingController.text.length > 0) {
                int _timeStampFileURL = DateTime.now().microsecondsSinceEpoch;
                FirebaseFirestore.instance
                  .collection('generalDiscussion')
                  .doc('$_timeStampFileURL${widget.currentUser}')
                  .set({
                    'userID': widget.currentUser,
                    'profilePhoto': widget.currentUserPhoto,
                    'username': widget.currentUserUsername,
                    'type': 'text',
                    'body': liveTextEditingController.value.text,
                    'imageURL': null,
                    'timestamp': _timeStampFileURL,
                    'replyToSomeone': widget.answerToMessageID != 'null' ? true : false,
                    'answerToMessageID': widget.answerToMessageID != 'null' ? widget.answerToMessageID : null,
                    'answerToUsername': widget.answerToUsername != 'null' ? widget.answerToUsername : null,
                    'answerToBody': widget.answerToBody != 'null' ? widget.answerToBody : null,
                  }).whenComplete(() {
                    print('GeneralDisccusion : message sent');
                    liveTextEditingController.clear();
                  });
              } else { }
            },
            ),
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          hintText: 'Say something to community',
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