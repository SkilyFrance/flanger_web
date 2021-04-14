import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flanger_web_version/commentContainer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../requestList.dart';


class NotificationsDetails extends StatefulWidget {

  //CurrentUser datas
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentAboutMe;
  String currentSoundCloud;
  String currentSpotify;
  String currentInstagram;
  String currentYoutube;
  String currentTwitter;
  String currentTwitch;
  String currentMixcloud;
  String currentNotificationsToken;
  AsyncSnapshot<dynamic> snapshot;






  NotificationsDetails({
    Key key,
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.currentAboutMe,
    this.currentSoundCloud,
    this.currentSpotify,
    this.currentInstagram,
    this.currentYoutube,
    this.currentTwitter,
    this.currentTwitch,
    this.currentMixcloud,
    this.currentNotificationsToken,
    this.snapshot,
    }) : super(key: key);


  @override
  NotificationsDetailsState createState() => NotificationsDetailsState();
}

class NotificationsDetailsState extends State<NotificationsDetails> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  TextEditingController _postCommentEditingController = new TextEditingController();
  FocusNode _postCommentFocusNode = new FocusNode();
  bool _uploadInProgress = false;

  /*Stream<dynamic> _fetchPostsDatas;
  Stream<dynamic> fetchPostsDatas() {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(widget.postID)
      .snapshots();
  }*/

  final postSaved = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This post has been saved 🌩️',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

    final postAlreadySaved = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This post has been already saved 🌩️',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));


  @override
  void initState() {
   // _fetchPostsDatas = fetchPostsDatas();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Container(
      child: new Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: new Container(
          constraints: new BoxConstraints(
            minWidth: 500.0,
            maxWidth: 850.0
          ),
        child: new Container(
                width: MediaQuery.of(context).size.width,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    borderRadius: new BorderRadius.circular(10.0),
                    border: new Border.all(
                      width: 1.0,
                      color: Colors.transparent
                    ),
                  ),
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          new Container(
                            child: new Container(
                              height: 12.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                color: 
                                widget.snapshot.data['typeOfPost'] == 'issue' 
                                ? Color(0xff7360FC)
                                : widget.snapshot.data['typeOfPost'] == 'tip'
                                ? Color(0xff62DDF9)
                                : widget.snapshot.data['typeOfPost'] == 'project'
                                ? Color(0xffBF88FF)
                                : Color(0xff62DDF9),
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          //adminProfilephoto
                          new ListTile(
                          contentPadding: EdgeInsets.all(20.0),
                            leading: new InkWell(
                              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      backgroundColor: Color(0xff121212),
                      title: new FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(widget.snapshot.data['adminUID']).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if(snapshot.hasError || !snapshot.hasData) {
                            return new Container(
                              height: 300.0,
                              width: 300.0,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Text('',
                                  style: new TextStyle(color: Colors.grey[600], fontSize: 17.0, fontWeight: FontWeight.normal),
                                  ),
                                  new CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent)
                                  ),
                                ],
                              ),
                            );
                          }
                          return new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Center(
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900], 
                                  shape: BoxShape.circle,
                                ),
                                child: widget.snapshot.data['adminProfilephoto'] != null
                                ? new ClipOval(
                                  child: new Image.network(widget.snapshot.data['adminProfilephoto'], fit: BoxFit.cover),
                                )
                                : new Container(),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Center(
                                child: new Text(
                                  widget.snapshot.data['adminUsername'] != null
                                  ? widget.snapshot.data['adminUsername']
                                  : 'Username',
                                style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)
                                ),
                              ),
                              ),
                              snapshot.data['aboutMe'] != 'null' && snapshot.data['aboutMe'] != null
                              ? new Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: new Container(
                                  width: 350.0,
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Center(
                                        child: new Text('About me',
                                        style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: new Text(snapshot.data['aboutMe'],
                                        textAlign: TextAlign.justify,
                                        style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal,
                                        wordSpacing: 1.0,
                                        letterSpacing: 1.0,
                                        height: 1.0,
                                        ),
                                        ),
                                        ),
                                    ],
                                  )
                                ),
                              )
                              : new Container(),
                       new Padding(
                         padding: EdgeInsets.only(top: 30.0),
                       child: new Container(
                          height: 40.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              snapshot.data['soundCloud'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['soundCloud'])) {
                                  await launch(snapshot.data['soundCloud']);
                                } else {
                                  print(snapshot.data['soundCloud'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(2.0),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/soundCloud.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),
                              snapshot.data['spotify'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['spotify'])) {
                                  await launch(snapshot.data['spotify']);
                                } else {
                                  print(snapshot.data['spotify'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 45.0,
                                  width: 45.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(2.0),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/spotify.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),
                            
                              snapshot.data['instagram'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['instagram'])) {
                                  await launch(snapshot.data['instagram']);
                                } else {
                                  print(snapshot.data['instagram'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(2.0),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/instagram.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),
                            
                              snapshot.data['youtube'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['youtube'])) {
                                  await launch(snapshot.data['youtube']);
                                } else {
                                  print(snapshot.data['youtube'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(2.0),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/youtube.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),
                            
                              snapshot.data['twitter'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['twitter'])) {
                                  await launch(snapshot.data['twitter']);
                                } else {
                                  print(snapshot.data['twitter'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(1.5),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/twitter.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),

                              snapshot.data['twitch'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['twitch'])) {
                                  await launch(snapshot.data['twitch']);
                                } else {
                                  print(snapshot.data['twitch'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(2.0),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/twitch.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),
                            
                             snapshot.data['mixcloud'] != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(snapshot.data['mixcloud'])) {
                                  await launch(snapshot.data['mixcloud']);
                                } else {
                                  print(snapshot.data['mixcloud'] + ' error to launch');
                                }
                                },
                              child: new Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Padding(
                                    padding: EdgeInsets.all(0.5),
                                  child: new ClipOval(
                                    child: new Image.asset('web/icons/mixcloud.png', fit: BoxFit.cover)),
                                )))
                              : new Container(),

                            ],
                          )
                        ),
                       ),
                        ],
                        );

                        })
                    ),
                  );
                              },
                              child: new Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: new BoxDecoration(
                                color: Colors.grey[600],
                                shape: BoxShape.circle,
                              ),
                              child: widget.snapshot.data['adminProfilephoto'] != null
                              ? new ClipOval(
                                child: new Image.network(widget.snapshot.data['adminProfilephoto'], fit: BoxFit.cover),
                              )
                              : new Container()
                            )),
                            title: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            new RichText(
                            textAlign: TextAlign.justify,
                            text: new TextSpan(
                              text: widget.snapshot.data['adminUsername'] != null
                              ? widget.snapshot.data['adminUsername'] + ' -  '
                              : 'Unknown' + ' -  ',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                              height: 1.1,
                              ),
                              children: [
                                new TextSpan(
                                  text: widget.snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inMinutes < 1
                                  ? 'few sec ago'
                                  : widget.snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inMinutes < 60
                                  ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inMinutes.toString() + ' min ago'
                                  : widget.snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inMinutes >= 60
                                  && widget.snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inHours <= 24
                                  ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inHours.toString() + ' hours ago'
                                  : widget.snapshot.data['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inHours >= 24
                                  ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.snapshot.data['timestamp'])).inDays.toString() + ' days ago'
                                  : '',
                                  style:  new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal,
                                  height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                              ],
                            ),
                              new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                child: new Text(widget.snapshot.data['subject'] != null
                                ? widget.snapshot.data['subject']
                                : '(error on this title)',
                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                                height: 1.1,
                                ),
                                )),
                              ],
                              ),
                              ],
                            ),
                           subtitle: new Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: widget.snapshot.data['body'] != null
                            ? new Linkify(
                                onOpen: (urlToOpen) async {
                                  if(await canLaunch(urlToOpen.url)) {
                                    await launch(urlToOpen.url);
                                  } else {
                                    print(urlToOpen.url + ' error to launch');
                                  }
                                },
                                text: widget.snapshot.data['body'],
                                textAlign: TextAlign.justify,
                                  style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  letterSpacing: 1.1,
                                  ),
                                )
                            : new Container(),
                          ),
                            trailing: new Material(
                            color: Colors.transparent,
                            child: new PopupMenuButton(
                              child: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0),
                              color: Colors.grey[400],
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)
                              ),
                              onSelected: (selectedValue) {
                              if(widget.snapshot.data['savedBy'].contains(widget.currentUser)) {
                                ScaffoldMessenger.of(context).showSnackBar(postAlreadySaved);
                              } else {
                              FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.snapshot.data['postID'])
                                .update({
                                  'savedBy': FieldValue.arrayUnion([widget.currentUser]),
                                }).whenComplete(() {
                                  ScaffoldMessenger.of(context).showSnackBar(postSaved);
                                });
                              }
                              },
                              itemBuilder: (BuildContext ctx) => [
                                new PopupMenuItem(
                                  child: new Row(
                                    children: [
                                      new Text('Save'),
                                      new Padding(padding: EdgeInsets.only(left: 5.0),
                                      child: new Icon(CupertinoIcons.cloud_download))]
                                      ), value: '1'),]
                            ),
                          )
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                          new Container(
                            height: 30.0,
                            width: 250.0,
                            color: Colors.transparent,
                            child: new Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new InkWell(
                                  onTap: () {
                                  if(widget.snapshot.data['likedBy'].contains(widget.currentUser)) {
                                  deletelikeRequest(
                                    widget.snapshot.data['postID'], 
                                    widget.snapshot.data['likes'], 
                                    widget.currentUser, 
                                    widget.snapshot.data['likedBy']);
                                  } else {
                                  likeRequest(
                                  widget.snapshot.data['postID'], 
                                  widget.snapshot.data['likes'],
                                  widget.snapshot.data['subject'], 
                                  widget.currentUser, 
                                  widget.currentUserUsername,
                                  widget.snapshot.data['likedBy'],
                                  widget.snapshot.data['adminUID'],
                                  widget.snapshot.data['adminNotificationsToken'],
                                  widget.currentUserPhoto);
                                  }
                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: widget.snapshot.data['likedBy'].contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('👍',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        widget.snapshot.data['likes'] != null
                                        ? widget.snapshot.data['likes'].toString()
                                        : ' ',
                                        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                                new InkWell(
                                  onTap: () {
                                  if(widget.snapshot.data['firedBy'].contains(widget.currentUser)) {
                                    deleteFireRequest(
                                      widget.snapshot.data['postID'], 
                                      widget.snapshot.data['fires'], 
                                      widget.currentUser, 
                                      widget.snapshot.data['firedBy']);
                                  } else {
                                    fireRequest(
                                      widget.snapshot.data['postID'], 
                                      widget.snapshot.data['fires'], 
                                      widget.snapshot.data['subject'], 
                                      widget.currentUser, 
                                      widget.currentUserUsername, 
                                      widget.snapshot.data['firedBy'], 
                                      widget.snapshot.data['adminUID'], 
                                      widget.snapshot.data['adminNotificationsToken'], 
                                      widget.currentUserPhoto);
                                  }
                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: widget.snapshot.data['firedBy'].contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('🔥',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        widget.snapshot.data['fires'] != null
                                        ? widget.snapshot.data['likes'].toString()
                                        : ' ',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                                new InkWell(
                                  onTap: () {
                                if(widget.snapshot.data['rocketedBy'].contains(widget.currentUser)) {
                                  deleteRocketRequest(
                                    widget.snapshot.data['postID'], 
                                    widget.snapshot.data['rockets'], 
                                    widget.currentUser, 
                                    widget.snapshot.data['rocketedBy']);
                                } else {
                                  rocketRequest(
                                    widget.snapshot.data['postID'], 
                                    widget.snapshot.data['rockets'], 
                                    widget.snapshot.data['subject'], 
                                    widget.currentUser, 
                                    widget.currentUserUsername, 
                                    widget.snapshot.data['rocketedBy'], 
                                    widget.snapshot.data['adminUID'], 
                                    widget.snapshot.data['adminNotificationsToken'], 
                                    widget.currentUserPhoto);
                                }
                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: widget.snapshot.data['rocketedBy'].contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('🚀',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        widget.snapshot.data['rockets'] != null
                                        ? widget.snapshot.data['rockets'].toString()
                                        : ' ',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
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
                            padding: EdgeInsets.only(left: 20.0),
                            child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('💬',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        widget.snapshot.data['comments'] != null
                                        ? widget.snapshot.data['comments'].toString()
                                        : ' ',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                            ],
                            ),
                          ),
                          //TextEditingController
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
                            child: new Container(
                              constraints: new BoxConstraints(
                                minHeight: 50.0,
                                maxHeight: 150.0
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: 
                              _uploadInProgress == false
                             ?  new TextField(
                               focusNode: _postCommentFocusNode,
                                showCursor: true,
                                //textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                style: new TextStyle(color: Colors.white, fontSize: 13.0),
                                keyboardType: TextInputType.multiline,
                                scrollPhysics: new ScrollPhysics(),
                                keyboardAppearance: Brightness.dark,
                                minLines: null,
                                maxLines: null,
                                controller: _postCommentEditingController,
                                cursorColor: Colors.white,
                                obscureText: false,
                                onChanged: (value) {
                                  if(_postCommentEditingController.text.length > 0 && _postCommentEditingController.text.length == 1) {
                                    setState(() {});
                                  } else if (_postCommentEditingController.text.length == 0) {
                                    setState(() {});
                                  }
                                },
                                decoration: new InputDecoration(
                                  suffixIcon: new IconButton(
                                    icon: new Icon(CupertinoIcons.arrow_up_circle_fill, color: _postCommentEditingController.text.length > 0 ? Colors.cyanAccent :  Colors.grey[600], size: 25.0),
                                    onPressed: () {
                                      if(_postCommentEditingController.text.length > 1 && _postCommentEditingController.value.text != '  ') {
                                      setState(() {
                                        _uploadInProgress = true;
                                      });
                                      widget.snapshot.data['reactedBy'][widget.currentUser] = widget.currentNotificationsToken;
                                      int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                                      FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(widget.snapshot.data['postID'])
                                        .collection('comments')
                                        .doc('$_timestampCreation${widget.currentUserUsername}')
                                        .set({
                                          'adminUID': widget.snapshot.data['adminUID'],
                                          'commentatorProfilephoto': widget.currentUserPhoto,
                                          'commentatorSoundCloud': widget.currentSoundCloud,
                                          'commentatorUID': widget.currentUser,
                                          'commentatorUsername': widget.currentUserUsername,
                                          'content': _postCommentEditingController.value.text,
                                          'postID': widget.snapshot.data['postID'],
                                          'subject': widget.snapshot.data['subject'],
                                          'timestamp': _timestampCreation,
                                        }).whenComplete(() {
                                        _postCommentEditingController.clear();
                                        setState((){
                                          _uploadInProgress = false;
                                          });
                                          FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(widget.snapshot.data['postID'])
                                            .update({
                                              'comments': FieldValue.increment(1),
                                              'commentedBy': FieldValue.arrayUnion([widget.currentUser]),
                                              'reactedBy': widget.snapshot.data['reactedBy'],
                                            }).whenComplete(() {
                                              widget.snapshot.data['reactedBy'].forEach((key, value) {
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
                                                    'postID': widget.snapshot.data['postID'],
                                                    'title': widget.snapshot.data['subject'],
                                                  }).whenComplete(() {
                                                    print('Cloud Firestore : notifications updated for $key');
                                                    _postCommentFocusNode.unfocus();
                                                    setState(() {});
                                                  });
                                                }
                                              });
                                            });
                                        });
                                      }
                                    },
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  border: InputBorder.none,
                                  hintText: 'Aa',
                                  hintStyle: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                  ),
                                ),
                              )
                              : new Container(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text('Uploading in progress',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(left: 30.0),
                                      child: new Container(
                                        height: 20.0,
                                        width: 20.0,
                                      child: new CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ),
                          widget.snapshot.data['savedBy'].contains(widget.currentUser)
                          ? new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Icon(
                                CupertinoIcons.cloud_download, color: Colors.grey[600], size: 20.0),
                              new Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 20.0),
                                child: new Text('Post already saved',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          )
                          : new Container(),
                            new Padding(
                              padding: EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                              child: new CommentContainer(
                                currentUser: widget.currentUser,
                                currentUserPhoto: widget.currentUserPhoto,
                                currentUserUsername: widget.currentUserUsername,
                                currentAboutMe: widget.currentAboutMe,
                                currentSoundCloud: widget.currentSoundCloud,
                                currentSpotify: widget.currentSpotify,
                                currentInstagram: widget.currentInstagram,
                                currentYoutube: widget.currentYoutube,
                                currentTwitter: widget.currentTwitter,
                                currentTwitch: widget.currentTwitch,
                                currentMixcloud: widget.currentMixcloud,
                                currentNotificationsToken: widget.currentNotificationsToken,
                                postID: widget.snapshot.data['postID'],
                                reactedBy: widget.snapshot.data['reactedBy'],
                                homeContext: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
              ),
          //}),
      ),
      ),
    );
  }
}