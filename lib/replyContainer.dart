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
    }) : super(key: key);


  @override
  ReplyContainerState createState() => ReplyContainerState();

}


class ReplyContainerState extends State<ReplyContainer> {


Stream<dynamic> _fechAllReplies;
ScrollController _listRepliesScrollController = new ScrollController();

  Stream<dynamic> fechAllReplies() {
    return FirebaseFirestore.instance
      .collection('posts')
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
                      ? new ClipOval(
                        child: new Image.network(ds['replierProfilephoto'], fit: BoxFit.cover),
                      )
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