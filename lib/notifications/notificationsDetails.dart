import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flanger_web_version/commentContainer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


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

class NotificationsDetailsState extends State<NotificationsDetails> {

  TextEditingController _postCommentEditingController = new TextEditingController();

  /*Stream<dynamic> _fetchPostsDatas;
  Stream<dynamic> fetchPostsDatas() {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(widget.postID)
      .snapshots();
  }*/


  String currentSoundCloud;
  String currentNotificationsToken;
  getCurrentSoundCloud() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          setState(() {
            currentSoundCloud = value.data()['soundCloud'];
            currentNotificationsToken = value.data()['notificationsToken'];
          });
        }
      });
  }

  @override
  void initState() {
   // _fetchPostsDatas = fetchPostsDatas();
    getCurrentSoundCloud();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: new Container(
          constraints: new BoxConstraints(
            minWidth: 500.0,
            maxWidth: 850.0
          ),
        child: /*new StreamBuilder(
          stream: _fetchPostsDatas,
          builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
              return  new Container(
                height: MediaQuery.of(context).size.height*0.40,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                ),
              );
              }
              if(!snapshot.data.exists || !snapshot.hasData) {
              return  new Container(
                height: MediaQuery.of(context).size.height*0.40,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        new Text('This post has been deleted.',
                        style: new TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Icon(CupertinoIcons.wifi_exclamationmark, color: Colors.grey[600], size: 30.0)
                    ],
                  ),
              ));
              }*/
               new Container(
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
                                    backgroundColor: Colors.grey[800],
                                      title: new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Center(
                                            child: new Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.grey[600], 
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: new Center(
                                              child: new Text('Username',
                                              style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)
                                              ),
                                            ),
                                            ),
                                        ],
                                      ),
                                      content: new Container(
                                        height: 40.0,
                                        width: 60.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: new BorderRadius.circular(40.0),
                                        ),
                                        child: new Center(
                                          child: new Text('SoundCloud',
                                          style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold)
                                          ),
                                        ),
                                      ),
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
                                  print(selectedValue);
                                },
                                itemBuilder: (BuildContext ctx) => [
                                 new PopupMenuItem(
                                   child: new Row(
                                     children: [
                                       new Text('Save'),
                                       new Padding(padding: EdgeInsets.only(left: 5.0),
                                       child: new Icon(CupertinoIcons.cloud_download))]
                                       ), value: '1'),
                                       //2
                                 new PopupMenuItem(
                                   child: new Row(
                                     children: [
                                       new Text('Report'),
                                       new Padding(padding: EdgeInsets.only(left: 5.0),
                                       child: new Icon(CupertinoIcons.tag))]
                                       ), value: '2')]
                              ),
                            ),
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

                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.purpleAccent.withOpacity(0.2), //Colors.grey[800].withOpacity(0.6),
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

                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[800].withOpacity(0.6),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('🔥',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text('0',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                                new InkWell(
                                  onTap: () {

                                  },
                                child: new Container(
                                  height: 30.0,
                                  width: 55.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[800].withOpacity(0.6),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('🚀',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                      new Text('0',
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
                              child: new TextField(
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
                                decoration: new InputDecoration(
                                  suffixIcon: new IconButton(
                                    icon: new Icon(CupertinoIcons.arrow_up_circle_fill, color: Colors.grey[600], size: 25.0),
                                    onPressed: () {

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
                              ),
                            ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                              child: new CommentContainer(
                                currentUser: widget.currentUser,
                                currentUserUsername: widget.currentUserUsername,
                                currentUserPhoto: widget.currentUserPhoto,
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