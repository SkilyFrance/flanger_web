import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/commentContainer.dart';
import 'package:flanger_web_version/postContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SavedPostPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String notificationsToken;


  SavedPostPage({
    Key key, 
    this.currentUser, 
    this.currentUserUsername,
    this.currentUserPhoto,
    this.notificationsToken,
    }) : super(key: key);


  @override
  SavedPostPageState createState() => SavedPostPageState();
}


class SavedPostPageState extends State<SavedPostPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Stream<dynamic> _fetchAllSavedPosts;
  ScrollController _listPostScrollController = ScrollController();
  List<bool> listIsExpanded = [];
  List<TextEditingController> listTextEditingController = [];

  //PostEditing controller
  TextEditingController _subjectEditingController = new TextEditingController();
  FocusNode _subjectEditingFocusNode = new FocusNode();
  TextEditingController _bodyEditingController = new TextEditingController();
  FocusNode _bodyEditingFocusNode = new FocusNode();
  int categoryPosted = 0;

  bool _searchingInProgress = false;
  

  Stream<dynamic> fetchAllSavedPosts() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
    return FirebaseFirestore.instance
      .collection('posts')
      .where('savedBy', arrayContains: widget.currentUser)
      //.orderBy('timestamp', descending: true)
      .snapshots();
  }

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

  initializationTimer() {
  return Timer(Duration(seconds: 10), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }


@override
  void initState() {
    _fetchAllSavedPosts = fetchAllSavedPosts();
    getCurrentSoundCloud();
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
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('Saved post',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Add here all posts you want to track.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.eye, color: Colors.greenAccent, size: 20.0),
                    ),
                  ],
                )
              ),
              /*new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                child: new Container(
                  height: 90.0,
                  width: MediaQuery.of(context).size.width*0.70,
                  constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 700.0,
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     new Padding(
                       padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Container(
                            constraints: new BoxConstraints(
                              minWidth: 150.0,
                              maxWidth: 500.0,
                            ),
                          decoration: new BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        child: new TextField(
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          style: new TextStyle(color: Colors.white, fontSize: 13.0),
                          keyboardType: TextInputType.text,
                          scrollPhysics: new ScrollPhysics(),
                          keyboardAppearance: Brightness.dark,
                          minLines: 1,
                          maxLines: 1,
                          controller: _postEditingController,
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: new TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                       ),
                     ),
                    ],
                  ),
                ),
                ),
              ),*/
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Container(
                  constraints: new BoxConstraints(
                    minWidth: 500.0,
                    maxWidth: 850.0
                  ),
                child: new StreamBuilder(
                  stream: _fetchAllSavedPosts,
                  builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                      return  new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        /*child: new Center(
                          child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                          ),
                        ),*/
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
                        height: MediaQuery.of(context).size.height*0.20,
                        width: MediaQuery.of(context).size.width*0.50,
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(10.0)
                        ),
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                new Text('Add your first saved post by clicking on',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 16.0, fontWeight: FontWeight.normal,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              child: new Icon(Icons.more_horiz, color: Colors.grey[600], size: 30.0),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child:new Text('from the home tab.',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 16.0, fontWeight: FontWeight.normal,
                                ),
                               ),
                              ),
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
                            listIsExpanded.add(false);
                            listTextEditingController.add(TextEditingController());
                            return new Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new PostContainer(
                                    comesFromHome: false,
                                    currentUser: widget.currentUser,
                                    currentUsername: widget.currentUserUsername,
                                    currentUserphoto: widget.currentUserPhoto,
                                    currentSoundCloud: currentSoundCloud,
                                    listIsExpanded: listIsExpanded,
                                    index: index,
                                    listTextEditingController: listTextEditingController,
                                    postID: ds['postID'],
                                    typeOfPost: ds['typeOfPost'],
                                    timestamp: ds['timestamp'],
                                    adminUID: ds['adminUID'],
                                    subject: ds['subject'],
                                    body: ds['body'],
                                    likes: ds['likes'],
                                    comments: ds['comments'],
                                    adminProfilephoto: ds['adminProfilephoto'],
                                    adminUsername: ds['adminUsername'],
                                    adminSoundCloud: ds['adminSoundCloud'],
                                  ),
                              /*new InkWell(
                                onTap: () {
                                  if(listIsExpanded[index] == true) {
                                    setState(() {
                                      listIsExpanded[index] = false;
                                    });
                                  } else {
                                    setState(() {
                                        listIsExpanded[index] = true;
                                      });
                                  }
                                },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.5),
                                  borderRadius: new BorderRadius.circular(10.0),
                                  border: new Border.all(
                                    width: 1.0,
                                    color: listIsExpanded[index] == true ? Colors.purpleAccent : Colors.transparent
                                  ),
                                ),
                                    //adminProfilephoto
                                    child: new Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
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
                                            child: ds['adminProfilephoto'] != null
                                            ? new ClipOval(
                                              child: new Image.network(ds['adminProfilephoto'], fit: BoxFit.cover),
                                            )
                                            : new Container()
                                          )),
                                          title: new RichText(
                                          textAlign: TextAlign.justify,
                                          text: new TextSpan(
                                            text: ds['adminUsername'] != null
                                            ? ds['adminUsername'] + ' -  '
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
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: new RichText(
                                          textAlign: TextAlign.justify,
                                        text: new TextSpan(
                                          text: ds['subject'] != null
                                          ? ds['subject'] + ' -'
                                          : '(error on this title)',
                                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                                          height: 1.1,
                                          ),
                                          children: [
                                            new TextSpan(
                                              text: ds['body'] != null
                                              ? '  ' + ds['body']
                                              : '   ' + ' (Error on this message)',
                                              style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                                              height: 1.5,
                                              letterSpacing: 1.1,
                                              ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                                     new Text('Remove'),
                                                     new Padding(padding: EdgeInsets.only(left: 5.0),
                                                     child: new Icon(CupertinoIcons.trash))]
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
                                                      ds['likes'] != null
                                                      ? ds['likes'].toString()
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
                                                    new Text('🥳',
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
                                                      ds['comments'] != null
                                                      ? ds['comments'].toString()
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
                                              controller: listTextEditingController[index],
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
                                            child: listIsExpanded[index] == true ? new CommentContainer(
                                              currentUser: widget.currentUser,
                                              currentUsername: widget.currentUserUsername,
                                              currentUserphoto: widget.currentUserPhoto,
                                              currentSoundcloud: currentSoundCloud,
                                              postID: ds['postID'],
                                            )
                                            : new Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ),
                                  ),*/
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
              ?  new Column(
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