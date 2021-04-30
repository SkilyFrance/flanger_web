import 'dart:html';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/home/subpageCategorie/dialog_profile.dart';
import 'package:flanger_web_version/home/subpageCategorie/post_audioplayer.dart';
import 'package:flanger_web_version/home/subpageCategorie/post_simple.dart';
import 'package:flanger_web_version/home/subpageCategorie/subdialog_audio.dart';
import 'package:flanger_web_version/home/subpageCategorie/subpage_comment.dart';
import 'package:flanger_web_version/home/subpageCategorie/subpage_textEditing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:like_button/like_button.dart';
import '../../bodyEditing.dart';
import '../../requestList.dart';
import '../../subjectEditing.dart';


class SubPageCategorie extends StatefulWidget {

  int indexCategories;
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

  SubPageCategorie({
    Key key,
    this.indexCategories,
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
  SubPageCategorieState createState() => SubPageCategorieState();
}

class SubPageCategorieState extends State<SubPageCategorie> with TickerProviderStateMixin {

  ScrollController _scrollBarController = new ScrollController();
  ScrollController _filterListViewController = new ScrollController();
  ScrollController _testViewController = new ScrollController();
  TabController _tabbarController; 

  //Post variables //
  FocusNode _subjectEditingFocusNode = new FocusNode();
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  TextEditingController _bodyEditingController = new TextEditingController();
  File _imageUploadedToPost;
  String _fileURLPhotoUploaded = 'null';
  bool _photoUploadInProgress = false;
  bool publishingInProgress = false;
  ////////////////
  

  Future<bool> onLikeButtonTapped(bool isLiked, Map<dynamic, dynamic> likedBy, String postID) async {
    if(likedBy.isEmpty || likedBy.containsKey(widget.currentUser) == false) {
      setState(() {
        likedBy[widget.currentUser] = widget.currentUserUsername;
        print('likedBy = ' + likedBy.toString());
      });
      FirebaseFirestore.instance
        .collection(widget.indexCategories == 0
        ? 'Melodies'
        : widget.indexCategories == 1
        ? 'Vocals'
        : widget.indexCategories == 2
        ? 'Sound Design'
        : widget.indexCategories == 3
        ? 'Composition'
        : widget.indexCategories == 4
        ? 'Drums'
        : widget.indexCategories == 5
        ? 'Bass'
        : widget.indexCategories == 6
        ? 'Automation'
        : widget.indexCategories == 7
        ? 'Mixing'
        : widget.indexCategories == 8
        ? 'Mastering'
        : widget.indexCategories == 9
        ? 'Music theory'
        : widget.indexCategories == 10
        ? 'Filling up'
        : 'Melodies')
        .doc(postID)
        .update({
          'likes': FieldValue.increment(1),
          'likedBy': likedBy,
        }).whenComplete(() => print('Cloud firestore : Like +1'));
        return !isLiked;
    } else {
      setState(() {
        likedBy.remove(widget.currentUser);
      });
      FirebaseFirestore.instance
        .collection(widget.indexCategories == 0
        ? 'Melodies'
        : widget.indexCategories == 1
        ? 'Vocals'
        : widget.indexCategories == 2
        ? 'Sound Design'
        : widget.indexCategories == 3
        ? 'Composition'
        : widget.indexCategories == 4
        ? 'Drums'
        : widget.indexCategories == 5
        ? 'Bass'
        : widget.indexCategories == 6
        ? 'Automation'
        : widget.indexCategories == 7
        ? 'Mixing'
        : widget.indexCategories == 8
        ? 'Mastering'
        : widget.indexCategories == 9
        ? 'Music theory'
        : widget.indexCategories == 10
        ? 'Filling up'
        : 'Melodies')
        .doc(postID)
        .update({
          'likes': FieldValue.increment(-1),
          'likedBy': likedBy,
        }).whenComplete(() => print('Cloud firestore : Like -1'));
      return !isLiked;
    }
  }

  Stream<dynamic> _fetchPost;
  Stream<dynamic> fetchPost() {
    return FirebaseFirestore.instance
      .collection(widget.indexCategories == 0
        ? 'Melodies'
        : widget.indexCategories == 1
        ? 'Vocals'
        : widget.indexCategories == 2
        ? 'Sound Design'
        : widget.indexCategories == 3
        ? 'Composition'
        : widget.indexCategories == 4
        ? 'Drums'
        : widget.indexCategories == 5
        ? 'Bass'
        : widget.indexCategories == 6
        ? 'Automation'
        : widget.indexCategories == 7
        ? 'Mixing'
        : widget.indexCategories == 8
        ? 'Mastering'
        : widget.indexCategories == 9
        ? 'Music theory'
        : widget.indexCategories == 10
        ? 'Filling up'
        : 'Melodies')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }

  //Floating button
  AnimationController _controller;
  static const List<IconData> icons = const [CupertinoIcons.pencil, Icons.music_note];

  @override
  void initState() {
    _fetchPost = fetchPost();
    _tabbarController = new TabController(length: 4, vsync: this);
    _controller = new AnimationController(
      vsync: this,duration: const Duration(milliseconds: 100));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                  0.0,
                  1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut
                ),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: widget.indexCategories == 0
                  ? Color(0xff3499FF)
                  : widget.indexCategories == 1
                  ? Color(0xff00B8BA)
                  : widget.indexCategories == 2
                  ? Color(0xff6454F0)
                  : widget.indexCategories == 3
                  ? Color(0xffFF6CAB)
                  : widget.indexCategories == 4
                  ? Color(0xff6EE2F5)
                  : widget.indexCategories == 5
                  ? Color(0xff7BF2E9)
                  : widget.indexCategories == 6
                  ? Color(0xffFF9482)
                  : widget.indexCategories == 7
                  ? Color(0xffF869D5)
                  : widget.indexCategories == 8
                  ? Color(0xffFF5B94)
                  : widget.indexCategories == 9
                  ? Color(0xffFF9897)
                  : widget.indexCategories == 10
                  ? Color(0xffFFCDA5)
                  : Colors.grey[900],
                mini: true,
                child: new Icon(icons[index], color: Colors.white),
                onPressed: () {
                  _controller.reverse();
                  if(index == 1) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                          backgroundColor: Color(0xff21262D),
                          title: new PostAudioPlayer(
                              channelDiscussion: widget.indexCategories == 0
                                ? 'Melodies'
                                : widget.indexCategories == 1
                                ? 'Vocals'
                                : widget.indexCategories == 2
                                ? 'Sound Design'
                                : widget.indexCategories == 3
                                ? 'Composition'
                                : widget.indexCategories == 4
                                ? 'Drums'
                                : widget.indexCategories == 5
                                ? 'Bass'
                                : widget.indexCategories == 6
                                ? 'Automation'
                                : widget.indexCategories == 7
                                ? 'Mixing'
                                : widget.indexCategories == 8
                                ? 'Mastering'
                                : widget.indexCategories == 9
                                ? 'Music theory'
                                : widget.indexCategories == 10
                                ? 'Filling up'
                                : 'Melodies',
                              colorSentButton: widget.indexCategories == 0
                                ? Color(0xff3499FF)
                                : widget.indexCategories == 1
                                ? Color(0xff00B8BA)
                                : widget.indexCategories == 2
                                ? Color(0xff6454F0)
                                : widget.indexCategories == 3
                                ? Color(0xffFF6CAB)
                                : widget.indexCategories == 4
                                ? Color(0xff6EE2F5)
                                : widget.indexCategories == 5
                                ? Color(0xff7BF2E9)
                                : widget.indexCategories == 6
                                ? Color(0xffFF9482)
                                : widget.indexCategories == 7
                                ? Color(0xffF869D5)
                                : widget.indexCategories == 8
                                ? Color(0xffFF5B94)
                                : widget.indexCategories == 9
                                ? Color(0xffFF9897)
                                : widget.indexCategories == 10
                                ? Color(0xffFFCDA5)
                                : Colors.grey[900],
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
                          ),
                        );
                      }
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                          backgroundColor: Color(0xff21262D),
                          title: new PostSimple(
                              channelDiscussion: widget.indexCategories == 0
                                ? 'Melodies'
                                : widget.indexCategories == 1
                                ? 'Vocals'
                                : widget.indexCategories == 2
                                ? 'Sound Design'
                                : widget.indexCategories == 3
                                ? 'Composition'
                                : widget.indexCategories == 4
                                ? 'Drums'
                                : widget.indexCategories == 5
                                ? 'Bass'
                                : widget.indexCategories == 6
                                ? 'Automation'
                                : widget.indexCategories == 7
                                ? 'Mixing'
                                : widget.indexCategories == 8
                                ? 'Mastering'
                                : widget.indexCategories == 9
                                ? 'Music theory'
                                : widget.indexCategories == 10
                                ? 'Filling up'
                                : 'Melodies',
                              colorSentButton: widget.indexCategories == 0
                                ? Color(0xff3499FF)
                                : widget.indexCategories == 1
                                ? Color(0xff00B8BA)
                                : widget.indexCategories == 2
                                ? Color(0xff6454F0)
                                : widget.indexCategories == 3
                                ? Color(0xffFF6CAB)
                                : widget.indexCategories == 4
                                ? Color(0xff6EE2F5)
                                : widget.indexCategories == 5
                                ? Color(0xff7BF2E9)
                                : widget.indexCategories == 6
                                ? Color(0xffFF9482)
                                : widget.indexCategories == 7
                                ? Color(0xffF869D5)
                                : widget.indexCategories == 8
                                ? Color(0xffFF5B94)
                                : widget.indexCategories == 9
                                ? Color(0xffFF9897)
                                : widget.indexCategories == 10
                                ? Color(0xffFFCDA5)
                                : Colors.grey[900],
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
                          ),
                        );
                      }
                    );
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()..add(
          new FloatingActionButton(
            backgroundColor: widget.indexCategories == 0
              ? Color(0xff3499FF)
              : widget.indexCategories == 1
              ? Color(0xff00B8BA)
              : widget.indexCategories == 2
              ? Color(0xff6454F0)
              : widget.indexCategories == 3
              ? Color(0xffFF6CAB)
              : widget.indexCategories == 4
              ? Color(0xff6EE2F5)
              : widget.indexCategories == 5
              ? Color(0xff7BF2E9)
              : widget.indexCategories == 6
              ? Color(0xffFF9482)
              : widget.indexCategories == 7
              ? Color(0xffF869D5)
              : widget.indexCategories == 8
              ? Color(0xffFF5B94)
              : widget.indexCategories == 9
              ? Color(0xffFF9897)
              : widget.indexCategories == 10
              ? Color(0xffFFCDA5)
              : Colors.grey[900],
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? CupertinoIcons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
      ),
      appBar: new AppBar(
        backgroundColor: widget.indexCategories == 0
         ? Color(0xff3499FF)
         : widget.indexCategories == 1
         ? Color(0xff00B8BA)
         : widget.indexCategories == 2
         ? Color(0xff6454F0)
         : widget.indexCategories == 3
         ? Color(0xffFF6CAB)
         : widget.indexCategories == 4
         ? Color(0xff6EE2F5)
         : widget.indexCategories == 5
         ? Color(0xff7BF2E9)
         : widget.indexCategories == 6
         ? Color(0xffFF9482)
         : widget.indexCategories == 7
         ? Color(0xffF869D5)
         : widget.indexCategories == 8
         ? Color(0xffFF5B94)
         : widget.indexCategories == 9
         ? Color(0xffFF9897)
         : widget.indexCategories == 10
         ? Color(0xffFFCDA5)
         : Colors.grey[900],
        iconTheme: new IconThemeData(
          color: Colors.white
        ),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xff0d1117), //Color(0xff121212),
        child: new Scrollbar(
          isAlwaysShown: true,
        child: new SingleChildScrollView(
          padding: EdgeInsets.only(top: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                new Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width*0.20,
                  color: Colors.transparent,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: new FittedBox(
                          fit: BoxFit.fitWidth,
                          child: new Text('About',
                          style: new TextStyle(color: Colors.grey[600],fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),
                      new Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new FittedBox(
                          fit: BoxFit.fitWidth,
                          child: new Text(
                          widget.indexCategories == 0
                          ? 'Melodies'
                          : widget.indexCategories == 1
                          ? 'Vocals'
                          : widget.indexCategories == 2
                          ? 'Sound Design'
                          : widget.indexCategories == 3
                          ? 'Composition'
                          : widget.indexCategories == 4
                          ? 'Drums'
                          : widget.indexCategories == 5
                          ? 'Bass'
                          : widget.indexCategories == 6
                          ? 'Automation'
                          : widget.indexCategories == 7
                          ? 'Mixing'
                          : widget.indexCategories == 8
                          ? 'Mastering'
                          : widget.indexCategories == 9
                          ? 'Music theory'
                          : widget.indexCategories == 10
                          ? 'Filling up'
                          : 'Melodies',
                          style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),
                    ],
                  ),
                ),
            new Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                new Container(
                  height: 160.0,
                  width: 350.0,
                  decoration: new BoxDecoration(
                    color: Color(0xff0d1117),
                    borderRadius: new BorderRadius.circular(10.0),
                    border: new Border.all(
                      width: 1.0,
                      color: Color(0xff21262D),
                    ),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Container(
                        height: 60.0,
                        decoration: new BoxDecoration(
                          color: Color(0xff121212).withOpacity(0.3),
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Padding(
                            padding: EdgeInsets.only(left: 0.0),
                          child: new Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: new BoxDecoration(
                              color: Colors.grey[600],
                              shape: BoxShape.circle,
                            ),
                            child: new ClipOval(
                              child: widget.currentUserPhoto != null
                               ? new Image.network(widget.currentUserPhoto, fit: BoxFit.cover)
                               : new Container(),
                            ),
                          ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 0.0),
                          child: new Text(
                            widget.currentUserUsername != null
                            ? widget.currentUserUsername
                            : 'Unknown',
                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: new Container(
                              height: 30.0,
                              width: 30.0,
                            child: new ClipRRect(
                            child: new Image.asset('web/icons/goldMedal.png', fit: BoxFit.cover),
                            ),
                            ),
                          ),
                        ],
                      ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Text('Level',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: new Text('Newbie',
                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Text('Point',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: new Text('38',
                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Text('Next level',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: new Tooltip(
                                    message: 'Next level point : 150',
                                    textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
                                  child: new Text('Young Jedi',
                                  style: new TextStyle(color:widget.indexCategories == 0
                                  ? Color(0xff3499FF)
                                  : widget.indexCategories == 1
                                  ? Color(0xff00B8BA)
                                  : widget.indexCategories == 2
                                  ? Color(0xff6454F0)
                                  : widget.indexCategories == 3
                                  ? Color(0xffFF6CAB)
                                  : widget.indexCategories == 4
                                  ? Color(0xff6EE2F5)
                                  : widget.indexCategories == 5
                                  ? Color(0xff7BF2E9)
                                  : widget.indexCategories == 6
                                  ? Color(0xffFF9482)
                                  : widget.indexCategories == 7
                                  ? Color(0xffF869D5)
                                  : widget.indexCategories == 8
                                  ? Color(0xffFF5B94)
                                  : widget.indexCategories == 9
                                  ? Color(0xffFF9897)
                                  : widget.indexCategories == 10
                                  ? Color(0xffFFCDA5)
                                  : Colors.grey[900],
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 20.0),
                child: new Container(
                  height: 160.0,
                  width: 350.0,
                  decoration: new BoxDecoration(
                    color: Color(0xff0d1117),
                    borderRadius: new BorderRadius.circular(10.0),
                    border: new Border.all(
                      width: 1.0,
                      color: Color(0xff21262D),
                    ),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Container(
                        height: 60.0,
                        width: 250,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: new BorderRadius.circular(5.0)
                        ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Text('Higher contributor',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                   child: new Tooltip(
                                    message: 'See profile',
                                    textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
                                  child: new TextButton(
                                    onPressed: () {print('Go to profile');},
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  new Text('Karl G',
                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new Container(
                                      height: 20.0,
                                      width: 20.0,
                                      child: new ClipRRect(
                                      child: new Image.asset('web/icons/ninjaMedal.png', fit: BoxFit.cover),
                                    ),
                                    ),
                                    ),
                                    ],
                                    ),
                                    ),
                                   ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.only(top: 7.0),
                                child: new Text('All contributors',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: new Tooltip(
                                    message: 'See all contributors',
                                    textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
                                  child: new TextButton(
                                    onPressed: (){ print('See all contributors');},
                                  child: new Text('234',
                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Text('Average level',
                                style: new TextStyle(color: Colors.grey),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: new Tooltip(
                                    message: 'Next level point : 150',
                                    textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
                                  child: new Text('Ninja',
                                  style: new TextStyle(color:widget.indexCategories == 0
                                  ? Color(0xff3499FF)
                                  : widget.indexCategories == 1
                                  ? Color(0xff00B8BA)
                                  : widget.indexCategories == 2
                                  ? Color(0xff6454F0)
                                  : widget.indexCategories == 3
                                  ? Color(0xffFF6CAB)
                                  : widget.indexCategories == 4
                                  ? Color(0xff6EE2F5)
                                  : widget.indexCategories == 5
                                  ? Color(0xff7BF2E9)
                                  : widget.indexCategories == 6
                                  ? Color(0xffFF9482)
                                  : widget.indexCategories == 7
                                  ? Color(0xffF869D5)
                                  : widget.indexCategories == 8
                                  ? Color(0xffFF5B94)
                                  : widget.indexCategories == 9
                                  ? Color(0xffFF9897)
                                  : widget.indexCategories == 10
                                  ? Color(0xffFFCDA5)
                                  : Colors.grey[900],
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ),
                ],
              ),
            ),
            /*new Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width*0.60,
                decoration: new BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                  child: new TabBar(
                    labelStyle: new TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Colors.grey[800],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: widget.indexCategories == 0
                      ? Color(0xff3499FF)
                      : widget.indexCategories == 1
                      ? Color(0xff00B8BA)
                      : widget.indexCategories == 2
                      ? Color(0xff6454F0)
                      : widget.indexCategories == 3
                      ? Color(0xffFF6CAB)
                      : widget.indexCategories == 4
                      ? Color(0xff6EE2F5)
                      : widget.indexCategories == 5
                      ? Color(0xff7BF2E9)
                      : widget.indexCategories == 6
                      ? Color(0xffFF9482)
                      : widget.indexCategories == 7
                      ? Color(0xffF869D5)
                      : widget.indexCategories == 8
                      ? Color(0xffFF5B94)
                      : widget.indexCategories == 9
                      ? Color(0xffFF9897)
                      : widget.indexCategories == 10
                      ? Color(0xffFFCDA5)
                      : Colors.grey[900],
                    controller: _tabbarController,
                    tabs: [
                      new Tab(text: 'Most recent'),
                      new Tab(text: 'Most liked this week'),
                      new Tab(text: 'Most liked ever'),
                      new Tab(text: 'Higher contributor'),
                    ]
                  ),
              ),
              ),*/
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new Container(
                  width: MediaQuery.of(context).size.width*0.60,
                  child: new StreamBuilder(
                    stream: _fetchPost,
                    builder: (BuildContext context, snapshot){
                      if(snapshot.hasError || !snapshot.hasData) {
                        return new Container(
                          height: 200.0,
                          width: 300.0,
                          child: new Center(
                            child: new CupertinoActivityIndicator(
                              radius: 20.0,
                              animating: true,
                            ),
                          ),
                        );
                      }
                      return new Container(
                      child: new ListView.builder(
                        padding: EdgeInsets.only(top: 40.0, bottom: 80.0),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        controller: _testViewController,
                        itemBuilder: (BuildContext contex, int postIndex) {
                        var ds = snapshot.data.docs[postIndex];
                       // print('Likedby = ' + ds['likedBy'].containsKey('00').toString());
                        TextEditingController commentTextEditing = new TextEditingController();
                        FocusNode commentFocusNode = new FocusNode();
                        return new Padding(
                          padding: EdgeInsets.only(top: 30.0),
                        child: new Material(
                          elevation: 20.0,
                          borderRadius: new BorderRadius.circular(10.0),
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: Color(0xff0d1117),
                            borderRadius: new BorderRadius.circular(10.0),
                            border: new Border.all(
                              width: 1.0,
                              color: Color(0xff21262D),
                            ),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Color(0xff21262D),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                          ),
                          constraints: new BoxConstraints(
                            minHeight: 600.0,
                          ),
                          width: MediaQuery.of(context).size.width*0.60,
                          child: new Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                height: 50.0,
                                child: new Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Container(
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                         new Tooltip(
                                          message: 'See profile',
                                          textStyle: new  TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.normal),
                                         child: new InkWell(
                                           onTap: () {
                                             showDialog(
                                               context: context, 
                                               builder: (context) {
                                                 return new AlertDialog(
                                                   backgroundColor: Color(0xff21262D),
                                                   title: new DialogProfile(
                                                     adminUID: ds['adminUID'],
                                                     adminProfilephoto: ds['adminProfilephoto'],
                                                     adminUsername: ds['adminUsername'],
                                                   ),
                                                 );
                                              });
                                           },
                                         child: new Container(
                                           height: 45.0,
                                           width: 45.0,
                                           decoration: new BoxDecoration(
                                             color: Colors.grey[900],
                                             shape: BoxShape.circle,
                                           ),
                                           child: new ClipOval(
                                             child: ds['adminProfilephoto']  != null
                                           ? new Image.network(ds['adminProfilephoto'], fit: BoxFit.cover)
                                           : new Container(),
                                           ),
                                         ))),
                                         new Padding(
                                           padding: EdgeInsets.only(left: 5.0, top: 5.0),
                                           child: new Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               new Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [
                                                new Text(ds['adminUsername'] != null
                                                ? ds['adminUsername']
                                                : 'Username',
                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                ),
                                                 ],
                                               ),
                                               new Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [
                                                  new Padding(
                                                    padding: EdgeInsets.only(top: 5.0),
                                                  child: new Container(
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                    new Padding(
                                                      padding: EdgeInsets.only(left: 5.0),
                                                      child: new Text('Lvl',
                                                      style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    new Padding(
                                                      padding: EdgeInsets.only(left: 5.0),
                                                      child: new Text('Ninja',
                                                      style: new TextStyle(color: Colors.deepPurpleAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    ],
                                                  ),
                                                  ),
                                                  ),
                                                 ],
                                               ),
                                             ],
                                           ),
                                         ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new Text(
                                        ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 1
                                        ? 'few sec ago'
                                        : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes < 60
                                        ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes.toString() + ' min ago'
                                        : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inMinutes >= 60
                                        && ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours <= 24
                                        ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours.toString() + ' hours ago'
                                        : ds['timestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inHours >= 24
                                        ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds['timestamp'])).inDays.toString() + ' days ago'
                                        : '',
                                        style:  new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal,
                                        height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: new InkWell(
                                  onTap: () {
                                  },
                                  child: new Container(
                                    constraints: new BoxConstraints(
                                      minHeight: 500.0,
                                    ),
                                    width: MediaQuery.of(context).size.width*0.60,
                                    decoration: new BoxDecoration(
                                      color: Color(0xff0d1117), //Color(0xff21262D), //Colors.grey[900],
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Container(
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                            new Padding(
                                                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                                                child: new Text(
                                                  ds['subject'] != null
                                                  ? ds['subject']
                                                  : '',
                                                  style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,
                                                  wordSpacing: 0.5,
                                                  letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                                                child: new Text(
                                                  ds['body'] != null
                                                  ? ds['body']
                                                  : '',
                                                  textAlign: TextAlign.left,
                                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal,
                                                  wordSpacing: 0.5,
                                                  letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                                          child: ds['withTrack'] != null && ds['trackURL'] != null
                                          ? new Tooltip(
                                            message: 'Click to play',
                                            textStyle: new TextStyle(color: Colors.white, fontSize: 12.0),
                                            child: new InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context, 
                                                  builder: (context){
                                                    return new AlertDialog(
                                                      backgroundColor: Color(0xff21262D),
                                                      title: new Container(
                                                        child: new AudioPlayerContainer(
                                                          channelDiscussion: widget.indexCategories == 0
                                                            ? 'Melodies'
                                                            : widget.indexCategories == 1
                                                            ? 'Vocals'
                                                            : widget.indexCategories == 2
                                                            ? 'Sound Design'
                                                            : widget.indexCategories == 3
                                                            ? 'Composition'
                                                            : widget.indexCategories == 4
                                                            ? 'Drums'
                                                            : widget.indexCategories == 5
                                                            ? 'Bass'
                                                            : widget.indexCategories == 6
                                                            ? 'Automation'
                                                            : widget.indexCategories == 7
                                                            ? 'Mixing'
                                                            : widget.indexCategories == 8
                                                            ? 'Mastering'
                                                            : widget.indexCategories == 9
                                                            ? 'Music theory'
                                                            : widget.indexCategories == 10
                                                            ? 'Filling up'
                                                            : 'Melodies',
                                                          currentUser: widget.currentUser,
                                                          currentUserUsername: widget.currentUserUsername,
                                                          currentUserPhoto: widget.currentUserPhoto,
                                                          currentNotificationsToken: widget.currentNotificationsToken,
                                                         colorButton: widget.indexCategories == 0
                                                        ? Color(0xff3499FF)
                                                        : widget.indexCategories == 1
                                                        ? Color(0xff00B8BA)
                                                        : widget.indexCategories == 2
                                                        ? Color(0xff6454F0)
                                                        : widget.indexCategories == 3
                                                        ? Color(0xffFF6CAB)
                                                        : widget.indexCategories == 4
                                                        ? Color(0xff6EE2F5)
                                                        : widget.indexCategories == 5
                                                        ? Color(0xff7BF2E9)
                                                        : widget.indexCategories == 6
                                                        ? Color(0xffFF9482)
                                                        : widget.indexCategories == 7
                                                        ? Color(0xffF869D5)
                                                        : widget.indexCategories == 8
                                                        ? Color(0xffFF5B94)
                                                        : widget.indexCategories == 9
                                                        ? Color(0xffFF9897)
                                                        : widget.indexCategories == 10
                                                        ? Color(0xffFFCDA5)
                                                        : Colors.grey[900],
                                                         index: postIndex,
                                                         postID: ds['postID'],
                                                         timestamp: ds['timestamp'],
                                                         adminUID: ds['adminUID'],
                                                         adminUsername: ds['adminUsername'],
                                                         subject: ds['subject'],
                                                         body: ds['subject'],
                                                         trackDuration: ds['trackDuration'],
                                                         trackURL: ds['trackURL'],
                                                         //comments
                                                         comments: ds['comments'],
                                                         commentedBy: ds['commentedBy'],
                                                         //reactedBy
                                                         reactedBy: ds['reactedBy'],
                                                         //AudioPlayerVariables
                                                         postContainerTrackDivisions: ds['divisions'],
                                                         postContainerTrackStartParticular: ds['startParticularPart'],
                                                         postContainerTrackEndParticular: ds['endParticularPart'],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              },
                                              child: new Container(
                                                height: 100.0,
                                                //width: 200.0,
                                                decoration: new BoxDecoration(
                                                  color: Color(0xff0d1117),
                                                  borderRadius: new BorderRadius.circular(10.0),
                                                  border: new Border.all(
                                                    width: 1.0,
                                                    color: Color(0xff21262D),
                                                    ),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: widget.indexCategories == 0
                                                        ? Color(0xff3499FF)
                                                        : widget.indexCategories == 1
                                                        ? Color(0xff00B8BA)
                                                        : widget.indexCategories == 2
                                                        ? Color(0xff6454F0)
                                                        : widget.indexCategories == 3
                                                        ? Color(0xffFF6CAB)
                                                        : widget.indexCategories == 4
                                                        ? Color(0xff6EE2F5)
                                                        : widget.indexCategories == 5
                                                        ? Color(0xff7BF2E9)
                                                        : widget.indexCategories == 6
                                                        ? Color(0xffFF9482)
                                                        : widget.indexCategories == 7
                                                        ? Color(0xffF869D5)
                                                        : widget.indexCategories == 8
                                                        ? Color(0xffFF5B94)
                                                        : widget.indexCategories == 9
                                                        ? Color(0xffFF9897)
                                                        : widget.indexCategories == 10
                                                        ? Color(0xffFFCDA5)
                                                        : Colors.grey[900],
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: new Center(
                                                  child: new Icon(CupertinoIcons.play_circle_fill, color: Colors.white, size: 30.0,
                                                ),
                                                ),
                                              ),
                                              ),
                                            )
                                          : new Container(),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                        child: ds['withImage'] == true && ds['imageURL'] != null
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
                                          height: 400.0,
                                          width: MediaQuery.of(context).size.width*0.60,
                                          child: new Image.network(ds['imageURL'], fit: BoxFit.cover),
                                        ),
                                        ),
                                        )
                                        : new Container(
                                          height: 400.0,
                                          width: MediaQuery.of(context).size.width*0.60,
                                          decoration: new BoxDecoration(
                                            gradient: new LinearGradient(
                                              colors: widget.indexCategories == 0
                                              ? [Color(0xff3499FF), Color(0xff3A3985)]
                                              : widget.indexCategories == 1
                                              ? [Color(0xff00B8BA), Color(0xff6454F0)]
                                              : widget.indexCategories == 2
                                              ? [Color(0xff6454F0), Color(0xffF869D5)]
                                              : widget.indexCategories == 3
                                              ? [Color(0xffFF6CAB), Color(0xff7366FF)]
                                              : widget.indexCategories == 4
                                              ? [Color(0xff6EE2F5), Color(0xff6454F0)]
                                              : widget.indexCategories == 5
                                              ? [Color(0xff7BF2E9), Color(0xffB65EBA)]
                                              : widget.indexCategories == 6
                                              ? [Color(0xffFF9482), Color(0xff7D77FF)]
                                              : widget.indexCategories == 7
                                              ? [Color(0xffF869D5), Color(0xff5650DE)]
                                              : widget.indexCategories == 8
                                              ? [Color(0xffFF5B94), Color(0xff8441A4)]
                                              : widget.indexCategories == 9
                                              ? [Color(0xffFF9897), Color(0xffF650A0)]
                                              : widget.indexCategories == 10
                                              ? [Color(0xffFFCDA5), Color(0xffEE4D5F)]
                                              : Colors.grey[900],
                                              )
                                          ),
                                          child: new Center(
                                            child: new Padding(
                                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                            child: new Text(
                                              ds['subject'] != null
                                              ? ds['subject']
                                              : '',
                                              style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,
                                              wordSpacing: 0.5,
                                              letterSpacing: 0.5,
                                              ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: new Container(
                                            constraints: new BoxConstraints(
                                              minHeight: 60.0
                                            ),
                                            width: MediaQuery.of(context).size.width*0.60,
                                            decoration: new BoxDecoration(
                                              color: Color(0xff0d1117), //Color(0xff21262D), //Colors.grey[900],
                                              borderRadius: new BorderRadius.only(
                                                bottomLeft: Radius.circular(10.0),
                                                bottomRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Container(
                                                  width: MediaQuery.of(context).size.width*0.60,
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      new Padding(
                                                        padding: EdgeInsets.only(left: 20.0),
                                                        child: new Material(
                                                          elevation: 20.0,
                                                          borderRadius: new BorderRadius.circular(30.0),
                                                        child: new Container(
                                                          decoration: new BoxDecoration(
                                                            color: Color(0xff0d1117), // Color(0xff121212),
                                                            borderRadius: new BorderRadius.circular(30.0),
                                                            border: Border.all(
                                                              width: 1.0,
                                                              color: Color(0xff21262D),
                                                            ),
                                                          ),
                                                          padding: EdgeInsets.all(8.0),
                                                          child: new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                            new LikeButton(
                                                              onTap: (isLiked) {
                                                                return onLikeButtonTapped(
                                                                  isLiked,
                                                                  ds['likedBy'],
                                                                  ds['postID'],
                                                                );
                                                              },
                                                              size: 35.0,
                                                              circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                                              bubblesColor: new BubblesColor(
                                                                dotPrimaryColor: Colors.cyanAccent,
                                                                dotSecondaryColor: Colors.purpleAccent
                                                              ),
                                                              likeBuilder: (bool isLiked) {
                                                                return Icon(
                                                                  CupertinoIcons.heart_circle_fill,
                                                                  color: ds['likedBy'] != null && ds['likedBy'].containsKey(widget.currentUser) == true ? Colors.cyanAccent : Colors.grey,
                                                                  size: 35.0,
                                                                );
                                                              },
                                                            ),
                                                          new Padding(
                                                            padding: EdgeInsets.only(left: 10.0),
                                                            child: new RichText(
                                                              text: new TextSpan(
                                                                text: 'Liked by ',
                                                                style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                                                children: [
                                                                  new TextSpan(
                                                                    text: !ds['likedBy'].isEmpty && ds['likedBy'].length < 3
                                                                    ? ds['likedBy'].values.toList().join(', ').toString()
                                                                    : !ds['likedBy'].isEmpty && ds['likedBy'].length >= 3 && ds['likedBy'].containsKey(widget.currentUser) == true
                                                                    ? ds['likedBy'][widget.currentUser].toString() 
                                                                    + ', ' + ds['likedBy'].values.elementAt(1).toString() 
                                                                    + ', ' + (ds['likedBy'].length-2).toString() 
                                                                    + ' others'
                                                                    : !ds['likedBy'].isEmpty && ds['likedBy'].length >= 3 && ds['likedBy'].containsKey(widget.currentUser) == false
                                                                    ? ds['likedBy'].values.elementAt(0).toString() 
                                                                    + ', ' + ds['likedBy'].values.elementAt(1).toString() 
                                                                    + ', ' + (ds['likedBy'].length-2).toString() 
                                                                    + ' others'
                                                                    : 'nobody yet.',
                                                                    style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          ],
                                                          ),
                                                        ),
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: EdgeInsets.only(left: 20.0),
                                                        child: new Material(
                                                          elevation: 20.0,
                                                          borderRadius: new BorderRadius.circular(30.0),
                                                        child: new Container(
                                                          decoration: new BoxDecoration(
                                                            color: Color(0xff0d1117), // Color(0xff121212),
                                                            borderRadius: new BorderRadius.circular(30.0),
                                                            border: Border.all(
                                                              width: 1.0,
                                                              color: Color(0xff21262D),
                                                            ),
                                                          ),
                                                          padding: EdgeInsets.all(17.0),
                                                        child: new RichText(
                                                          text: new TextSpan(
                                                            text: ds['comments'] != null
                                                            ? ds['comments'].toString()
                                                            : '',
                                                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                                            children: [
                                                              new TextSpan(
                                                                text: ' comments',
                                                                style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 5.0, left: 40.0, right: 40.0),
                                          child: new SubPageTextEditing(
                                            currentUser: widget.currentUser,
                                            currentUserUsername: widget.currentUserUsername,
                                            currentUserPhoto: widget.currentUserPhoto,
                                            currentNotificationsToken: widget.currentNotificationsToken,
                                            adminUID: ds['adminUID'],
                                            adminProfilephoto: ds['adminProfilephoto'],
                                            adminUsername: ds['adminUsername'],
                                            adminNotificationsToken: ds['adminNotificationsToken'],
                                            currentTextEditingController: commentTextEditing,
                                            currentFocusNode: commentFocusNode,
                                            index: postIndex,
                                            postID: ds['postID'],
                                            timestamp: ds['timestamp'],
                                            subject: ds['subject'],
                                            likes: ds['likes'],
                                            likedBy: ds['likedBy'],
                                            comments: ds['comments'],
                                            commentedBy: ds['commentedBy'],
                                            reactedBy: ds['reactedBy'],
                                            savedBy: ds['savedBy'],
                                            channelDiscussion: widget.indexCategories == 0
                                            ? 'Melodies'
                                            : widget.indexCategories == 1
                                            ? 'Vocals'
                                            : widget.indexCategories == 2
                                            ? 'Sound Design'
                                            : widget.indexCategories == 3
                                            ? 'Composition'
                                            : widget.indexCategories == 4
                                            ? 'Drums'
                                            : widget.indexCategories == 5
                                            ? 'Bass'
                                            : widget.indexCategories == 6
                                            ? 'Automation'
                                            : widget.indexCategories == 7
                                            ? 'Mixing'
                                            : widget.indexCategories == 8
                                            ? 'Mastering'
                                            : widget.indexCategories == 9
                                            ? 'Music theory'
                                            : widget.indexCategories == 10
                                            ? 'Filling up'
                                            : 'Melodies',
                                            colorSentButton: widget.indexCategories == 0
                                            ? Color(0xff3499FF)
                                            : widget.indexCategories == 1
                                            ? Color(0xff00B8BA)
                                            : widget.indexCategories == 2
                                            ? Color(0xff6454F0)
                                            : widget.indexCategories == 3
                                            ? Color(0xffFF6CAB)
                                            : widget.indexCategories == 4
                                            ? Color(0xff6EE2F5)
                                            : widget.indexCategories == 5
                                            ? Color(0xff7BF2E9)
                                            : widget.indexCategories == 6
                                            ? Color(0xffFF9482)
                                            : widget.indexCategories == 7
                                            ? Color(0xffF869D5)
                                            : widget.indexCategories == 8
                                            ? Color(0xffFF5B94)
                                            : widget.indexCategories == 9
                                            ? Color(0xffFF9897)
                                            : widget.indexCategories == 10
                                            ? Color(0xffFFCDA5)
                                            : Colors.grey[900],
                                          ),
                                        ),
                                       /* new Padding(
                                          padding: EdgeInsets.only(top: 5.0, left: 40.0, right: 40.0),
                                          child: new Divider(
                                            height: 1.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),*/
                                        new Padding(
                                          padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                                          child: new SubPageComment(
                                            channelDiscussion: widget.indexCategories == 0
                                            ? 'Melodies'
                                            : widget.indexCategories == 1
                                            ? 'Vocals'
                                            : widget.indexCategories == 2
                                            ? 'Sound Design'
                                            : widget.indexCategories == 3
                                            ? 'Composition'
                                            : widget.indexCategories == 4
                                            ? 'Drums'
                                            : widget.indexCategories == 5
                                            ? 'Bass'
                                            : widget.indexCategories == 6
                                            ? 'Automation'
                                            : widget.indexCategories == 7
                                            ? 'Mixing'
                                            : widget.indexCategories == 8
                                            ? 'Mastering'
                                            : widget.indexCategories == 9
                                            ? 'Music theory'
                                            : widget.indexCategories == 10
                                            ? 'Filling up'
                                            : 'Melodies',
                                            colorSentButton: widget.indexCategories == 0
                                            ? Color(0xff3499FF)
                                            : widget.indexCategories == 1
                                            ? Color(0xff00B8BA)
                                            : widget.indexCategories == 2
                                            ? Color(0xff6454F0)
                                            : widget.indexCategories == 3
                                            ? Color(0xffFF6CAB)
                                            : widget.indexCategories == 4
                                            ? Color(0xff6EE2F5)
                                            : widget.indexCategories == 5
                                            ? Color(0xff7BF2E9)
                                            : widget.indexCategories == 6
                                            ? Color(0xffFF9482)
                                            : widget.indexCategories == 7
                                            ? Color(0xffF869D5)
                                            : widget.indexCategories == 8
                                            ? Color(0xffFF5B94)
                                            : widget.indexCategories == 9
                                            ? Color(0xffFF9897)
                                            : widget.indexCategories == 10
                                            ? Color(0xffFFCDA5)
                                            : Colors.grey[900],
                                            currentUser: widget.currentUser,
                                            currentUserUsername: widget.currentUserUsername,
                                            currentUserPhoto: widget.currentUserPhoto,
                                            currentNotificationsToken: widget.currentNotificationsToken,
                                            postID: ds['postID'],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                        ),
                        ),
                        );
                        })
                      );
                  }),

              ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}