import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'commentContainer.dart';


class PostContainer extends StatefulWidget {

  bool comesFromHome;

  //CurrentUserDatas
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

  //Post datas
  List<bool> listIsExpanded;
  int index;
  List<TextEditingController> listTextEditingController;
  List<FocusNode> listFocusNodeController;
  String postID;
  String typeOfPost;
  int timestamp;
  String adminUID;
  String subject;
  String body;
  //likes
  int likes;
  List<dynamic> likedBy;
  //fires
  int fires;
  List<dynamic> firedBy;
  //rockets
  int rockets;
  List<dynamic> rocketedBy;
  //comments
  int comments;
  List<dynamic> commentedBy;
  //reactedBy
  Map<dynamic, dynamic> reactedBy;
  //SavedBy
  List<dynamic> savedBy;

  //Admin
  String adminProfilephoto;
  String adminUsername;
  String adminNotificationsToken;

  BuildContext homeContext;

  PostContainer({
    Key key,
    this.comesFromHome,
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
    this.listIsExpanded,
    this.index,
    this.listTextEditingController,
    this.listFocusNodeController,
    this.postID,
    this.typeOfPost,
    this.timestamp,
    this.adminUID,
    this.subject,
    this.body,
    this.likes,
    this.likedBy,
    this.fires,
    this.firedBy,
    this.rockets,
    this.rocketedBy,
    this.comments,
    this.commentedBy,
    this.reactedBy,
    this.savedBy,
    this.adminProfilephoto,
    this.adminUsername,
    this.adminNotificationsToken,
    this.homeContext,
    }) : super(key: key);



  @override
  PostContainerState createState() => PostContainerState();
}

class PostContainerState extends State<PostContainer> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _uploadInProgress = false;

  final postSaved = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This post has been saved 🌩️',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));
  final removeFromSaved = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This post has been removed 🌩️',
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
  Widget build(BuildContext context) {
    super.build(context);
   return new InkWell(
    onTap: () {
      if(widget.listIsExpanded[widget.index] == true) {
        setState(() {
          widget.listIsExpanded[widget.index] = false;
        });
      } else {
        setState(() {
            widget.listIsExpanded[widget.index] = true;
          });
      }
    },
  child: new Container(
    decoration: new BoxDecoration(
      color: Colors.grey[900].withOpacity(0.5),
      borderRadius: new BorderRadius.circular(10.0),
      border: new Border.all(
        width: 1.5,
        color: widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'issue'
        ? Color(0xff7360FC) 
        : widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'tip'
        ? Color(0xff62DDF9)
        : widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'project'
        ? Color(0xffBF88FF)
        : Colors.transparent,
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
                  widget.typeOfPost == 'issue' 
                  ? Color(0xff7360FC)
                  : widget.typeOfPost == 'tip'
                  ? Color(0xff62DDF9)
                  : widget.typeOfPost == 'project'
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
                        future: FirebaseFirestore.instance.collection('users').doc(widget.adminUID).get(),
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
                                child: widget.adminProfilephoto != null
                                ? new ClipOval(
                                  child: new Image.network(widget.adminProfilephoto, fit: BoxFit.cover),
                                )
                                : new Container(),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Center(
                                child: new Text(
                                  widget.adminUsername != null
                                  ? widget.adminUsername
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
                child: widget.adminProfilephoto != null
                ? new ClipOval(
                  child: new Image.network(widget.adminProfilephoto, fit: BoxFit.cover),
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
                text: widget.adminUsername != null
                ? widget.adminUsername + ' -  '
                : 'Unknown' + ' -  ',
                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                height: 1.1,
                ),
                children: [
                  new TextSpan(
                    text:  widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes < 1
                    ? 'few sec ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes < 60
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes.toString() + ' min ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes >= 60
                    && widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours <= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours.toString() + ' hours ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours >= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inDays.toString() + ' days ago'
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
                  child: new Text(widget.subject != null
                  ? widget.subject
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
                  child: widget.body != null
                  ? new Linkify(
                      onOpen: (urlToOpen) async {
                        if(await canLaunch(urlToOpen.url)) {
                          await launch(urlToOpen.url);
                        } else {
                          print(urlToOpen.url + ' error to launch');
                        }
                      },
                      text: widget.body,
                      textAlign: TextAlign.justify,
                        style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                        height: 1.5,
                        letterSpacing: 1.1,
                        ),
                      )
                  : new Container(),
                ),
              trailing: widget.comesFromHome == true
              ? new Material(
                color: Colors.transparent,
                child: new PopupMenuButton(
                  child: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0),
                  color: Colors.grey[400],
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)
                  ),
                  onSelected: (selectedValue) {
                  if(widget.savedBy.contains(widget.currentUser)) {
                    ScaffoldMessenger.of(widget.homeContext).showSnackBar(postAlreadySaved);
                  } else {
                  FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postID)
                    .update({
                      'savedBy': FieldValue.arrayUnion([widget.currentUser]),
                    }).whenComplete(() {
                      ScaffoldMessenger.of(widget.homeContext).showSnackBar(postSaved);
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
              : new Material(
                color: Colors.transparent,
                child: new PopupMenuButton(
                  child: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0),
                  color: Colors.grey[400],
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)
                  ),
                  onSelected: (selectedValue) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext dialoContext, StateSetter dialogSeState){
                                          return new AlertDialog(
                                            backgroundColor: Color(0xff121212),
                                            title: new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                              new Center(
                                                child: new Container(
                                                  child: new Text('Remove from saved post ?',
                                                  style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.only(top: 30.0),
                                                child: new Center(
                                                  child: new Icon(CupertinoIcons.trash, color: Colors.grey[600], size: 30.0),
                                                ),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.only(top: 30.0),
                                                child: new Container(
                                                  height: 38.0,
                                                  width: 220.0,
                                                  color: Colors.transparent,
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      new InkWell(
                                                        onTap: () {
                                                        Navigator.pop(context);
                                                        FirebaseFirestore.instance
                                                          .collection('posts')
                                                          .doc(widget.postID)
                                                          .update({
                                                            'savedBy': FieldValue.arrayRemove([widget.currentUser]),
                                                          }).whenComplete(() {
                                                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(removeFromSaved);
                                                          });
                                                        },
                                                      child: new Container(
                                                        height: 38.0,
                                                        width: 100.0,
                                                        decoration: new BoxDecoration(
                                                          borderRadius: new BorderRadius.circular(5.0),
                                                          color: Colors.transparent,
                                                        ),
                                                        child: new Center(
                                                          child: new Text('Yes, please',
                                                          style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ),
                                                      ),
                                                      new InkWell(
                                                        onTap: () {
                                                          Navigator.pop(dialoContext);
                                                        },
                                                      child: new Container(
                                                        height: 38.0,
                                                        width: 100.0,
                                                        decoration: new BoxDecoration(
                                                          borderRadius: new BorderRadius.circular(5.0),
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                        child: new Center(
                                                          child: new Text('No, thanks',
                                                          style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ),
                                                      ),
                                                    ],
                                                  )
                                                ),
                                              ),
                                              ],
                                            ),
                                          );
                                        });
                                    }
                                );
                  },
                  itemBuilder: (BuildContext ctx) => [
                    new PopupMenuItem(
                      child: new Row(
                        children: [
                          new Text('Remove'),
                          new Padding(padding: EdgeInsets.only(left: 5.0),
                          child: new Icon(CupertinoIcons.cloud_download))]
                          ), value: '1'),]
                ),
              )



              /*new Container(
                height: 30.0,
                width: 80.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: 
                    ds['typeOfPost'] == 'issue'
                    ? new Icon(CupertinoIcons.burst, color: Colors.deepPurpleAccent, size: 20.0)
                    : ds['typeOfPost'] == 'tip'
                    ? new Icon(CupertinoIcons.lightbulb, color: Colors.purpleAccent, size: 20.0)
                    : new Icon(CupertinoIcons.rocket, color: Colors.cyanAccent, size: 20.0)
                    ),
                  new Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  child: new Text(
                    ds['typeOfPost'] == 'issue' 
                    ? 'Issue'
                    : ds['typeOfPost'] == 'tip'
                    ? 'Tip'
                    : 'Project',
                    style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal))),
                ],
              ),
              ),*/
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
                      if(widget.likedBy.contains(widget.currentUser)) {
                      deletelikeRequest(
                        widget.postID, 
                        widget.likes, 
                        widget.currentUser, 
                        widget.likedBy);
                      } else {
                      likeRequest(
                      widget.postID, 
                      widget.likes,
                      widget.subject, 
                      widget.currentUser, 
                      widget.currentUserUsername,
                      widget.likedBy,
                      widget.adminUID,
                      widget.adminNotificationsToken,
                      widget.currentUserPhoto);
                      }
                    },
                  child: new Container(
                    height: 30.0,
                    width: 55.0,
                    decoration: new BoxDecoration(
                      color: widget.likedBy.contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                      borderRadius: new BorderRadius.circular(3.0)
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text('👍',
                        style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          widget.likes != null
                          ? widget.likes.toString()
                          : ' ',
                          style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ),
                  new InkWell(
                    onTap: () {
                      if(widget.firedBy.contains(widget.currentUser)) {
                        deleteFireRequest(
                          widget.postID, 
                          widget.fires, 
                          widget.currentUser, 
                          widget.firedBy);
                      } else {
                        fireRequest(
                          widget.postID, 
                          widget.fires, 
                          widget.subject, 
                          widget.currentUser, 
                          widget.currentUserUsername, 
                          widget.firedBy, 
                          widget.adminUID, 
                          widget.adminNotificationsToken, 
                          widget.currentUserPhoto);
                      }
                    },
                  child: new Container(
                    height: 30.0,
                    width: 55.0,
                    decoration: new BoxDecoration(
                      color: widget.firedBy.contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                      borderRadius: new BorderRadius.circular(3.0)
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text('🔥',
                        style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          widget.fires != null
                          ? widget.fires.toString()
                          : ' ',
                        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ),
                  new InkWell(
                    onTap: () {
                      if(widget.rocketedBy.contains(widget.currentUser)) {
                        deleteRocketRequest(
                          widget.postID, 
                          widget.rockets, 
                          widget.currentUser, 
                          widget.rocketedBy);
                      } else {
                        rocketRequest(
                          widget.postID, 
                          widget.rockets, 
                          widget.subject, 
                          widget.currentUser, 
                          widget.currentUserUsername, 
                          widget.rocketedBy, 
                          widget.adminUID, 
                          widget.adminNotificationsToken, 
                          widget.currentUserPhoto);
                      }
                    },
                  child: new Container(
                    height: 30.0,
                    width: 55.0,
                    decoration: new BoxDecoration(
                      color: widget.rocketedBy.contains(widget.currentUser) ?  Colors.purpleAccent.withOpacity(0.2) : Colors.grey[800].withOpacity(0.6),
                      borderRadius: new BorderRadius.circular(3.0)
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text('🚀',
                        style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          widget.rockets != null
                          ? widget.rockets.toString()
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
                          widget.comments != null
                          ? widget.comments.toString()
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
                child: _uploadInProgress == false
                ? new TextField(
                  focusNode: widget.listFocusNodeController[widget.index],
                  showCursor: true,
                  //textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  style: new TextStyle(color: Colors.white, fontSize: 13.0),
                  keyboardType: TextInputType.multiline,
                  scrollPhysics: new ScrollPhysics(),
                  onChanged: (value) {
                    if(widget.listTextEditingController[widget.index].text.length > 0 && widget.listTextEditingController[widget.index].text.length == 1) {
                      setState(() {});
                    } else if (widget.listTextEditingController[widget.index].text.length == 0) {
                      setState(() {});
                    }
                  },
                  keyboardAppearance: Brightness.dark,
                  minLines: null,
                  maxLines: null,
                  controller: widget.listTextEditingController[widget.index],
                  cursorColor: Colors.white,
                  obscureText: false,
                  decoration: new InputDecoration(
                    suffixIcon: new IconButton(
                      icon: new Icon(CupertinoIcons.arrow_up_circle_fill, color: widget.listTextEditingController[widget.index].text.length > 0 ? Colors.cyanAccent :  Colors.grey[600], size: 25.0),
                      onPressed: () {
                            if(widget.listTextEditingController[widget.index].text.length > 1 && widget.listTextEditingController[widget.index].value.text != '  ') {
                            setState(() {
                              _uploadInProgress = true;
                            });
                            widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
                            int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                            FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.postID)
                              .collection('comments')
                              .doc('$_timestampCreation${widget.currentUserUsername}')
                              .set({
                                'adminUID': widget.adminUID,
                                'commentatorProfilephoto': widget.currentUserPhoto,
                                'commentatorSoundCloud': widget.currentSoundCloud,
                                'commentatorUID': widget.currentUser,
                                'commentatorUsername': widget.currentUserUsername,
                                'content': widget.listTextEditingController[widget.index].value.text,
                                'postID': widget.postID,
                                'subject': widget.subject,
                                'timestamp': _timestampCreation,
                              }).whenComplete(() {
                               widget.listTextEditingController[widget.index].clear();
                               setState((){
                                 _uploadInProgress = false;
                                 });
                                FirebaseFirestore.instance
                                  .collection('posts')
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
                                          widget.listFocusNodeController[widget.index].unfocus();
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
              widget.savedBy.contains(widget.currentUser)
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
                child: widget.listIsExpanded[widget.index] == true ? new CommentContainer(
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
                 postID: widget.postID,
                 reactedBy: widget.reactedBy,
                 homeContext: widget.homeContext,
                )
                : new Container(),
              ),
            ],
          ),
        ),
        ),
      );
  }
}
