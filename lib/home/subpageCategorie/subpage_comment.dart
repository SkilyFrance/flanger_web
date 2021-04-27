import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class SubPageComment extends StatefulWidget {

  //ChannelDiscussion
  String channelDiscussion;
  Color colorSentButton;

  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;

  //Post ID
  String postID;

  SubPageComment({
    Key key,
    this.channelDiscussion,
    this.colorSentButton,
    this.currentUser,
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentNotificationsToken,
    this.postID,
    }) : super(key: key);



  @override
  SubPageCommentState createState() => SubPageCommentState();
}

class SubPageCommentState extends State<SubPageComment> {

  ScrollController _commentListViewController = new ScrollController();

  Stream<dynamic> _fetchAllComments;
  Stream<dynamic> fetchAllComments() {
    return FirebaseFirestore.instance
      .collection('${widget.channelDiscussion}')
      .doc('${widget.postID}')
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  @override
  void initState() {
    _fetchAllComments = fetchAllComments();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fetchAllComments,
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasError || !snapshot.hasData) {}
        if(snapshot.connectionState == ConnectionState.waiting) {
          return new Container(
            height: 90.0,
            child: new Center(
              child: new Container(
                height: 30.0,
                width: 30.0,
                child: new Center(
                  child: new CircularProgressIndicator(
                    backgroundColor: Colors.grey[900],
                    valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton),
                  ),
                ),
              ),
            ),
          );
        }
        return new ListView.builder(
          shrinkWrap: true,
          controller: _commentListViewController,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int commentIndex) {
            var ds = snapshot.data.docs[commentIndex];
            TextEditingController replyTextEditing = new TextEditingController();
            FocusNode replyhFocusNode = new FocusNode();
            return new Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Container(
                child: new Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   new Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                   new Container(
                     height: 40.0,
                     width: 40.0,
                     decoration: new BoxDecoration(
                       color: Colors.grey[900],
                       shape: BoxShape.circle,
                     ),
                     child: new ClipOval(
                       child: ds['commentatorProfilephoto']  != null
                     ? new Image.network(ds['commentatorProfilephoto'], fit: BoxFit.cover)
                     : new Container(),
                     ),
                   ),
                     ],
                   ),
                   new Padding(
                     padding: EdgeInsets.only(left: 15.0, top: 5.0),
                     child: new Container(
                       decoration: new BoxDecoration(
                         color: Colors.grey[850],
                         borderRadius: new BorderRadius.circular(10.0),
                       ),
                       child: new Padding(
                         padding: EdgeInsets.all(13.0),
                       child: new Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            new Text(ds['commentatorUsername'] != null
                            ? ds['commentatorUsername']
                            : 'Username',
                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                new Padding(
                                  padding: EdgeInsets.only(left: 0.0),
                                  child: new Text('Lvl',
                                  style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: new Text('Ninja',
                                  style: new TextStyle(color: Colors.deepPurpleAccent, fontSize: 13.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ],
                              ),
                              ),
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Padding(
                                padding: EdgeInsets.only(top: 15.0),
                              child: new Text(
                                ds['content'] != null
                                ? ds['content']
                                : '',
                                textAlign: TextAlign.left,
                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal,
                                wordSpacing: 0.5,
                                letterSpacing: 0.5,
                              ),
                            ),
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    color: widget.colorSentButton.withOpacity(0.2),
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                    new LikeButton(
                                      size: 28.0,
                                      circleColor:
                                          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                      bubblesColor: new BubblesColor(
                                        dotPrimaryColor: Colors.cyanAccent,
                                        dotSecondaryColor: Colors.purpleAccent
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          CupertinoIcons.heart_circle_fill,
                                          color: isLiked ? Colors.cyanAccent : Colors.grey,
                                          size: 28.0,
                                        );
                                      },
                                    ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: new RichText(
                                      text: new TextSpan(
                                        text: 'Liked by ',
                                        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal),
                                        children: [
                                          new TextSpan(
                                            text: 'Ozone, Nickia & 10 others.',
                                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                    ],
                                  ),
                                ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 15.0, left: 10.0),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Center(
                                        child: new InkWell(
                                          onTap: () {}, 
                                          child: new Text('11 replies',
                                          style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 15.0, left: 10.0),
                                  child: new Text(
                                    ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 1
                                    ? 'few sec ago'
                                    : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 60
                                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes.toString() + ' min ago'
                                    : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes >= 60
                                    && ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours <= 24
                                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours.toString() + ' hours ago'
                                    : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours >= 24
                                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inDays.toString() + ' days ago'
                                    : '',
                                    style:  new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal,
                                    height: 1.1,
                                    ),
                                  ),
                                ),
                            ],
                            ),
                         ],
                       ),
                       ),
                     ),
                     ),
                  ],
                ),
                ),
                ),
            );
          });
      });
  }
}