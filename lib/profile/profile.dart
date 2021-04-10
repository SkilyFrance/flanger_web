import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfilePage extends StatefulWidget {

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


  ProfilePage({
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
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  Stream<dynamic> _fetchCurrentUserDatas;
  bool _searchingInProgress = false;

  //About me variables
  TextEditingController _aboutMeTextEditingController = new TextEditingController();
  FocusNode _aboutMeFocusNode;
  bool _aboutMeInEditing = false;

  final aboutMeSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('Good job, successfully modified 👍',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
    ));
  

  Stream<dynamic> fetchCurrentUserDatas() {
    setState(() {
      _searchingInProgress = true;
    });
     initializationTimer();
     return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .snapshots();
  }

  /*String currentSoundCloud;
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
  }*/

  initializationTimer() {
  return Timer(Duration(seconds: 5), () {
  setState(() {
    _searchingInProgress = false;
  });
  });
  }

@override
  void initState() {
    _fetchCurrentUserDatas = fetchCurrentUserDatas();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


    FocusNode _dialogFocusNode;
    TextEditingController _dialogTextEditingController = new TextEditingController();
    String _urlFormat;
    bool _flagUrl = false;
    dialogModify(String socialNetwork, String socialNetworkLink, String fieldInFirestore) {
      showDialog(
         context: context,
         builder: (context) {
           return new StatefulBuilder(
             builder: (contextAlert, dialogSetState) {
               return AlertDialog(
               backgroundColor: Color(0xff121212),
                 title: new Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     new Center(
                       child: new Container(
                         child: new Text('$socialNetwork Link',
                         style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                         ),
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
                     child: new Container(
                       height: 50.0,
                       decoration: new BoxDecoration(
                         color: Colors.grey[900],
                         borderRadius: new BorderRadius.circular(10.0),
                       ),
                       child: new TextField(
                         focusNode: _dialogFocusNode,
                         showCursor: true,
                         textAlign: TextAlign.left,
                         style: new TextStyle(color: Colors.white, fontSize: 10.0),
                         keyboardType: TextInputType.url,
                         scrollPhysics: new ScrollPhysics(),
                         keyboardAppearance: Brightness.dark,
                         minLines: 1,
                         maxLines: 1,
                         controller: _dialogTextEditingController,
                         cursorColor: Colors.white,
                         obscureText: false,
                         decoration: new InputDecoration(
                           contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                           border: InputBorder.none,
                           hintText: socialNetworkLink != 'null' 
                           ? socialNetworkLink 
                           : 'Paste here your $socialNetwork link',
                           hintStyle: new TextStyle(
                             color: Colors.grey[600],
                             fontSize: 10.0,
                           ),
                         ),
                       ),
                     ),
                   ),
                   new Padding(
                     padding: EdgeInsets.only(top: 20.0),
                     child: new Center(
                       child: new Text(
                         socialNetwork == 'SoundCloud'
                         ? 'Has to start by https://soundcloud.com/'
                         : socialNetwork == 'Spotify'
                         ? 'Has to start by https://open.spotify.com/'
                         :  socialNetwork == 'Instagram'
                         ? 'Has to start by https://instagram.com/'
                         :  socialNetwork == 'Youtube'
                         ? 'Has to start by https://youtube.com/'
                         : socialNetwork == 'Twitter'
                         ? 'Has to start by https://twitter.com/'
                         : socialNetwork == 'Twitch'
                         ? 'Has to start by https://twitch.com/'
                         : socialNetwork == 'Mixcloud'
                         ? 'Has to start by https://mixcloud.com/'
                         : '',
                         style: new TextStyle(color: _flagUrl == true ? Colors.red : Colors.grey[700], fontSize: 10.0, fontWeight: FontWeight.normal)
                       ),
                     ),
                     ),
                   ],
                 ),
                 content: 
                 new Container(
                   height: 150.0,
                   width: 200.0,
                 child: new Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                    new Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: new InkWell(
                        onTap: () async {
                          if(socialNetworkLink != 'null') {
                            if(await canLaunch(socialNetworkLink)) {
                              await launch(socialNetworkLink);
                            } else {
                              print('$socialNetworkLink error to launch');
                            }
                          } else {}
                        },
                      child: new Container(
                        height: 45.0,
                        width: 130.0,
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        child: new Center(
                          child: new Text('Check my link',
                          style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                 new Padding(
                   padding: EdgeInsets.only(left: 50.0, right: 50.0),
                 child: new InkWell(
                   onTap: () {
                     if(socialNetwork == 'SoundCloud' && _dialogTextEditingController.value.text.startsWith('https://soundcloud.com/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else if(socialNetwork == 'Spotify' && _dialogTextEditingController.value.text.startsWith('https://open.spotify.com/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else if(socialNetwork == 'Instagram' && _dialogTextEditingController.value.text.startsWith('https://instagram.com/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else if (socialNetwork == 'Youtube' && _dialogTextEditingController.value.text.startsWith('https://www.youtube.com/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else if(socialNetwork == 'Twitter' && _dialogTextEditingController.value.text.startsWith('https://twitter.com/')) {
                        updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                        Navigator.pop(contextAlert);
                     } else if(socialNetwork == 'Twitch' && _dialogTextEditingController.value.text.startsWith('https://www.twitch.tv/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else if(socialNetwork == 'Mixcloud' && _dialogTextEditingController.value.text.startsWith('https://www.mixcloud.com/')) {
                       updateQuerySocialLinks(fieldInFirestore, _dialogTextEditingController.value.text);
                       Navigator.pop(contextAlert);
                     } else {
                       print('Format is not valid');
                       dialogSetState((){
                         _flagUrl = true;
                       });
                     }
                   },
                   child: new Container(
                     height: 45.0,
                     width: 160.0,
                     decoration: new BoxDecoration(
                       color: socialNetwork == 'SoundCloud'
                       ? Colors.orange
                       : socialNetwork == 'Spotify'
                       ? Colors.green[800]
                       : socialNetwork == 'Instagram'
                       ? Colors.purple[800]
                       : socialNetwork == 'Youtube'
                       ? Colors.red[800]
                       : socialNetwork == 'Twitter'
                       ? Colors.blue[600]
                       : socialNetwork == 'Twitch'
                       ? Colors.deepPurple[600]
                       : Colors.white,
                       borderRadius: new BorderRadius.circular(40.0),
                     ),
                     child: new Center(
                       child: new Text('Save',
                       style: new TextStyle(color: socialNetwork == 'Mixcloud' ? Colors.black : Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                       ),
                     ),
                   ),
                 ),
                   ),
                   ],
                 ),
                 ),
             );
             });
         } 
       ).whenComplete(() {
         setState(() {
           _flagUrl = false;
           _dialogTextEditingController.clear();
         });
       });
   }

   updateQuerySocialLinks(String fieldInFirestore, String textEditingValue) {
     FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .update({
        '$fieldInFirestore': textEditingValue,
      }).whenComplete(() {
        print('Cloud Firestore : $fieldInFirestore updated');
        ScaffoldMessenger.of(context).showSnackBar(aboutMeSnackBar);
      });
   }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      backgroundColor: Color(0xff121212),
      body: new GestureDetector(
        onTap: () {
          if(_aboutMeInEditing == true) {
            setState(() {
              _aboutMeInEditing = false;
            });
          }
        },
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Center(
                  child: new Text('Profile',
                  style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('Manage here all your profile parameters.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: new Icon(CupertinoIcons.settings, color: Colors.greenAccent, size: 20.0),
                    ),
                  new Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: new Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              color: Colors.grey[900],
                              shape: BoxShape.circle,
                            ),
                            child: widget.currentUserPhoto != null
                            ? new ClipOval(
                              child: new Image.network(widget.currentUserPhoto, fit: BoxFit.cover, filterQuality: FilterQuality.low),
                            )
                            : new Container(),
                          ),
                          //UserName
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Text(
                              widget.currentUserUsername != null
                              ? widget.currentUserUsername 
                              : 'Username',
                              style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500),
                            ),
                            ),
                            //Social links
                            new Padding(
                              padding: EdgeInsets.only(top: 40.0),
                              child: new Text('Social links',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                              ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Container(
                              height: 40.0,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    new InkWell(
                                      onTap: () {
                                        dialogModify('SoundCloud', widget.currentSoundCloud, 'soundCloud');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/soundCloud.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentSoundCloud != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )),
                                  )),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Spotify', widget.currentSpotify, 'spotify');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/spotify.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentSpotify != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Instagram', widget.currentInstagram, 'instagram');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/instagram.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentInstagram != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )),
                                  ),
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Youtube', widget.currentYoutube, 'youtube');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/youtube.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentYoutube != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ),
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Twitter', widget.currentTwitter, 'twitter');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/twitter.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentTwitter != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ),
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Twitch', widget.currentTwitch, 'twitch');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/twitch.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentTwitch != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ),
                                  ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        dialogModify('Mixcloud', widget.currentMixcloud, 'mixcloud');
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
                                    child: new Stack(
                                      children: [
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new ClipOval(
                                            child: new Image.asset('web/icons/mixcloud.png', fit: BoxFit.cover)),
                                        ),
                                        new Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: widget.currentMixcloud != 'null'
                                          ? new Container()
                                          : new Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ),
                                      ],
                                    )
                                    ),
                                  ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Container(
                              child: new Text('About you',
                                style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                              ),
                            ),
                            ),
                          new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                            child: new Container(
                                  child: new Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                child: new Container(
                                  height: 200.0,
                                  width: 500.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child: _aboutMeInEditing == false
                                  ? new Padding(
                                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                    child: new InkWell(
                                      onTap: () {
                                        setState(() {
                                          _aboutMeTextEditingController = new TextEditingController(text: widget.currentAboutMe);
                                          _aboutMeInEditing = true;
                                        });
                                      },
                                    child: new Text(
                                      widget.currentAboutMe != 'null'
                                      ? widget.currentAboutMe
                                      : 'Tell something about you & your music ...',
                                      textAlign: TextAlign.justify,
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, wordSpacing: 1.0, letterSpacing: 1.0, height: 1.5),
                                    )),
                                  )
                                  : new TextField(
                                    focusNode: _aboutMeFocusNode,
                                    showCursor: true,
                                    //textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(color: Colors.white, fontSize: 15.0, wordSpacing: 1.0, letterSpacing: 1.0, height: 1.5),
                                    keyboardType: TextInputType.multiline,
                                    scrollPhysics: new ScrollPhysics(),
                                    keyboardAppearance: Brightness.dark,
                                    minLines: null,
                                    maxLines: null,
                                    controller: _aboutMeTextEditingController,
                                    cursorColor: Colors.white,
                                    obscureText: false,
                                    decoration: new InputDecoration(
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
                                ),
                            ),
                          ),
                          _aboutMeInEditing == true
                          ? new Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: new Center(
                            child: new InkWell(
                              onTap: () {
                                if(widget.currentAboutMe == _aboutMeTextEditingController.value.text) {
                                  setState(() {
                                    _aboutMeInEditing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(aboutMeSnackBar);
                                } else if(widget.currentAboutMe != _aboutMeTextEditingController.value.text && _aboutMeTextEditingController.value.text.length > 3) {
                                  FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.currentUser)
                                    .update({
                                      'aboutMe': _aboutMeTextEditingController.value.text,
                                    }).whenComplete(() {
                                    print('Cloud firestore : About me updated');
                                    setState(() {
                                      _aboutMeInEditing = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(aboutMeSnackBar);
                                    });
                                }
                                //Request to store new about me
                              },
                            child: new Container(
                              height: 45.0,
                              width: 120.0,
                              decoration: new BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: new BorderRadius.circular(5.0)
                              ),
                              child: new Center(
                                child: new Text('Modify',
                                style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                ),
                              ),
                              ),
                              ),
                            ),
                          )
                          : new Container(),
                        ],
                      ),
                    ),




























                  /*  child: new StreamBuilder(
                      stream: _fetchCurrentUserDatas,
                      builder: (BuildContext context, snapshot) {
                        if(!snapshot.hasData || snapshot.hasError) {
                        // Create profile container
                          return new Container(
                            height: MediaQuery.of(context).size.height*0.40,
                            width: MediaQuery.of(context).size.width,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.20,
                                  width: MediaQuery.of(context).size.width*0.40,
                                  decoration: new BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: new BorderRadius.circular(10.0)
                                  ),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    new Text('An error occured, please restart.',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal)),
                                    new Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: new Icon(CupertinoIcons.wifi_exclamationmark, size: 20.0, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                  //////
                        /*return new Container(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900],
                                  shape: BoxShape.circle,
                                ),
                                child: snapshot.data['profilePhoto'] != null
                                ? new ClipOval(
                                  child: new Image.network(snapshot.data['profilePhoto'], fit: BoxFit.cover, filterQuality: FilterQuality.low),
                                )
                                : new Container(),
                              ),
                              //UserName
                              new Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: new Text(
                                  snapshot.data['username'] != null
                                  ? snapshot.data['username']
                                  : 'Username',
                                  style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500),
                                ),
                                ),
                                //Social links
                                new Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                  child: new Text('Social links',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                                  ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: new Container(
                                  height: 40.0,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        new InkWell(
                                          onTap: () {
                                            dialogModify('SoundCloud', snapshot.data['soundCloud'], 'soundCloud');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/soundCloud.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['soundCloud'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )),
                                      )),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Spotify', snapshot.data['spotify'], 'spotify');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/spotify.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['spotify'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        ),
                                        ),
                                      ),
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Instagram', snapshot.data['instagram'], 'instagram');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/instagram.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['instagram'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )),
                                      ),
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Youtube', snapshot.data['youtube'], 'youtube');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/youtube.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['youtube'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )
                                        ),
                                      ),
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Twitter', snapshot.data['twitter'], 'twitter');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/twitter.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['twitter'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )
                                        ),
                                      ),
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Twitch', snapshot.data['twitch'], 'twitch');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/twitch.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['twitch'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )
                                        ),
                                      ),
                                      ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            dialogModify('Mixcloud', snapshot.data['mixcloud'], 'mixcloud');
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
                                        child: new Stack(
                                          children: [
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: new ClipOval(
                                                child: new Image.asset('web/icons/mixcloud.png', fit: BoxFit.cover)),
                                            ),
                                            new Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              child: snapshot.data['mixcloud'] != 'null'
                                              ? new Container()
                                              : new Container(
                                                height: 35.0,
                                                width: 35.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              ),
                                          ],
                                        )
                                        ),
                                      ),
                                      ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: new Container(
                                  child: new Text('About you',
                                    style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.normal),
                                  ),
                                ),
                                ),
                              new Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: new Center(
                                child: new Container(
                                      child: new Padding(
                                    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                    child: new Container(
                                      height: 200.0,
                                      width: 500.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: new BorderRadius.circular(10.0),
                                      ),
                                      child: _aboutMeInEditing == false
                                      ? new Padding(
                                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                        child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              _aboutMeTextEditingController = new TextEditingController(text: snapshot.data['aboutMe']);
                                              _aboutMeInEditing = true;
                                            });
                                          },
                                        child: new Text(
                                          snapshot.data['aboutMe'] != 'null'
                                          ? snapshot.data['aboutMe']
                                          : 'Tell something about you & your music ...',
                                          textAlign: TextAlign.justify,
                                          style: new TextStyle(color: Colors.white, fontSize: 15.0, wordSpacing: 1.0, letterSpacing: 1.0, height: 1.5),
                                        )),
                                      )
                                      : new TextField(
                                        focusNode: _aboutMeFocusNode,
                                        showCursor: true,
                                        //textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(color: Colors.white, fontSize: 15.0, wordSpacing: 1.0, letterSpacing: 1.0, height: 1.5),
                                        keyboardType: TextInputType.multiline,
                                        scrollPhysics: new ScrollPhysics(),
                                        keyboardAppearance: Brightness.dark,
                                        minLines: null,
                                        maxLines: null,
                                        controller: _aboutMeTextEditingController,
                                        cursorColor: Colors.white,
                                        obscureText: false,
                                        decoration: new InputDecoration(
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
                                    ),
                                ),
                              ),
                              _aboutMeInEditing == true
                              ? new Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: new Center(
                                child: new InkWell(
                                  onTap: () {
                                    if(snapshot.data['aboutMe'] == _aboutMeTextEditingController.value.text) {
                                      setState(() {
                                        _aboutMeInEditing = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(aboutMeSnackBar);
                                    } else if(snapshot.data['aboutMe'] != _aboutMeTextEditingController.value.text && _aboutMeTextEditingController.value.text.length > 3) {
                                      FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.currentUser)
                                        .update({
                                          'aboutMe': _aboutMeTextEditingController.value.text,
                                        }).whenComplete(() {
                                        print('Cloud firestore : About me updated');
                                        setState(() {
                                          _aboutMeInEditing = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(aboutMeSnackBar);
                                        });
                                    }
                                    //Request to store new about me
                                  },
                                child: new Container(
                                  height: 45.0,
                                  width: 120.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: new BorderRadius.circular(5.0)
                                  ),
                                  child: new Center(
                                    child: new Text('Modify',
                                    style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  ),
                                  ),
                                ),
                              )
                              : new Container(),
                            ],
                          ),
                        );*/
                //////////////// 
                      }),*/
                   ),
                  ],
                )
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}