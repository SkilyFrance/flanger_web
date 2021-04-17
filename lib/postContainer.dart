import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/requestList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:just_audio/just_audio.dart';
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
  List<List<int>> listfeedbackCategories;
  String postID;
  String typeOfPost;
  int timestamp;
  String adminUID;
  String subject;
  String body;
  String trackURL;
  double trackDuration;

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

  //AudioPlayerVariables
  AudioPlayer postContainerAudioPlayer;
  Duration postContainerDurationTrack;
  Duration postContainerCurrentPositionTrack;
  double postContainerTrackDragStart;
  int postContainerTrackDivisions;
  double postContainerTrackStartParticular;
  double postContainerTrackEndParticular;

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
    this.listfeedbackCategories,
    this.postID,
    this.typeOfPost,
    this.timestamp,
    this.adminUID,
    this.subject,
    this.body,
    this.trackURL,
    this.trackDuration,
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
    // AudioPlayers variables
    this.postContainerAudioPlayer,
    this.postContainerDurationTrack,
    this.postContainerCurrentPositionTrack,
    this.postContainerTrackDragStart,
    this.postContainerTrackDivisions,
    this.postContainerTrackStartParticular,
    this.postContainerTrackEndParticular,
    //
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
  String _trackURLPlaying = '';
  int _trackIsPlayingIndex; 
  bool _showListOfFeedbackTags = false;



  ScrollController _categoriesfeedbackListViewController = new ScrollController();
  ScrollController _listFeedbackCategorieAdded = new ScrollController();
  bool aboutSpecificPartTrack = true;
  bool chipCategoriesAreShowing = false;
  



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
  void initState() {
    print('listfeedbackCategories = ' + widget.listfeedbackCategories[widget.index].toString());
    widget.postContainerAudioPlayer = new AudioPlayer();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

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
                    .collection(widget.typeOfPost == 'feedback' ? 'test' : 'posts')
                    .doc(widget.postID)
                    .update({
                      'savedBy': FieldValue.arrayUnion([widget.currentUser]),
                    }).whenComplete(() {
                      print('No work');
                      //ScaffoldMessenger.of(widget.homeContext).showSnackBar(postSaved);
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
    
            ),
            // IF FEEDBACK CONTAINER
            widget.typeOfPost == 'feedback'
            ? new Padding(
              padding: EdgeInsets.only(top: 20.0,left: 0.0, right: 0.0, bottom: 40.0),
              child: new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  border: new Border.all(
                    width: 2.0,
                    color: widget.postContainerAudioPlayer.playerState.playing == true
                    ? Colors.purple
                    : Colors.transparent,
                  ),
                ),
                height: 110.0,
                               child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: new Center(
                                    child: new Text('A specific part was put forward by ' + widget.adminUsername,
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 12.0, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                      child: new IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        icon: new Icon(
                                        widget.postContainerAudioPlayer.playerState.playing == true 
                                       ? CupertinoIcons.pause_circle_fill
                                       : CupertinoIcons.play_circle_fill,
                                        size: 40.0,
                                        color: Colors.white,
                                        ), 
                                        onPressed: () async {
                                        if(_trackURLPlaying != widget.trackURL) {
                                          if(_trackURLPlaying != '') {
                                                   widget.postContainerAudioPlayer.stop().whenComplete(() async {
                                                  setState(() {
                                                    _trackURLPlaying = widget.trackURL;
                                                  });
                                                  await widget.postContainerAudioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                                                    widget.postContainerAudioPlayer.durationStream.listen((event) {
                                                      setState(() {
                                                        widget.postContainerDurationTrack = widget.postContainerAudioPlayer.duration;
                                                      });
                                                      widget.postContainerAudioPlayer.positionStream.listen((event) {
                                                        setState(() {
                                                          widget.postContainerCurrentPositionTrack = event;
                                                        });
                                                        //print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                                      // print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack[widget.index].inMilliseconds.toInt()).toString());
                                                        if(widget.postContainerCurrentPositionTrack >= Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt())) {
                                                          print('AudioPlayer: Extract finished');
                                                          widget.postContainerAudioPlayer.pause();
                                                          }
                                                      });
                                                      widget.postContainerAudioPlayer.play();
                                                    });
                                                  });
                                                  });
                                                
                                       
                                          } else {
                                            //_trackURLPlaying == ''
                                            print('AudioPlayer : Play cause no track played yet');
                                            setState(() {
                                              _trackURLPlaying = widget.trackURL;
                                              _trackIsPlayingIndex = widget.index;
                                            });
                                            await widget.postContainerAudioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                                              widget.postContainerAudioPlayer.durationStream.listen((event) {
                                                setState(() {
                                                  widget.postContainerDurationTrack = widget.postContainerAudioPlayer.duration;
                                                });
                                                widget.postContainerAudioPlayer.positionStream.listen((event) {
                                                  setState(() {
                                                    widget.postContainerCurrentPositionTrack = event;
                                                  });
                                                  print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                                  print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack.inMilliseconds.toInt()).toString());
                                                  if(widget.postContainerCurrentPositionTrack >= Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt())) {
                                                    print('AudioPlayer: Extract finished');
                                                    widget.postContainerAudioPlayer.pause();
                                                    }
                                                });
                                                widget.postContainerAudioPlayer.play();
                                              });
                                            });
                                          }
                                          
                                        } else if(_trackURLPlaying == widget.trackURL
                                            && widget.postContainerAudioPlayer.playerState.playing == false
                                            && ((widget.postContainerTrackDragStart > widget.postContainerCurrentPositionTrack.inMilliseconds) || (widget.postContainerTrackDragStart < widget.postContainerCurrentPositionTrack.inMilliseconds))) {
                                            widget.postContainerAudioPlayer.seek(Duration(milliseconds: widget.postContainerTrackDragStart.toInt())).whenComplete(() {
                                              print('AudioPlayer : play after seek');
                                              widget.postContainerAudioPlayer.play();
                                            });
                                        
                                          } else if(_trackURLPlaying == widget.trackURL
                                          && widget.postContainerAudioPlayer.playerState.playing == true) {
                                            print('AudioPlayer : Pause');
                                            widget.postContainerAudioPlayer.pause();
                                          }

                                          /*if(widget.postContainerAudioPlayer.playerState.playing == true) {
                                            widget.postContainerAudioPlayer.pause();
                                          } else {
                                            widget.postContainerAudioPlayer.seek(Duration(milliseconds: widget.postContainerTrackDragStart.toInt())).whenComplete(() {
                                              print('AudioPlayer: Start is seeked');
                                            widget.postContainerAudioPlayer.play();
                                            });
                                          }*/
                                        
                                        /*else if(_trackURLPlaying == widget.trackURL && widget.postContainerAudioPlayer[widget.index].playerState.playing == false) {
                                            print('AudioPlayer: Reprendre');
                                            widget.postContainerAudioPlayer[widget.index].play();
                                        }*/

                                        

                                      /*   if(_trackURLPlaying != widget.trackURL) {
                                            setState(() {
                                              _trackURLPlaying = widget.trackURL;
                                            });
                                          ////////////////////
                                          await widget.postContainerAudioPlayer[widget.index].setUrl(widget.trackURL).whenComplete(() async {
                                            widget.postContainerAudioPlayer[widget.index].durationStream.listen((event) {
                                              setState(() {
                                                widget.postContainerDurationTrack[widget.index] = widget.postContainerAudioPlayer[widget.index].duration;
                                              });
                                              widget.postContainerAudioPlayer[widget.index].positionStream.listen((event) {
                                                setState(() {
                                                  widget.postContainerCurrentPositionTrack[widget.index] = event;
                                                });
                                                //print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                               // print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack[widget.index].inMilliseconds.toInt()).toString());
                                                 if(widget.postContainerCurrentPositionTrack[widget.index] >= Duration(milliseconds: widget.postContainerDurationTrack[widget.index].inMilliseconds.toInt())) {
                                                   print('AudioPlayer: Extract finished');
                                                   widget.postContainerAudioPlayer[widget.index].pause();
                                                  }
                                              });
                                              widget.postContainerAudioPlayer[widget.index].play();
                                            });
                                          });

                                          } else if(_trackURLPlaying == widget.trackURL
                                            && widget.postContainerAudioPlayer[widget.index].playerState.playing == false
                                            && ((widget.postContainerTrackDragStart[widget.index] > widget.postContainerCurrentPositionTrack[widget.index].inMilliseconds) || (widget.postContainerTrackDragStart[widget.index] < widget.postContainerCurrentPositionTrack[widget.index].inMilliseconds))) {
                                            widget.postContainerAudioPlayer[widget.index].seek(Duration(milliseconds: widget.postContainerTrackDragStart[widget.index].toInt())).whenComplete(() {
                                              print('AudioPlayer : play after seek');
                                              widget.postContainerAudioPlayer[widget.index].play();
                                            });
                                        
                                          } else if(_trackURLPlaying == widget.trackURL
                                          && widget.postContainerAudioPlayer[widget.index].playerState.playing == true) {
                                            print('AudioPlayer : Pause');
                                            widget.postContainerAudioPlayer[widget.index].pause();
                                          }*/

                                          /*if(widget.postContainerAudioPlayer.playerState.playing == true) {
                                            widget.postContainerAudioPlayer.pause();
                                          } else {
                                            widget.postContainerAudioPlayer.seek(Duration(milliseconds: widget.postContainerTrackDragStart.toInt())).whenComplete(() {
                                              print('AudioPlayer: Start is seeked');
                                            widget.postContainerAudioPlayer.play();
                                            });
                                          }*/
                                          
                                        },
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: new Container(
                                          height: 50.0,
                                          width: 450.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: new BorderRadius.circular(40.0)
                                          ),
                                          child: new Stack(
                                            children: [
                                                new SliderTheme(
                                                  data: Theme.of(context).sliderTheme.copyWith(
                                                    trackHeight: 20.0,
                                                    disabledThumbColor: Colors.transparent,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20.0), 
                                                    thumbColor: Colors.grey[900],
                                                    //disabledThumbColor: Colors.transparent,
                                                    //trackShape: RoundedRectSliderTrackShape(),
                                                    //inactiveTrackColor: Colors.grey[900],
                                                    inactiveTrackColor: Colors.grey[900],
                                                    activeTrackColor: Color(0xffBF88FF),
                                                   // disabledInactiveTickMarkColor: Colors.transparent,
                                                    //activeTickMarkColor: Colors.deepPurpleAccent.withOpacity(0.6),
                                                    //inactiveTickMarkColor: Colors.grey[600],
                                                   // tickMarkShape: SliderTickMarkShape.noTickMark,
                                                  ),
                                                child: ExcludeSemantics(
                                                child: new RangeSlider(
                                                  labels: RangeLabels('',''),
                                                  min: 0.0,
                                                  max: 222693,
                                                  values: new RangeValues(widget.postContainerTrackStartParticular.toDouble(), widget.postContainerTrackEndParticular.toDouble()),
                                                  onChangeStart: (value) {},
                                                  onChanged: (value) {},
                                                  divisions: widget.postContainerAudioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
                                                  ),
                                                )),
                                                new SliderTheme(
                                                  data: Theme.of(context).sliderTheme.copyWith(
                                                    trackHeight: 20.0,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20.0), 
                                                    thumbColor: Colors.deepPurpleAccent,
                                                    //disabledThumbColor: Colors.transparent,
                                                    //trackShape: RoundedRectSliderTrackShape(),
                                                    inactiveTrackColor: Colors.transparent,
                                                    activeTrackColor: Colors.deepPurple.withOpacity(0.2),
                                                   // disabledInactiveTickMarkColor: Colors.transparent,
                                                    activeTickMarkColor: Colors.deepPurpleAccent.withOpacity(0.6),
                                                    inactiveTickMarkColor: Colors.grey[600],
                                                   // tickMarkShape: SliderTickMarkShape.noTickMark,
                                                  ),
                                                child: new Slider(
                                                  label: new Duration(milliseconds: (widget.postContainerTrackDragStart).toInt()).toString().split('.')[0],
                                                  min: 0.0,
                                                  max: widget.postContainerDurationTrack != null ? widget.postContainerDurationTrack.inMilliseconds.toDouble() : 120000,
                                                  value: widget.postContainerAudioPlayer.playerState.playing == true ? widget.postContainerCurrentPositionTrack.inMilliseconds.toDouble() : widget.postContainerTrackDragStart,
                                                  onChangeStart: (value) {
                                                    if(widget.postContainerAudioPlayer.playerState.playing == true) {
                                                      widget.postContainerAudioPlayer.pause();
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    setState((){
                                                      widget.postContainerTrackDragStart = value;
                                                    });
                                                  },
                                                  divisions: widget.postContainerAudioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        ),
                                    ],
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        new Text('Duration :',
                                        style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.bold),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: new Text(
                                          widget.postContainerDurationTrack != null && widget. postContainerCurrentPositionTrack != null
                                          ? 
                                          (widget.postContainerAudioPlayer.playerState.playing == true
                                          ? Duration(milliseconds: (widget.postContainerDurationTrack.inMilliseconds-widget.postContainerCurrentPositionTrack.inMilliseconds).toInt()).toString().split('.')[0]
                                          : Duration(milliseconds: (widget.postContainerDurationTrack.inMilliseconds-widget.postContainerTrackDragStart).toInt()).toString().split('.')[0]
                                          )
                                          : Duration(milliseconds: (widget.trackDuration).toInt()).toString().split('.')[0],
                                          style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.normal),
                                        
                                         //_dragValueEndFeedback.toInt().round()).toString().split('.')[0]
                                        ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ],
                                ),
              ),
            )
            : new Container(),
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
            //Categories feedback container
            widget.typeOfPost == 'feedback'
            ?  new Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: new Container(
                height: 130.0,
                decoration: new BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: new RichText(
                            text: new TextSpan(
                              text: 'Choose feedback categories ',
                              style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
                              children: [
                                new TextSpan(
                                  text: ' (Maximum: 3)',
                                  style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 5.0),
                          child: new Text('Your tag : ',
                          style: new TextStyle(color: Colors.grey, fontSize: 13.0),
                          )),
                        new Padding(
                          padding: EdgeInsets.only(left: 5.0, top: 5.0),
                          child: widget.listfeedbackCategories[widget.index].isEmpty
                          ? new Text('Select a tag below',
                          style: new TextStyle(color: Colors.grey[600], fontSize: 13.0),
                          )
                          : new Container(
                            height: 30.0,
                          child: new ListView.builder(
                            controller: _listFeedbackCategorieAdded,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: new ScrollPhysics(),
                            itemCount: widget.listfeedbackCategories[widget.index].length,
                            itemBuilder: (BuildContext context, int index){
                            return new Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: new Chip(
                                onDeleted: () {
                                switch(widget.listfeedbackCategories[widget.index][index]) {
                                  case 0: 
                                  setState(() {widget.listfeedbackCategories[widget.index].remove(0);});
                                  break;
                                  case 1: setState(() {widget.listfeedbackCategories[widget.index].remove(1);});
                                  break;
                                  case 2: setState(() {widget.listfeedbackCategories[widget.index].remove(2);});
                                  break;
                                  case 3: setState(() {widget.listfeedbackCategories[widget.index].remove(3);});
                                  break;
                                  case 4: setState(() {widget.listfeedbackCategories[widget.index].remove(4);});
                                  break;
                                  case 5: setState(() {widget.listfeedbackCategories[widget.index].remove(5);});
                                  break;
                                  case 6: setState(() {widget.listfeedbackCategories[widget.index].remove(6);});
                                  break;
                                  case 7: setState(() {widget.listfeedbackCategories[widget.index].remove(7);});
                                  break;
                                  case 8: setState(() {widget.listfeedbackCategories[widget.index].remove(8);});
                                  break;
                                  case 9: setState(() {widget.listfeedbackCategories[widget.index].remove(9);});
                                  break;
                                  case 10: setState(() {widget.listfeedbackCategories[widget.index].remove(10);});
                                  break;
                                  default: print('error switch categorie feedback');
                                }
                                },
                                backgroundColor: 
                                widget.listfeedbackCategories[widget.index][index] == 0
                              ? Colors.lightBlue[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 1
                              ? Colors.blueGrey[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 2
                              ? Colors.purple[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 3
                              ? Colors.cyanAccent
                              : widget.listfeedbackCategories[widget.index][index] == 4
                              ? Colors.indigoAccent[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 5
                              ? Color(0xff68FA1E)
                              :  widget.listfeedbackCategories[widget.index][index] == 6
                              ? Colors.indigo
                              :  widget.listfeedbackCategories[widget.index][index] == 7
                              ? Colors.pink[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 8
                              ? Colors.yellow[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 9
                              ? Colors.purpleAccent[400]
                              :  widget.listfeedbackCategories[widget.index][index] == 10
                              ? Colors.deepPurple[400]
                              : Colors.black,
                                label: new Text(
                                  widget.listfeedbackCategories[widget.index][index] == 0
                                  ? 'Melodies'
                                  : widget.listfeedbackCategories[widget.index][index] == 1
                                  ? 'Vocals'
                                  : widget.listfeedbackCategories[widget.index][index] == 2
                                  ? 'Sound Design'
                                  : widget.listfeedbackCategories[widget.index][index] == 3
                                  ? 'Composition'
                                  : widget.listfeedbackCategories[widget.index][index] == 4
                                  ? 'Drums'
                                  : widget.listfeedbackCategories[widget.index][index] == 5
                                  ? 'Bass'
                                  : widget.listfeedbackCategories[widget.index][index] == 6
                                  ? 'Automation'
                                  : widget.listfeedbackCategories[widget.index][index] == 7
                                  ? 'Mixing'
                                  : widget.listfeedbackCategories[widget.index][index] == 8
                                  ? 'Mastering'
                                  : widget.listfeedbackCategories[widget.index][index] == 9
                                  ? 'Music theory'
                                  : widget.listfeedbackCategories[widget.index][index] == 10
                                  ? 'Filling up'
                                  : 'Melodies',
                                style: new TextStyle(color:  Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
                                ),
                            ),
                            );
                            }),
                          ),
                        ),
                      ],
                    ),
                     new Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: new Container(
                      height: 35.0,
                      child: new ListView.builder(
                        padding: EdgeInsets.only(left: 0.0, right: 10.0),
                        controller: _categoriesfeedbackListViewController,
                        physics: new ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 11,
                        itemBuilder: (BuildContext context, int index) {
                          return new Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: widget.listfeedbackCategories[widget.index].contains(index) == false
                            ? new Chip(
                                deleteButtonTooltipMessage: 'Add',
                                deleteIcon: new Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 20.0),
                                onDeleted: () {
                                  if(widget.listfeedbackCategories[widget.index].length >= 3) {
                                    print('Maximum reached');
                                  } else {
                                  switch(index) {
                                    case 0: 
                                    setState(() {widget.listfeedbackCategories[widget.index].add(0);});
                                    break;
                                    case 1: setState(() {widget.listfeedbackCategories[widget.index].add(1);});
                                    break;
                                    case 2: setState(() {widget.listfeedbackCategories[widget.index].add(2);});
                                    break;
                                    case 3: setState(() {widget.listfeedbackCategories[widget.index].add(3);});
                                    break;
                                    case 4: setState(() {widget.listfeedbackCategories[widget.index].add(4);});
                                    break;
                                    case 5: setState(() {widget.listfeedbackCategories[widget.index].add(5);});
                                    break;
                                    case 6: setState(() {widget.listfeedbackCategories[widget.index].add(6);});
                                    break;
                                    case 7: setState(() {widget.listfeedbackCategories[widget.index].add(7);});
                                    break;
                                    case 8: setState(() {widget.listfeedbackCategories[widget.index].add(8);});
                                    break;
                                    case 9: setState(() {widget.listfeedbackCategories[widget.index].add(9);});
                                    break;
                                    case 10: setState(() {widget.listfeedbackCategories[widget.index].add(10);});
                                    break;
                                    default: print('error switch categorie feedback');
                                  }
                                  }
                                },
                                side: BorderSide(
                                  color: index == 0
                                    ? Colors.lightBlue[400]
                                    :  index == 1
                                    ? Colors.blueGrey[400]
                                    :  index == 2
                                    ? Colors.purple[400]
                                    :  index == 3
                                    ? Colors.cyanAccent
                                    : index == 4
                                    ? Colors.indigoAccent[400]
                                    :  index == 5
                                    ? Color(0xff68FA1E)
                                    :  index == 6
                                    ? Colors.indigo
                                    :  index == 7
                                    ? Colors.pink[400]
                                    :  index == 8
                                    ? Colors.yellow[400]
                                    :  index == 9
                                    ? Colors.purpleAccent[400]
                                    :  index == 10
                                    ? Colors.deepPurple[400]
                                    : Colors.black,
                                ),
                                backgroundColor: Colors.black,
                                  label: new Text(
                                    index == 0
                                    ? 'Melodies'
                                    : index == 1
                                    ? 'Vocals'
                                    : index == 2
                                    ? 'Sound Design'
                                    : index == 3
                                    ? 'Composition'
                                    : index == 4
                                    ? 'Drums'
                                    : index == 5
                                    ? 'Bass'
                                    : index == 6
                                    ? 'Automation'
                                    : index == 7
                                    ? 'Mixing'
                                    : index == 8
                                    ? 'Mastering'
                                    : index == 9
                                    ? 'Music theory'
                                    : index == 10
                                    ? 'Filling up'
                                    : 'Melodies',
                                  style: new TextStyle(color:  Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                  ),
                                )
                              : new Container(),
                          );
                        },
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              )
              : new Container(),
            widget.typeOfPost == 'feedback'
            ? new Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
            child: new Container(
              height: 30.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Switch(
                    activeColor: Color(0xffBF88FF),
                    activeTrackColor: Color(0xffBF88FF).withOpacity(0.5),
                    inactiveTrackColor: Colors.grey[900],
                    value: aboutSpecificPartTrack, 
                    onChanged: (value) {
                      setState(() {
                        aboutSpecificPartTrack =! aboutSpecificPartTrack;
                      });
                    }),
                  new Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: new Text(
                      aboutSpecificPartTrack == true
                      ? 'This comment is about the specific part'
                      : 'This comment is not about the specific part',
                      style: new TextStyle(color: aboutSpecificPartTrack == true ? Colors.white : Colors.grey[600], fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1.0,
                      letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              )
            ),
            )
            : new Container(),
            //TextEditingController
             new Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
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
                        if(widget.typeOfPost == 'feedback' && widget.listTextEditingController[widget.index].text.length > 1 && widget.listTextEditingController[widget.index].value.text != '  ') {
                          if(widget.listfeedbackCategories[widget.index].isNotEmpty) {
                            print('feedback comment go');
                            setState(() {
                              _uploadInProgress = true;
                            });
                            widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
                            int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                            FirebaseFirestore.instance
                              .collection('test')
                              .doc(widget.postID)
                              .collection('comments')
                              .doc('$_timestampCreation${widget.currentUserUsername}')
                              .set({
                                'feedbackCategorie': widget.listfeedbackCategories[widget.index],
                                'aboutSpecificPartTrack': aboutSpecificPartTrack,
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
                                  .collection('test')
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
                                          'body': 'has commented this feedback request 🎹 : ' + widget.listTextEditingController[widget.index].value.text,
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
                          } else {
                            print('Choose a category');
                          }
                        } else if(((widget.typeOfPost == 'issue') || (widget.typeOfPost == 'tip') || (widget.typeOfPost == 'project') ) && widget.listTextEditingController[widget.index].text.length > 1 && widget.listTextEditingController[widget.index].value.text != '  ') {
                           /* setState(() {
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
                              });*/
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
              ? new Padding(
                padding: EdgeInsets.only(top: 15.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Icon(
                    CupertinoIcons.cloud_download, color: Colors.grey[600], size: 20.0),
                  new Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 20.0,),
                    child: new Text('Post already saved',
                    style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
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
                 typeOfPost: widget.typeOfPost,
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
