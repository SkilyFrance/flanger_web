import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/replyContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentContainer extends StatefulWidget {

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
  String typeOfPost;
  Map<dynamic, dynamic> reactedBy;
  BuildContext homeContext;

  CommentContainer({
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
    this.typeOfPost,
    this.reactedBy,
    this.homeContext,
    }) : super(key: key);


  @override
  CommentContainerState createState() => CommentContainerState();

}

class CommentContainerState extends State<CommentContainer> {

  final commentDeleted = new SnackBar(
    backgroundColor: Colors.red,
    content: new Text('Comment deleted 😭',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));

  final commentReported = new SnackBar(
    backgroundColor: Colors.red,
    content: new Text('This comment has been reported 👿',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
    ));


  ScrollController _listFeedbackCategoriesScrollController = new ScrollController();

  bool _uploadInProgress = false;


  Stream<dynamic> _fetchAllComments;
  ScrollController _listCommentsScrollController = new ScrollController();
  List<TextEditingController> listTextEditingController = [];
  List<FocusNode> listFocusNodeController = [];
  Stream<dynamic> fetchAllComments() {
    return FirebaseFirestore.instance
      .collection(widget.typeOfPost == 'feedback' ? 'test' : 'posts')
      .doc(widget.postID)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }





@override
  void initState() {
    _fetchAllComments = fetchAllComments();
    _listCommentsScrollController = new ScrollController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fetchAllComments,
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
        return  new Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  new Text('Be first to comment.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.normal,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0),
                child: new Icon(CupertinoIcons.bubble_left_bubble_right, color: Colors.grey[600], size: 30.0)),
              ],
            ),
        ));
        }
        return new Container(
          width: MediaQuery.of(context).size.width,
          child: new ListView.builder(
            controller: _listCommentsScrollController,
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var ds = snapshot.data.docs[index];
              listTextEditingController.add(TextEditingController());
              listFocusNodeController.add(FocusNode());
              return new Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    border: new Border.all(
                      width: 0.5,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.typeOfPost == 'feedback'
                    ? new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 20.0),
                      child: new Container(
                        height: 40.0,
                      child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _listFeedbackCategoriesScrollController,
                        physics: new NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ds['feedbackCategorie'].length,
                        itemBuilder: (BuildContext context, int indexFeedbackCategorie) {
                          return new Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          child: new Chip(
                            label: new Text(
                                  ds['feedbackCategorie'][indexFeedbackCategorie] == 0
                                  ? 'Melodies'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 1
                                  ? 'Vocals'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 2
                                  ? 'Sound Design'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 3
                                  ? 'Composition'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 4
                                  ? 'Drums'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 5
                                  ? 'Bass'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 6
                                  ? 'Automation'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 7
                                  ? 'Mixing'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 8
                                  ? 'Mastering'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 9
                                  ? 'Music theory'
                                  : ds['feedbackCategorie'][indexFeedbackCategorie] == 10
                                  ? 'Filling up'
                                  : 'Melodies',
                                style: new TextStyle(color:  Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
                                ),
                                backgroundColor:
                                ds['feedbackCategorie'][indexFeedbackCategorie] == 0
                              ? Colors.lightBlue[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 1
                              ? Colors.blueGrey[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 2
                              ? Colors.purple[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 3
                              ? Colors.cyanAccent
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 4
                              ? Colors.indigoAccent[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 5
                              ? Color(0xff68FA1E)
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 6
                              ? Colors.indigo
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 7
                              ? Colors.pink[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 8
                              ? Colors.yellow[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 9
                              ? Colors.purpleAccent[400]
                              :  ds['feedbackCategorie'][indexFeedbackCategorie] == 10
                              ? Colors.deepPurple[400]
                              : Colors.black,
                              ),
                            );
                        }),
                      ),
                      ),
                      ],
                    )
                    : new Container(),
                    widget.typeOfPost == 'feedback'
                    ? new Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0),
                            child: new Text(
                              ds['aboutSpecificPartTrack'] == true
                              ? 'About the specific part'
                              : 'Not about the specific part',
                              style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.normal),
                            ),
                            ),
                          new Padding(padding: EdgeInsets.only(top: 10.0, left: 10.0),
                          child: new Icon(
                            ds['aboutSpecificPartTrack'] == true
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.nosign,
                            color: ds['aboutSpecificPartTrack'] == true ? Color(0xffBF88FF) : Colors.grey[600],
                            size: 20.0,
                          )
                          ),
                        ],
                      )
                    )
                    : new Container(),
                    new ListTile(
                    contentPadding: EdgeInsets.all(20.0),
                      leading: new InkWell(
                        onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      backgroundColor: Color(0xff121212),
                      title: new FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(ds['commentatorUID']).get(),
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
                      child: new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      child: ds['commentatorProfilephoto'] != null
                      ? new ClipOval(
                        child: new Image.network(ds['commentatorProfilephoto'], fit: BoxFit.cover),
                      )
                      : new Container()
                      )),
                      title: new RichText(
                        textAlign: TextAlign.justify,
                        text: new TextSpan(
                          text: ds['commentatorUsername'] != null
                          ? ds['commentatorUsername'] + ' -  '
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
                      trailing: ds['commentatorUID'] == widget.currentUser
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
                                                  child: new Text('Delete this comment ?',
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
                                                        FirebaseFirestore.instance
                                                          .collection('posts')
                                                          .doc(widget.postID)
                                                          .collection('comments')
                                                          .doc(ds.data()['timestamp'].toString()+ds.data()['commentatorUsername'])
                                                          .delete().whenComplete(() {
                                                            Navigator.pop(dialoContext);
                                                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(commentDeleted);
                                                          });
                                                          FirebaseFirestore.instance
                                                            .collection('posts')
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
                            ScaffoldMessenger.of(widget.homeContext).showSnackBar(commentReported);
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
                    //TextEditingController
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
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
                          //textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          style: new TextStyle(color: Colors.white, fontSize: 13.0),
                          keyboardType: TextInputType.multiline,
                          scrollPhysics: new ScrollPhysics(),
                          keyboardAppearance: Brightness.dark,
                          minLines: null,
                          maxLines: null,
                          focusNode: listFocusNodeController[index],
                          controller: listTextEditingController[index],
                          cursorColor: Colors.white,
                          obscureText: false,
                          onChanged: (value) {
                            if(listTextEditingController[index].text.length > 0 && listTextEditingController[index].text.length == 1) {
                              setState(() {});
                            } else if (listTextEditingController[index].text.length == 0) {
                              setState(() {});
                            }
                          },
                          decoration: new InputDecoration(
                            suffixIcon: new IconButton(
                              icon: new Icon(CupertinoIcons.arrow_up_circle_fill, color: listTextEditingController[index].text.length > 0 ? Colors.cyanAccent : Colors.grey[600], size: 25.0),
                              onPressed: () {
                           if(listTextEditingController[index].text.length > 1 && listTextEditingController[index].value.text != '  ') {
                            setState(() {
                              _uploadInProgress = true;
                            });
                            widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
                            int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                            FirebaseFirestore.instance
                              .collection(widget.typeOfPost == 'feedback' ? 'test' : 'posts')
                              .doc(widget.postID)
                              .collection('comments')
                              .doc(ds['timestamp'].toString()+ds['commentatorUsername'])
                              .collection('reply')
                              .doc(_timestampCreation.toString()+widget.currentUser)
                              .set({
                                'adminUID': ds['adminUID'],
                                'commentatorUID': ds['commentatorUID'],
                                'replierUID': widget.currentUser,
                                'replierProfilephoto': widget.currentUserPhoto,
                                'replierSoundCloud': widget.currentSoundCloud,
                                'replierUsername': widget.currentUserUsername,
                                'content': listTextEditingController[index].value.text,
                                'postID': widget.postID,
                                'subject': ds['subject'],
                                'timestamp': _timestampCreation,
                              }).whenComplete(() {
                               listTextEditingController[index].clear();
                               setState((){
                                 _uploadInProgress = false;
                                 });
                                FirebaseFirestore.instance
                                  .collection(widget.typeOfPost == 'feedback' ? 'test' : 'posts')
                                  .doc(widget.postID)
                                  .update({
                                    'comments': FieldValue.increment(1),
                                    'commentedBy': FieldValue.arrayUnion([widget.currentUser]),
                                    'reactedBy': widget.reactedBy,
                                  }).whenComplete(() {
                                    widget.reactedBy.forEach((key, value) {
                                      if(key == widget.currentUser) {
                                        print('No send notification here cause it is current user.');
                                      } else if(key == ds['commentatorUID']) {
                                        //Send another notif cause it's the commentator
                                      FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(key.toString())
                                        .collection('notifications')
                                        .doc(_timestampCreation.toString()+widget.currentUser)
                                        .set({
                                          'alreadySeen': false,
                                          'notificationID': _timestampCreation.toString()+widget.currentUser,
                                          'body': 'has replied under your comment 💬',
                                          'currentNotificationsToken': value.toString(),
                                          'lastUserProfilephoto': widget.currentUserPhoto,
                                          'lastUserUID': widget.currentUser,
                                          'lastUserUsername': widget.currentUserUsername,
                                          'postID': widget.postID,
                                          'title': ds['subject'],
                                        }).whenComplete(() {
                                          print('Cloud Firestore : notifications updated for $key');
                                        });
                                      } else {
                                      FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(key.toString())
                                        .collection('notifications')
                                        .doc(_timestampCreation.toString()+widget.currentUser)
                                        .set({
                                          'alreadySeen': false,
                                          'notificationID': _timestampCreation.toString()+widget.currentUser,
                                          'body': 'has replied under a comment 💬',
                                          'currentNotificationsToken': value.toString(),
                                          'lastUserProfilephoto': widget.currentUserPhoto,
                                          'lastUserUID': widget.currentUser,
                                          'lastUserUsername': widget.currentUserUsername,
                                          'postID': widget.postID,
                                          'title': ds['subject'],
                                        }).whenComplete(() {
                                          print('Cloud Firestore : notifications updated for $key');
                                          listFocusNodeController[index].unfocus();
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
                    new Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                      child: new ReplyContainer(
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
                        commentID: ds['timestamp'].toString()+ds['commentatorUsername'],
                        homeContext: widget.homeContext,
                        typeOfPost: widget.typeOfPost,
                      ),
                    ),
                  ],
                ),
                ),
              );
            }),
        );
      },
    );
  }
}