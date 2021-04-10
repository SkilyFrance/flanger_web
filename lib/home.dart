import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flanger_web_version/bodyEditing.dart';
import 'package:flanger_web_version/commentContainer.dart';
import 'package:flanger_web_version/postContainer.dart';
import 'package:flanger_web_version/requestList.dart';
import 'package:flanger_web_version/subjectEditing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {

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

  HomePage({
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
    }) : super(key: key);


  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Stream<dynamic> _fetchAllPosts;
  ScrollController _listPostScrollController = new ScrollController();
  List<bool> listIsExpanded = [];
  List<TextEditingController> listTextEditingController = [];
  List<FocusNode> listFocusNodeController = [];
  ScrollController _feedScrollController = new ScrollController();


  //PostEditing controller
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _subjectEditingFocusNode = new FocusNode();
  TextEditingController _bodyEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  int categoryPosted = 0;
  bool _lackOfSubjectOrBody = false;
  bool publishingInProgress = false;

  bool _searchingInProgress = false;
  

  Stream<dynamic> fetchAllPosts() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  initializationTimer() {
  return Timer(Duration(seconds: 10), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }


@override
  void initState() {
    _fetchAllPosts = fetchAllPosts();
    print('soundCloud = ' + widget.currentSoundCloud);
    print('Spotify = ' + widget.currentSpotify);
    _feedScrollController = new ScrollController();
    _listPostScrollController = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
        showDialog(
              context: context,
              builder: (context) {
                return new StatefulBuilder(
                  builder: (contextDialog, dialogSetState) {
                    return AlertDialog(
                    backgroundColor: Color(0xff121212),
                      title: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Center(
                            child: new Container(
                              child: new Text('New post',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Center(
                              child: new Text('Your post is about',
                              style: new TextStyle(color: Colors.grey[800], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Container(
                            child: new CupertinoSlidingSegmentedControl(
                              thumbColor: Colors.deepPurpleAccent,
                              backgroundColor: Colors.grey[900],
                              children: <int, Widget>{
                                0: new Padding(
                                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                child: new Container(
                                  child: new Text("Issue 💥",
                                  style: new TextStyle(color: categoryPosted == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                                1: new Padding(
                                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                  child: new Container(
                                  child:  new Text("Tip 💡",
                                  style: new TextStyle(color: categoryPosted == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                                2: new Padding(
                                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                  child: new Container(
                                  child:  new Text("Project 🚀",
                                  style: new TextStyle(color: categoryPosted == 2 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ),
                              },
                              groupValue: categoryPosted,
                              onValueChanged: (value) {
                                dialogSetState(() {
                                categoryPosted = value;
                                });
                            }),
                            ),
                            ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                              child: new Text('Subject',
                              style: new TextStyle(color: Colors.grey[800], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                            child: new SubjectEditingController(
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
                              currentFocusNode: _subjectEditingFocusNode,
                              currentTextEditingController: _subjectEditingController,
                          ),
                        ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                              child: new Text('Body',
                              style: new TextStyle(color: Colors.grey[800], fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                            child: new BodyEditingController(
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
                              currentFocusNode: _bodyEditingFocusNode,
                              currentTextEditingController: _bodyEditingController,
                          ),
                        ),
                        _lackOfSubjectOrBody == true
                        ? new Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: new Text('Subject & body are necessary.',
                          style: new TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.normal),
                          ),
                          )
                        : new Container(),
                        ],
                      ),
                      content: 
                      new Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: new InkWell(
                        onTap: () {
                          if(_subjectEditingController.text.length > 3 && _bodyEditingController.text.length > 3 && categoryPosted != null) {
                          publicationRequest(
                            widget.currentUser, 
                            widget.currentUserUsername, 
                            widget.currentUserPhoto, 
                            widget.currentNotificationsToken, 
                            _bodyEditingController.value.text, 
                            _subjectEditingController.value.text, 
                            dialogSetState, 
                            publishingInProgress, 
                            context, 
                            _subjectEditingController,
                            _bodyEditingController, 
                            categoryPosted);
                          } else {
                            dialogSetState((){
                              _lackOfSubjectOrBody = true;
                            });
                          }
                        },
                        child: new Container(
                          height: 45.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(40.0),
                            border: new Border.all(
                              width: 1.0,
                              color: Colors.deepPurpleAccent,
                            )
                          ),
                          child: new Center(
                            child: publishingInProgress == false
                            ? new Text('Publish',
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                            )
                            : new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  });
              } 
            ).whenComplete(() {
              setState(() {
                publishingInProgress = false;
                _lackOfSubjectOrBody = false;
                categoryPosted = 0;
              });
            });
        },
        child: new Icon(CupertinoIcons.bolt_horizontal_circle_fill, color: Colors.white),
        ),
      backgroundColor: Color(0xff121212),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
        child: new GestureDetector(
          onTap: (){
            print('ok');
            FocusScope.of(context).requestFocus(new FocusNode());
            },
        child: new SingleChildScrollView(
          controller: _feedScrollController,
          scrollDirection: Axis.vertical,
          physics: new AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('Home',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Your feed is automatically up to date.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.check_mark_circled, color: Colors.greenAccent, size: 20.0),
                    ),
                  ],
                )
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Center(
                  child: new Container(
                    height: 40.0,
                    width: 400.0,
                    color: Colors.transparent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: Color(0xff7360FC),
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Issues',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        ),
                        new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: Color(0xff62DDF9),
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Tips',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        ),
                        new Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                             width: 2.0,
                             color: Color(0xffBF88FF),
                            ),
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Center(
                          child: new Text('Projects',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal)
                          )),
                        ),
                      ],
                    )
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Container(
                  constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 850.0
                  ),
                child: new StreamBuilder(
                  stream: _fetchAllPosts,
                  builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                      );
                      }
                      if(snapshot.hasError) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
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
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
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
                      return new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          controller: _listPostScrollController,
                          physics: new NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var ds = snapshot.data.docs[index];
                            List<dynamic> arrayOfLikes = ds['likedBy'];
                            List<dynamic> arrayOfFires = ds['firedBy'];
                            List<dynamic> arrayOfRockets = ds['rocketedBy'];
                            List<dynamic> arrayOfSavedBy = ds['savedBy'];
                            listIsExpanded.add(false);
                            listTextEditingController.add(TextEditingController());
                            listFocusNodeController.add(FocusNode());

                            return new Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new PostContainer(
                                    comesFromHome: true,
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
                                    listIsExpanded: listIsExpanded,
                                    index: index,
                                    listTextEditingController: listTextEditingController,
                                    listFocusNodeController: listFocusNodeController,
                                    postID: ds['postID'],
                                    typeOfPost: ds['typeOfPost'],
                                    timestamp: ds['timestamp'],
                                    adminUID: ds['adminUID'],
                                    subject: ds['subject'],
                                    body: ds['body'],
                                    likes: ds['likes'],
                                    likedBy: arrayOfLikes,
                                    fires: ds['fires'],
                                    firedBy: arrayOfFires,
                                    rockets: ds['rockets'],
                                    rocketedBy: arrayOfRockets,
                                    comments: ds['comments'],
                                    commentedBy: ds['commentedBy'],
                                    reactedBy: ds['reactedBy'],
                                    savedBy: arrayOfSavedBy,
                                    adminProfilephoto: ds['adminProfilephoto'],
                                    adminUsername: ds['adminUsername'],
                                    adminNotificationsToken: ds['adminNotificationsToken'],
                                  ),
                                ],
                              ),
                            );
                          }),
                      );
                      }),
                      ),
                     ),
                  ],
                ),
              ),
            ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: _searchingInProgress == true
              ? new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     new Container(
                        height: MediaQuery.of(context).size.height*0.50,
                        width: MediaQuery.of(context).size.width*0.60,
                        color: Colors.transparent,
                        child: new Center(
                          child: new Container(
                            height: 150.0,
                            width: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: new BorderRadius.circular(5.0),
                            ),
                            child: new Center(
                              child: new Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                                child: new Stack(
                                  children: [
                                    new Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: new ClipOval(
                                        child: new Image.asset('web/icons/flanger512px.png', fit: BoxFit.cover),
                                      ),
                                    ),
                                    new Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: new Center(
                                      child: TweenAnimationBuilder<double>(
                                          tween: Tween<double>(begin: 0.0, end: 1),
                                          duration: const Duration(milliseconds: 10000),
                                          curve: Curves.linear,
                                          builder: (context, value, _) => 
                                          new  CircularProgressIndicator(
                                            value: value,
                                            strokeWidth: 1.5,
                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent
                                          ),
                                        ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : new Container(),
            ),
          ],
        ),
      ),
    );
  }
}