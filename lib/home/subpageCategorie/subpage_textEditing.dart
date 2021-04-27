import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SubPageTextEditing extends StatefulWidget {

  //ChannelDiscussion
  String channelDiscussion;
  Color colorSentButton;

  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;

  //AdminUser
  String adminUID;
  String adminProfilephoto;
  String adminUsername;
  String adminNotificationsToken;

  //PostVariables
  TextEditingController currentTextEditingController;
  FocusNode currentFocusNode;

  //Post datas
  int index;
  String postID;
  int timestamp;
  String subject;
  //
  int likes;
  List<dynamic> likedBy;
  //
  int comments;
  List<dynamic> commentedBy;
  //
  Map<dynamic, dynamic> reactedBy;
  //
  List<dynamic> savedBy;

  SubPageTextEditing({
    Key key,
    //ChannelDiscussion
    this.channelDiscussion,
    this.colorSentButton,

    //CurrentUser
    this.currentUser,
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentNotificationsToken,

    //AdminUser
    this.adminUID,
    this.adminProfilephoto,
    this.adminUsername,
    this.adminNotificationsToken,

    //PostVariables
    this.currentTextEditingController,
    this.currentFocusNode,

    //Post datas
    this.index,
    this.postID,
    this.timestamp,
    this.subject,
    //
    this.likes,
    this.likedBy,
    //
    this.comments,
    this.commentedBy,
    //
    this.reactedBy,
    //
    this.savedBy,
  }) : super(key: key);



  @override
  SubPageTextEditingState createState() => SubPageTextEditingState();
}

class SubPageTextEditingState extends State<SubPageTextEditing> {

  //PostPhoto case //
  TextEditingController dialogTextEditingController = new TextEditingController();
  FocusNode dialogFocusNode = new FocusNode();
  //////////////////


  bool inPosting = false;
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
    padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
    child: new Container(
      constraints: new BoxConstraints(
        minHeight: 30.0,
        maxHeight: 200.0,
      ),
      decoration: new BoxDecoration(
        color: Colors.grey[800],
        borderRadius: new BorderRadius.circular(30.0),
      ),
    child: new TextField(
        focusNode: widget.currentFocusNode,
        showCursor: true,
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
        onChanged: (value) {
          if(widget.currentTextEditingController.text.length > 0 && widget.currentTextEditingController.text.length == 1) {
            setState(() {});
          } else if (widget.currentTextEditingController.text.length == 0) {
            setState(() {});
          }
        },
        decoration: new InputDecoration(
          prefixIcon: _photoUploadInProgress == false
          ? new IconButton(
            icon: new Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: widget.colorSentButton, size: 20.0),
            onPressed: () {
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
                                        child: new Text('Your reply',
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
                                          width: 400.0,
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
                                      if(dialogTextEditingController.text.length > 0) {
                                      widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
                                      int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                                      FirebaseFirestore.instance
                                        .collection('${widget.channelDiscussion}')
                                        .doc(widget.postID)
                                        .collection('comments')
                                        .doc('$_timestampCreation${widget.currentUserUsername}')
                                        .set({
                                          'adminUID': widget.adminUID,
                                          'commentatorProfilephoto': widget.currentUserPhoto,
                                          'commentatorUID': widget.currentUser,
                                          'commentatorUsername': widget.currentUserUsername,
                                          'content': dialogTextEditingController.value.text,
                                          'postID': widget.postID,
                                          'subject': widget.subject,
                                          'timestamp': _timestampCreation,
                                          'withImage': _fileURLPhotoUploaded != 'null' ? true : false,
                                          'imageURL': _fileURLPhotoUploaded != 'null' ? _fileURLPhotoUploaded : null,
                                        }).whenComplete(() {
                                          dialogTextEditingController.clear();
                                          FirebaseFirestore.instance
                                            .collection('${widget.channelDiscussion}')
                                            .doc(widget.postID)
                                            .update({
                                              'comments': FieldValue.increment(1),
                                              'commentedBy': FieldValue.arrayUnion([widget.currentUser]),
                                              'reactedBy': widget.reactedBy,
                                            }).whenComplete(() {
                                              widget.reactedBy.forEach((key, value) {
                                                if(key == widget.currentUser) {
                                                  print('No send notification here cause it is current user.');
                                                } else {
                                                FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(key.toString())
                                                  .collection('notifications')
                                                  .doc(_timestampCreation.toString()+widget.currentUser)
                                                  .set({
                                                    'alreadySeen': false,
                                                    'notificationID': _timestampCreation.toString()+widget.currentUser,
                                                    'body': 'has commented this post 💬',
                                                    'currentNotificationsToken': value.toString(),
                                                    'lastUserProfilephoto': widget.currentUserPhoto,
                                                    'lastUserUID': widget.currentUser,
                                                    'lastUserUsername': widget.currentUserUsername,
                                                    'postID': widget.postID,
                                                    'title': widget.subject,
                                                  }).whenComplete(() {
                                                    print('Cloud Firestore : notifications updated for $key');
                                                    dialogFocusNode.unfocus();
                                                  });
                                                }
                                              });
                                            });
                                        });
                                      } else {
                                        print('TextEditing : Nothing to send');
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
              /*if(kIsWeb) {
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
              }*/
            })
            : new CircularProgressIndicator(backgroundColor: Colors.grey[900], valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton)),
          suffixIcon: new IconButton(
            icon: inPosting == false 
            ? new Icon(CupertinoIcons.arrow_up_circle_fill, color: widget.currentTextEditingController.text.length > 0 ? widget.colorSentButton :  Colors.grey[600], size: 25.0)
            : new Container(height: 30.0, width: 30.0,
            child: new CircularProgressIndicator(backgroundColor: Colors.grey[900], valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton)),
            ),
            onPressed: () {
              if(widget.currentTextEditingController.text.length > 0) {
              setState(() {
                inPosting = true;
              });
               widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
               int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
               FirebaseFirestore.instance
                 .collection('${widget.channelDiscussion}')
                 .doc(widget.postID)
                 .collection('comments')
                 .doc('$_timestampCreation${widget.currentUserUsername}')
                 .set({
                   'adminUID': widget.adminUID,
                   'commentatorProfilephoto': widget.currentUserPhoto,
                   'commentatorUID': widget.currentUser,
                   'commentatorUsername': widget.currentUserUsername,
                   'content': widget.currentTextEditingController.value.text,
                   'postID': widget.postID,
                   'subject': widget.subject,
                   'timestamp': _timestampCreation,
                   'withImage': false,
                   'imageURL': null,
                 }).whenComplete(() {
                  setState(() {
                    inPosting = false;
                  });
                  widget.currentTextEditingController.clear();
                   FirebaseFirestore.instance
                     .collection('${widget.channelDiscussion}')
                     .doc(widget.postID)
                     .update({
                       'comments': FieldValue.increment(1),
                       'commentedBy': FieldValue.arrayUnion([widget.currentUser]),
                       'reactedBy': widget.reactedBy,
                     }).whenComplete(() {
                       widget.reactedBy.forEach((key, value) {
                         if(key == widget.currentUser) {
                           print('No send notification here cause it is current user.');
                         } else {
                         FirebaseFirestore.instance
                           .collection('users')
                           .doc(key.toString())
                           .collection('notifications')
                           .doc(_timestampCreation.toString()+widget.currentUser)
                           .set({
                             'alreadySeen': false,
                             'notificationID': _timestampCreation.toString()+widget.currentUser,
                             'body': 'has commented this post 💬',
                             'currentNotificationsToken': value.toString(),
                             'lastUserProfilephoto': widget.currentUserPhoto,
                             'lastUserUID': widget.currentUser,
                             'lastUserUsername': widget.currentUserUsername,
                             'postID': widget.postID,
                             'title': widget.subject,
                           }).whenComplete(() {
                             print('Cloud Firestore : notifications updated for $key');
                             widget.currentFocusNode.unfocus();
                           });
                         }
                       });
                     });
                 });
              } else {
                print('TextEditing : Nothing to send');
              }
              widget.currentFocusNode.unfocus();
            },
            ),
          contentPadding: EdgeInsets.all(15.0),
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
