import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/home/liveChat/live_textEditing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiveChat extends StatefulWidget {


  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;



  LiveChat({Key key,
   this.currentUser,
   this.currentUserUsername,
   this.currentUserPhoto,
   this.currentNotificationsToken,
  }) : super(key: key);


  @override
  LiveChatState createState() => LiveChatState();
}

class LiveChatState extends State<LiveChat> {

  ScrollController _messageListViewController = new ScrollController();
  String answerToMessageID = 'null';
  String answerToUsername = 'null';
  String answerToBody = 'null';


  Stream<dynamic> _fetchMessages;
  Stream<dynamic> fetchMessages() {
    return FirebaseFirestore.instance
      .collection('generalDiscussion')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }

  @override
  void initState() {
    _fetchMessages = fetchMessages();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff0d1117),
      body: new Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width*0.75,
         constraints: new BoxConstraints(
           minWidth: 600.0,
           minHeight: 500.0,
         ),
        color: Color(0xff0d1117),
        child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*0.75,
                child: new StreamBuilder(
                  stream: _fetchMessages,
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.hasError || !snapshot.hasData) {
                      return new Center(
                        child: new Container(
                          height: 20.0,
                          width: 20.0,
                          child: new CupertinoActivityIndicator(
                            radius: 8.0,
                            animating: true,
                          )
                        ),
                      );
                    }
                    return new Container(
                    child: new ListView.builder(
                      padding: EdgeInsets.only(bottom: 80.0),
                      controller: _messageListViewController,
                      scrollDirection: Axis.vertical,
                      reverse: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int messageIndex) {
                        var ds = snapshot.data.docs[messageIndex];
                        return new Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 5.0),
                         child: new Container(
                            color: answerToMessageID == ds['timestamp'].toString()+ds['userID'] ? Colors.purple.withOpacity(0.3) : Colors.transparent,
                            width: MediaQuery.of(context).size.width*0.75,
                            constraints: new BoxConstraints(
                              minHeight: 40.0,
                            ),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                           new ListTile(
                              leading: new Container(
                                      height: 35.0,
                                      width: 35.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[900],
                                      ),
                                      child: new ClipOval(
                                        child: ds['profilePhoto'] != null
                                        ? new Image.network(ds['profilePhoto'], fit: BoxFit.cover)
                                        : new Container(),
                                      ),
                                    ),
                              title: new Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: new RichText(
                                  text: new TextSpan(
                                    text: ds['username'] != null
                                    ? ds['username'] + '  ' 
                                    : 'Unknown ',
                                    style: new TextStyle(color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0), fontSize: 13.0, fontWeight: FontWeight.bold),
                                    children: [
                                      new TextSpan(
                                        text: ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 1
                                          ? 'few sec ago'
                                          : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 60
                                          ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes.toString() + ' min ago'
                                          : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes >= 60
                                          && ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours <= 24
                                          ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours.toString() + ' hours ago'
                                          : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours >= 24
                                          ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inDays.toString() + ' days ago'
                                          : '',
                                        style: new TextStyle(color: Colors.grey, fontSize: 11.0, fontWeight: FontWeight.normal),
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                            subtitle: new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: new Text(
                                    ds['body'] != null
                                    ? ds['body']
                                    : 'This message contains nothing. Strange.',
                                  style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal,
                                  wordSpacing: 0.5,
                                  letterSpacing: 0.5,
                                  height: 1.5,
                                  ),
                                  ),
                                ),
                                trailing: new Tooltip(
                                  message: 'Reply to ' + ds['username'],
                                child: new IconButton(
                                  icon: new Icon(CupertinoIcons.arrow_down_left_circle, color: Colors.grey, size: 25.0), 
                                  onPressed: () {
                                    setState(() {
                                      answerToMessageID = ds['timestamp'].toString()+ds['userID'];
                                      answerToUsername = ds['username'];
                                      answerToBody = ds['body'];
                                    });
                                  },
                                 ),
                              ),
                            ),
                            ds['replyToSomeone'] == true
                            ? new Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 70.0, right: 50),
                              child: new Container(
                              decoration: new BoxDecoration(
                                color: Color(0xff0d1117),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Color(0xff21262D),
                                ),
                                borderRadius: new BorderRadius.circular(5.0),
                                boxShadow: [
                                  new BoxShadow(
                                    color: ds['answerToUsername'] == widget.currentUserUsername ? Colors.cyanAccent : Colors.transparent,
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                                child: new Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: new ListTile(
                                    title: new Text('Reply to ' + ds['answerToUsername'],
                                    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: new Padding(
                                     padding: EdgeInsets.only(top: 10.0),
                                     child: new Text(ds['answerToBody'],
                                        style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal,
                                        wordSpacing: 0.5,
                                        letterSpacing: 0.5,
                                        height: 1.5,
                                        ),
                                        ),
                                    ),
                                  ),
                                  ),
                                /*child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        new Text('Reply to ' + ds['answerToUsername'],
                                        style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                   new Padding(
                                     padding: EdgeInsets.only(top: 10.0),
                                   child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        new Text(ds['answerToBody'],
                                        style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                   ),
                                  ],
                                )*/
                              ),
                            )
                            : new Container(),
                            ds['imageURL'] != null
                             ?  new Padding(
                                 padding: EdgeInsets.only(top: 10.0, left: 70.0, right: 50),
                               child: new Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   new Container(
                                     height: 300.0,
                                     decoration: new BoxDecoration(
                                       color: Colors.grey[900],
                                       borderRadius: new BorderRadius.circular(5.0),
                                     ),
                                     child: new ClipRRect(
                                       borderRadius: new BorderRadius.circular(5.0),
                                       child: ds['imageURL'] != null
                                       ? new Tooltip(
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
                                                       constraints: new BoxConstraints(
                                                         maxHeight: MediaQuery.of(context).size.height*0.80,
                                                         maxWidth: MediaQuery.of(context).size.width*0.80,
                                                       ),
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
                                           )
                                           : new Container(
                                             height: 300.0,
                                             width: 380.0,
                                           child: new Center(
                                             child: new Text('Oops, not available',
                                             style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                                         ),
                                        ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                               )
                              : new Container(),
                              ],
                            )
                          ),
                        );
                      }),
                    );
                  })
                ),
              ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  answerToMessageID != 'null' && answerToUsername != 'null' && answerToBody != 'null' 
                  ? new Container(
                    color: Colors.grey[900],
                    height: 40.0,
                    width: MediaQuery.of(context).size.width*0.75,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: new IconButton(
                            icon: new Icon(Icons.cancel, color: Colors.grey, size: 20.0), 
                            onPressed: () {
                              setState(() {
                                answerToMessageID = 'null';
                                answerToUsername = 'null';
                                answerToBody = 'null';
                              });
                            }),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: new RichText(
                            text: new TextSpan(
                              text: 'Reply to $answerToUsername ',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                              children: [
                                new TextSpan(
                                  text: ' (highlighted message)',
                                  style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : new Container(),
                  new Container(
                    color: Colors.grey[900].withOpacity(0.5),
                    constraints: new BoxConstraints(
                      minHeight: 50.0,
                    ),
                    child: new Padding(
                      padding: EdgeInsets.all(10.0),
                    child: new LiveTextEditing(
                      currentUser: widget.currentUser,
                      currentUserUsername: widget.currentUserUsername ,
                      currentUserPhoto: widget.currentUserPhoto ,
                      currentNotificationsToken: widget.currentNotificationsToken,
                      answerToMessageID: answerToMessageID,
                      answerToUsername: answerToUsername,
                      answerToBody: answerToBody,
                    ),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}