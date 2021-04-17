import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flanger_web_version/commentContainer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:just_audio/just_audio.dart';
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


  // VARIABLES FOR PLAY A TRACK ON POST CONTAINER //
  AudioPlayer postContainerAudioPlayer = new AudioPlayer();
  List<int> subListFeedbackCategorie = [];
  Duration postContainerDurationTrack;
  Duration postContainerCurrentPositionTrack;
  double postContainerTrackDragStart = 0.0;
  //double postContainerTrackStartParticular;
  //double postContainerTrackEndParticular;
  String _trackURLPlaying = '';
  List<int> listfeedbackCategories = [];
  ScrollController _categoriesfeedbackListViewController = new ScrollController();
  ScrollController _listFeedbackCategorieAdded = new ScrollController();
  bool aboutSpecificPartTrack = true;
  ///////////////////////////////////////


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    postContainerAudioPlayer.dispose();
    super.dispose();
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
                                : widget.snapshot.data['typeOfPost'] == 'project'
                                ? Colors.lightBlue
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

                      // IF FEEDBACK CONTAINER
                     widget.snapshot.data['typeOfPost'] == 'feedback'
                      ? new Padding(
                        padding: EdgeInsets.only(top: 20.0,left: 0.0, right: 0.0, bottom: 40.0),
                        child: new Container(
                          height: 100.0,
                                        child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                          new Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: new Center(
                                              child: new Text('A specific part was put forward by ' + widget.snapshot.data['adminUsername'],
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
                                                  postContainerAudioPlayer.playerState.processingState == ProcessingState.loading
                                                ? new CircularProgressIndicator(
                                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                                )
                                                : postContainerAudioPlayer.playerState.playing == true 
                                                ? CupertinoIcons.pause_circle_fill
                                                : CupertinoIcons.play_circle_fill,
                                                  size: 40.0,
                                                  color: Colors.white,
                                                  ), 
                                                  onPressed: () async {
                                                    if(_trackURLPlaying != widget.snapshot.data['trackURL']) {
                                                      setState(() {
                                                        _trackURLPlaying = widget.snapshot.data['trackURL'];
                                                      });
                                                    ////////////////////
                                                    await postContainerAudioPlayer.setUrl(widget.snapshot.data['trackURL']).whenComplete(() async {
                                                      postContainerAudioPlayer.durationStream.listen((event) {
                                                        setState(() {
                                                          postContainerDurationTrack = postContainerAudioPlayer.duration;
                                                        });
                                                        postContainerAudioPlayer.positionStream.listen((event) {
                                                          setState(() {
                                                            postContainerCurrentPositionTrack = event;
                                                          });
                                                          //print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                                          print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: postContainerCurrentPositionTrack.inMilliseconds.toInt()).toString());
                                                          if(postContainerCurrentPositionTrack >= Duration(milliseconds: postContainerDurationTrack.inMilliseconds.toInt())) {
                                                            print('AudioPlayer: Extract finished');
                                                            postContainerAudioPlayer.pause();
                                                            }
                                                        });
                                                          postContainerAudioPlayer.play();
                                                      });
                                                    });
                                                    } else if(_trackURLPlaying == widget.snapshot.data['trackURL']
                                                      && postContainerAudioPlayer.playerState.playing == false
                                                      && ((postContainerTrackDragStart > postContainerCurrentPositionTrack.inMilliseconds) || (postContainerTrackDragStart < postContainerCurrentPositionTrack.inMilliseconds))) {
                                                      postContainerAudioPlayer.seek(Duration(milliseconds: postContainerTrackDragStart.toInt())).whenComplete(() {
                                                        print('AudioPlayer : play after seek');
                                                        postContainerAudioPlayer.play();
                                                      });
                                                  
                                                    } else if(_trackURLPlaying == widget.snapshot.data['trackURL']
                                                    && postContainerAudioPlayer.playerState.playing == true) {
                                                      print('AudioPlayer : Pause');
                                                      postContainerAudioPlayer.pause();
                                                    }
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
                                                            values: new RangeValues(widget.snapshot.data['startParticularPart'].toDouble(), widget.snapshot.data['endParticularPart'].toDouble()),
                                                            onChangeStart: (value) {},
                                                            onChanged: (value) {},
                                                            divisions: postContainerAudioPlayer.playerState.playing == true ? null : widget.snapshot.data['divisions'],
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
                                                            label: new Duration(milliseconds: (postContainerTrackDragStart).toInt()).toString().split('.')[0],
                                                            min: 0.0,
                                                            max: 222693,
                                                            value: postContainerAudioPlayer.playerState.playing == true ? postContainerCurrentPositionTrack.inMilliseconds.toDouble() : postContainerTrackDragStart,
                                                            onChangeStart: (value) {
                                                              if(postContainerAudioPlayer.playerState.playing == true) {
                                                                postContainerAudioPlayer.pause();
                                                              }
                                                            },
                                                            onChanged: (value) {
                                                              setState((){
                                                                postContainerTrackDragStart = value;
                                                              });
                                                            },
                                                            divisions: postContainerAudioPlayer.playerState.playing == true ? null : widget.snapshot.data['divisions'],
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
                                                    postContainerDurationTrack != null && postContainerCurrentPositionTrack != null
                                                    ? 
                                                    (postContainerAudioPlayer.playerState.playing == true
                                                    ? Duration(milliseconds: (postContainerDurationTrack.inMilliseconds-postContainerCurrentPositionTrack.inMilliseconds).toInt()).toString().split('.')[0]
                                                    : Duration(milliseconds: (postContainerDurationTrack.inMilliseconds-postContainerTrackDragStart).toInt()).toString().split('.')[0]
                                                    )
                                                    : Duration(milliseconds: (widget.snapshot.data['trackDuration']).toInt()).toString().split('.')[0],
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
            //Categories feedback container
             widget.snapshot.data['typeOfPost'] == 'feedback'
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
                          child: listfeedbackCategories.isEmpty
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
                            itemCount: listfeedbackCategories.length,
                            itemBuilder: (BuildContext context, int index){
                            return new Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: new Chip(
                                onDeleted: () {
                                switch(listfeedbackCategories[index]) {
                                  case 0: 
                                  setState(() {listfeedbackCategories.remove(0);});
                                  break;
                                  case 1: setState(() {listfeedbackCategories.remove(1);});
                                  break;
                                  case 2: setState(() {listfeedbackCategories.remove(2);});
                                  break;
                                  case 3: setState(() {listfeedbackCategories.remove(3);});
                                  break;
                                  case 4: setState(() {listfeedbackCategories.remove(4);});
                                  break;
                                  case 5: setState(() {listfeedbackCategories.remove(5);});
                                  break;
                                  case 6: setState(() {listfeedbackCategories.remove(6);});
                                  break;
                                  case 7: setState(() {listfeedbackCategories.remove(7);});
                                  break;
                                  case 8: setState(() {listfeedbackCategories.remove(8);});
                                  break;
                                  case 9: setState(() {listfeedbackCategories.remove(9);});
                                  break;
                                  case 10: setState(() {listfeedbackCategories.remove(10);});
                                  break;
                                  default: print('error switch categorie feedback');
                                }
                                },
                                backgroundColor: 
                                listfeedbackCategories[index] == 0
                              ? Colors.lightBlue[400]
                              :  listfeedbackCategories[index] == 1
                              ? Colors.blueGrey[400]
                              :  listfeedbackCategories[index] == 2
                              ? Colors.purple[400]
                              :  listfeedbackCategories[index] == 3
                              ? Colors.cyanAccent
                              : listfeedbackCategories[index] == 4
                              ? Colors.indigoAccent[400]
                              :  listfeedbackCategories[index] == 5
                              ? Color(0xff68FA1E)
                              :  listfeedbackCategories[index] == 6
                              ? Colors.indigo
                              :  listfeedbackCategories[index] == 7
                              ? Colors.pink[400]
                              :  listfeedbackCategories[index] == 8
                              ? Colors.yellow[400]
                              :  listfeedbackCategories[index] == 9
                              ? Colors.purpleAccent[400]
                              :  listfeedbackCategories[index] == 10
                              ? Colors.deepPurple[400]
                              : Colors.black,
                                label: new Text(
                                  listfeedbackCategories[index] == 0
                                  ? 'Melodies'
                                  : listfeedbackCategories[index] == 1
                                  ? 'Vocals'
                                  : listfeedbackCategories[index] == 2
                                  ? 'Sound Design'
                                  : listfeedbackCategories[index] == 3
                                  ? 'Composition'
                                  : listfeedbackCategories[index] == 4
                                  ? 'Drums'
                                  : listfeedbackCategories[index] == 5
                                  ? 'Bass'
                                  : listfeedbackCategories[index] == 6
                                  ? 'Automation'
                                  : listfeedbackCategories[index] == 7
                                  ? 'Mixing'
                                  : listfeedbackCategories[index] == 8
                                  ? 'Mastering'
                                  : listfeedbackCategories[index] == 9
                                  ? 'Music theory'
                                  : listfeedbackCategories[index] == 10
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
                            child: listfeedbackCategories.contains(index) == false
                            ? new Chip(
                                deleteButtonTooltipMessage: 'Add',
                                deleteIcon: new Icon(CupertinoIcons.add_circled_solid, color: Colors.white, size: 20.0),
                                onDeleted: () {
                                  if(listfeedbackCategories.length >= 3) {
                                    print('Maximum reached');
                                  } else {
                                  switch(index) {
                                    case 0: 
                                    setState(() {listfeedbackCategories.add(0);});
                                    break;
                                    case 1: setState(() {listfeedbackCategories.add(1);});
                                    break;
                                    case 2: setState(() {listfeedbackCategories.add(2);});
                                    break;
                                    case 3: setState(() {listfeedbackCategories.add(3);});
                                    break;
                                    case 4: setState(() {listfeedbackCategories.add(4);});
                                    break;
                                    case 5: setState(() {listfeedbackCategories.add(5);});
                                    break;
                                    case 6: setState(() {listfeedbackCategories.add(6);});
                                    break;
                                    case 7: setState(() {listfeedbackCategories.add(7);});
                                    break;
                                    case 8: setState(() {listfeedbackCategories.add(8);});
                                    break;
                                    case 9: setState(() {listfeedbackCategories.add(9);});
                                    break;
                                    case 10: setState(() {listfeedbackCategories.add(10);});
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
            widget.snapshot.data['typeOfPost'] == 'feedback'
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
                                typeOfPost:widget.snapshot.data['typeOfPost'] ,
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