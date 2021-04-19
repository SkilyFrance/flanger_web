import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ReplyContainer extends StatefulWidget {

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
  String postID;
  String commentID;
  String typeOfPost;
  BuildContext homeContext;


  ReplyContainer({
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
    this.postID,
    this.commentID,
    this.homeContext,
    this.typeOfPost,
    }) : super(key: key);


  @override
  ReplyContainerState createState() => ReplyContainerState();

}


class ReplyContainerState extends State<ReplyContainer> {

  final replyReported = new SnackBar(
    backgroundColor: Colors.red,
    content: new Text('This reply has been reported 👿',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  final replyDeleted = new SnackBar(
    backgroundColor: Colors.red,
    content: new Text('Reply deleted 😭',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));


Stream<dynamic> _fechAllReplies;
ScrollController _listRepliesScrollController = new ScrollController();

  Stream<dynamic> fechAllReplies() {
    return FirebaseFirestore.instance
      .collection(widget.typeOfPost == 'feedback'? 'feedbacks' : 'posts')
      .doc(widget.postID)
      .collection('comments')
      .doc(widget.commentID)
      .collection('reply')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  @override
  void initState() {
    _fechAllReplies = fechAllReplies();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fechAllReplies,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
        return  new Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: MediaQuery.of(context).size.width,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
          color: Colors.transparent,
          child: new Center(
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            ),
          ),
        );
        }
        if(snapshot.hasError) {
        return  new Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: MediaQuery.of(context).size.width,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
          color: Colors.transparent,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  new Text('No data, please restart.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold,
                  ),
                ),
                new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0)
              ],
            ),
        ));
        }
        if(!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return new Container();
        }
        return new Container(
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
          ),
          child: new ListView.builder(
            controller: _listRepliesScrollController,
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var ds = snapshot.data.docs[index];
              return new Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      decoration: new BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: new ListTile(
                    contentPadding: EdgeInsets.all(20.0),
                      leading: new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      child: ds['replierProfilephoto'] != null
                      ? new InkWell(
                        onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      backgroundColor: Color(0xff121212),
                      title: new FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(ds['replierUID']).get(),
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
                                child: snapshot.data['profilePhoto'] != null
                                ? new ClipOval(
                                  child: new Image.network(snapshot.data['profilePhoto'], fit: BoxFit.cover),
                                )
                                : new Container(),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Center(
                                child: new Text(
                                  snapshot.data['username'] != null
                                  ? snapshot.data['username']
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
                      child: new ClipOval(
                        child: new Image.network(ds['replierProfilephoto'], fit: BoxFit.cover),
                      ))
                      : new Container()
                      ),
                      title: new RichText(
                        textAlign: TextAlign.justify,
                        text: new TextSpan(
                          text: ds['replierUsername'] != null
                          ? ds['replierUsername'] + ' -  '
                          : 'Unknown' + ' -  ',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                          height: 1.1,
                          ),
                          children: [
                            new TextSpan(
                              text:  ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 1
                              ? 'few sec ago'
                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 60
                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes.toString() + ' min ago'
                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes >= 60
                              && ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours <= 24
                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours.toString() + ' hours ago'
                              : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours >= 24
                              ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inDays.toString() + ' days ago'
                              : '',
                              style:  new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal,
                              height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      subtitle: new Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ds['content'] != null
                        ? new Linkify(
                            onOpen: (urlToOpen) async {
                              if(await canLaunch(urlToOpen.url)) {
                                await launch(urlToOpen.url);
                              } else {
                                print(urlToOpen.url + ' error to launch');
                              }
                            },
                            text: ds['content'],
                            textAlign: TextAlign.justify,
                              style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                              height: 1.5,
                              letterSpacing: 1.1,
                              ),
                            )
                        : new Container(),
                      ),
                      trailing: ds['replierUID'] == widget.currentUser
                       ? new Material(
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
                                                  child: new Text('Delete this reply ?',
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
                                                        Navigator.pop(dialoContext);
                                                        FirebaseFirestore.instance
                                                          .collection(widget.typeOfPost == 'feedback'? 'feedbacks' : 'posts')
                                                          .doc(widget.postID)
                                                          .collection('comments')
                                                          .doc(widget.commentID)
                                                          .collection('reply')
                                                          .doc(ds['timestamp'].toString()+ds['replierUID'])
                                                          .delete().whenComplete(() {
                                                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(replyDeleted);
                                                          });
                                                          FirebaseFirestore.instance
                                                            .collection(widget.typeOfPost == 'feedback'? 'feedbacks' : 'posts')
                                                            .doc(widget.postID)
                                                            .update({
                                                              'comments': FieldValue.increment(-1),
                                                            }).whenComplete(() {
                                                              print('Cloud Firestore : Comment deleted & postComments -1');
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
                                  new Text('Delete'),
                                  new Padding(padding: EdgeInsets.only(left: 5.0),
                                  child: new Icon(CupertinoIcons.trash))]
                                  ), value: '1'),
                                  //2
                              ]
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
                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(replyReported);
                          },
                          itemBuilder: (BuildContext ctx) => [
                            new PopupMenuItem(
                                  child: new Row(
                                    children: [
                                      new Text('Report'),
                                      new Padding(padding: EdgeInsets.only(left: 5.0),
                                      child: new Icon(CupertinoIcons.tag))]
                                      ), value: '2'
                                  ),
                              ]
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}