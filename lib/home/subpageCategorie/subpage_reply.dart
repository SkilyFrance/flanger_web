import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class SubReply extends StatefulWidget {

  //ChannelDiscussion
  String channelDiscussion;
  Color colorSentButton;

  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;

  //variablesPath
  String postID;
  String commentID;


  SubReply({
    Key key,
    this.channelDiscussion,
    this.colorSentButton,
    this.currentUser,
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentNotificationsToken,
    this.postID,
    this.commentID,
    }) : super(key: key);
  


  @override
  SubReplyState createState() => SubReplyState();
}

class SubReplyState extends State<SubReply> {

  ScrollController _replyListViewController = new ScrollController();

  Stream<dynamic> _fetchAllReplies;
  Stream<dynamic> fetchAllReplies() {
    return FirebaseFirestore.instance
      .collection('${widget.channelDiscussion}')
      .doc('${widget.postID}')
      .collection('comments')
      .doc(widget.commentID)
      .collection('replies')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  Future<bool> onLikeButtonTapped(bool isLiked, Map<dynamic, dynamic> likedBy, String replyID) async {
    if(likedBy.containsKey(widget.currentUser) == false) {
      setState(() {
        likedBy[widget.currentUser] = widget.currentUserUsername;
      });
      FirebaseFirestore.instance
        .collection(widget.channelDiscussion)
        .doc(widget.postID)
        .collection('comments')
        .doc(widget.commentID)
        .collection('replies')
        .doc(replyID)
        .update({
          'likes': FieldValue.increment(1),
          'likedBy': likedBy,
        }).whenComplete(() => print('Cloud firestore : Like +1'));
        return !isLiked;
    } else {
      setState(() {
        likedBy.remove(widget.currentUser);
      });
      FirebaseFirestore.instance
        .collection(widget.channelDiscussion)
        .doc(widget.postID)
        .collection('comments')
        .doc(widget.commentID)
        .collection('replies')
        .doc(replyID)
        .update({
          'likes': FieldValue.increment(-1),
          'likedBy': likedBy,
        }).whenComplete(() => print('Cloud firestore : Like -1'));
      return !isLiked;
    }
  }

  @override
  void initState() {
    _fetchAllReplies = fetchAllReplies();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fetchAllReplies,
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
                    backgroundColor: Color(0xff21262D),
                    valueColor: new AlwaysStoppedAnimation<Color>(widget.colorSentButton),
                  ),
                ),
              ),
            ),
          );
        }
        return new ListView.builder(
          shrinkWrap: true,
          controller: _replyListViewController,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int commentIndex) {
            var ds = snapshot.data.docs[commentIndex];
            return new Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Color(0xff0d1117),
                  borderRadius: new BorderRadius.circular(10.0),
                  border: new Border.all(
                    width: 1.0,
                    color: Color(0xff21262D),
                  ),
                ),
                child: new Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 5.0),
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
                       color: Color(0xff21262D),
                       shape: BoxShape.circle,
                     ),
                     child: new ClipOval(
                       child: ds['replierProfilephoto']  != null
                     ? new Image.network(ds['replierProfilephoto'], fit: BoxFit.cover)
                     : new Container(),
                     ),
                   ),
                     ],
                   ),
                   new Padding(
                     padding: EdgeInsets.only(left: 15.0, top: 5.0),
                     child: new Container(
                       color: Color(0xff0d1117),
                       child: new Padding(
                         padding: EdgeInsets.all(15.0),
                       child: new Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            new Text(ds['replierUsername'] != null
                            ? ds['replierUsername']
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
                          ds['withImage'] == true && ds['imageURL'] != null
                         ? new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: new Center(
                                child: new Tooltip(
                                  message: 'Click to zoom',
                                  textStyle: new TextStyle(color: Colors.white, fontSize: 12.0),
                                child: new InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context) {
                                        return new AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          title: new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius: new BorderRadius.circular(5.0),
                                            ),
                                            child: new ClipRRect(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              child: new Image.network(ds['imageURL'], fit: BoxFit.cover),
                                            ),
                                          ),
                                        );
                                      });
                                  },
                                child: new Container(
                                  height: 300.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(5.0),
                                  ),
                                  child: new ClipRRect(
                                    borderRadius: new BorderRadius.circular(5.0),
                                  child: new Image.network(ds['imageURL'], fit: BoxFit.cover),
                                  ),
                                ),
                                ),
                                ),
                                ),
                              ),
                            ],
                          )
                          : new Container(),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                child: new Container(
                                decoration: new BoxDecoration(
                                  color: Color(0xff0d1117),
                                  borderRadius: new BorderRadius.circular(30.0),
                                  border: new Border.all(
                                    width: 1.0,
                                    color: Color(0xff21262D),
                                  ),
                                ),
                                  padding: EdgeInsets.all(8.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                    new LikeButton(
                                      onTap: (isLiked) {
                                       return onLikeButtonTapped(
                                         isLiked,
                                         ds['likedBy'],
                                         ds['timestamp'].toString()+ds['replierUsername'],
                                       );
                                      },
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
                                          color: ds['likedBy'] != null && ds['likedBy'].containsKey(widget.currentUser) == true ? Colors.cyanAccent : Colors.grey,
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
                                            text: ds['likedBy'] != null && ds['likedBy'].length < 3
                                            ? ds['likedBy'].values.toList().join(', ').toString()
                                            : ds['likedBy'] != null && ds['likedBy'].length >= 3 && ds['likedBy'].containsKey(widget.currentUser) == true
                                            ? ds['likedBy'][widget.currentUser].toString() 
                                            + ', ' + ds['likedBy'].values.elementAt(1).toString() 
                                            + ', ' + (ds['likedBy'].length-2).toString() 
                                            + ' others'
                                            : ds['likedBy'] != null && ds['likedBy'].length >= 3 && ds['likedBy'].containsKey(widget.currentUser) == false
                                            ? ds['likedBy'].values.elementAt(0).toString() 
                                            + ', ' + ds['likedBy'].values.elementAt(1).toString() 
                                            + ', ' + (ds['likedBy'].length-2).toString() 
                                            + ' others'
                                            : 'nobody yet.',
                                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
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