import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubReplyTextEditing extends StatefulWidget {

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

  //CommentatorUser
  String commentatorUID;
  String commentatorUsername;

  //PostVariables
  TextEditingController currentTextEditingController;
  FocusNode currentFocusNode;

  //Comment datas
  int index;
  String postID;
  String commentID;
  int commentTimestamp;
  String subject;
  //
  int likes;
  Map<dynamic, dynamic> likedBy;
  //
  int comments;
  Map<dynamic, dynamic> commentedBy;
  //
  Map<dynamic, dynamic> reactedBy;

  SubReplyTextEditing({
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

  //CommentatorUser
  this.commentatorUID,
  this.commentatorUsername,

  //PostVariables
  this.currentTextEditingController,
  this.currentFocusNode,

  //Comment datas
  this.index,
  this.postID,
  this.commentID,
  this.commentTimestamp,
  this.subject,
  //
  this.likes,
  this.likedBy,
  //
  this.comments,
  this.commentedBy,
  //
  this.reactedBy,
  }) : super(key: key);

  @override
  SubReplyTextEditingState createState() => SubReplyTextEditingState();
}

class SubReplyTextEditingState extends State<SubReplyTextEditing> {
  //PostPhoto case //
  TextEditingController dialogTextEditingController = new TextEditingController();
  FocusNode dialogFocusNode = new FocusNode();
  //////////////////


  bool inPosting = false;
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;

  @override
  void initState() {
    super.initState();
  }
  
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
        color: Color(0xff0d1117),
        border: new Border.all(
          width: 1.0,
          color: Color(0xff21262D),
        ),
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
          prefixIcon: new IconButton(
            icon: _photoUploadInProgress == false
            ? new Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: widget.colorSentButton, size: 20.0)
            : new Container(
              height: 20.0,
              width: 20.0,
              child: new CircularProgressIndicator(backgroundColor: Color(0xff21262D), valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton)),
            ),
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
                    var snapshot = await ref.child('${widget.currentUser}/imagePost/$_timeStampFileURL').putBlob(_imageUploadedToPost);
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
                                      widget.commentedBy[widget.currentUser] = widget.currentUserUsername;
                                      int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                                      Map<dynamic, dynamic> likedBy = {};
                                      FirebaseFirestore.instance
                                        .collection('${widget.channelDiscussion}')
                                        .doc(widget.postID)
                                        .collection('comments')
                                        .doc(widget.commentID)
                                        .collection('replies')
                                        .doc('$_timestampCreation${widget.currentUserUsername}')
                                        .set({
                                          'adminUID': widget.adminUID,
                                          'commentatorUID': widget.commentatorUID,
                                          'replierUID': widget.currentUser,
                                          'replierProfilephoto': widget.currentUserPhoto,
                                          'replierUsername': widget.currentUserUsername,
                                          'content': dialogTextEditingController.value.text,
                                          'postID': widget.postID,
                                          'subject': widget.subject,
                                          'timestamp': _timestampCreation,
                                          'withImage': _fileURLPhotoUploaded != 'null' ? true : false,
                                          'imageURL': _fileURLPhotoUploaded != 'null' ? _fileURLPhotoUploaded : null,
                                          'likedBy': likedBy,
                                          'likes': 0,
                                          'reactedBy': null,
                                        }).whenComplete(() {
                                          dialogTextEditingController.clear();
                                          dialogFocusNode.unfocus();
                                          Navigator.pop(context);
                                          FirebaseFirestore.instance
                                          .collection('${widget.channelDiscussion}')
                                          .doc(widget.postID)
                                          .collection('comments')
                                          .doc(widget.commentID)
                                          .update({
                                            'comments': FieldValue.increment(1),
                                            'commentedBy': widget.commentedBy,
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
                                                'body': 'has replied under this comment 💬',
                                                'currentNotificationsToken': value.toString(),
                                                'lastUserProfilephoto': widget.currentUserPhoto,
                                                'lastUserUID': widget.currentUser,
                                                'lastUserUsername': widget.currentUserUsername,
                                                'postID': widget.postID,
                                                'title': widget.subject,
                                              }).whenComplete(() {
                                                print('Cloud Firestore : notifications updated for $key');
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
                    });
                  });
                });
              } else {
                print('No ksiweb');
              }
            }),
          suffixIcon: 
          new IconButton(
            icon: inPosting == false 
            ? new Icon(CupertinoIcons.arrow_up_circle_fill, color: widget.currentTextEditingController.text.length > 0 ? widget.colorSentButton :  Colors.grey[600], size: 25.0)
            : new Container(height: 20.0, width: 20.0,
            child: new CircularProgressIndicator(backgroundColor: Color(0xff21262D), valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton)),
            ),
            onPressed: () {
              if(widget.currentTextEditingController.text.length > 0) {
              setState(() {
                inPosting = true;
              });
               widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
               widget.commentedBy[widget.currentUser] = widget.currentUserUsername;
               int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
               Map<dynamic, dynamic> likedBy = {};
               FirebaseFirestore.instance
                 .collection('${widget.channelDiscussion}')
                 .doc(widget.postID)
                 .collection('comments')
                 .doc(widget.commentID)
                 .collection('replies')
                 .doc('${_timestampCreation.toString()}${widget.currentUserUsername}')
                 .set({
                 'adminUID': widget.adminUID,
                  'commentatorUID': widget.commentatorUID,
                  'replierUID': widget.currentUser,
                  'replierProfilephoto': widget.currentUserPhoto,
                  'replierUsername': widget.currentUserUsername,
                  'content': widget.currentTextEditingController.value.text,
                  'postID': widget.postID,
                  'subject': widget.subject,
                  'timestamp': _timestampCreation,
                  'withImage': false,
                  'imageURL': null,
                  'likedBy': likedBy,
                  'likes': 0,
                  'reactedBy': widget.reactedBy,
                 }).whenComplete(() {
                   widget.currentTextEditingController.clear();
                   widget.currentFocusNode.unfocus();
                  setState(() {
                    inPosting = false;
                  });
                   FirebaseFirestore.instance
                   .collection('${widget.channelDiscussion}')
                   .doc(widget.postID)
                   .collection('comments')
                   .doc(widget.commentID)
                   .update({
                     'comments': FieldValue.increment(1),
                     'commentedBy': widget.commentedBy,
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
                         'body': 'has replied under this comment 💬',
                         'currentNotificationsToken': value.toString(),
                         'lastUserProfilephoto': widget.currentUserPhoto,
                         'lastUserUID': widget.currentUser,
                         'lastUserUsername': widget.currentUserUsername,
                         'postID': widget.postID,
                         'title': widget.subject,
                       }).whenComplete(() {
                         print('Cloud Firestore : notifications updated for $key');
                       });
                     }
                   });
                   });
                 });
              } else {
                print('TextEditing : Nothing to send');
              }
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