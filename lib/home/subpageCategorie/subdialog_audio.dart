import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerContainer extends StatefulWidget {


  String channelDiscussion;
  //CurrentUser
  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;
  String currentNotificationsToken;

  Color colorButton;
  //Post datas
  int index;
  String postID;
  int timestamp;
  String adminUID;
  String adminUsername;
  String subject;
  String body;
  double trackDuration;
  String trackURL;
  //comments
  int comments;
  Map<dynamic, dynamic> commentedBy;
  //reactedBy
  Map<dynamic, dynamic> reactedBy;

  //AudioPlayerVariables
  //Duration postContainerCurrentPositionTrack;
  int postContainerTrackDivisions;
  double postContainerTrackStartParticular;
  double postContainerTrackEndParticular;

  AudioPlayerContainer({
  Key key,
  this.channelDiscussion,
  this.currentUser,
  this.currentUserUsername,
  this.currentUserPhoto,
  this.currentNotificationsToken,
  this.colorButton,
  this.index,
  this.postID,
  this.timestamp,
  this.adminUID,
  this.adminUsername,
  this.subject,
  this.body,
  this.trackDuration,
  this.trackURL,
  //comments
  this.comments,
  this.commentedBy,
  //reactedBy
  this.reactedBy,

  //AudioPlayerVariables
  this.postContainerTrackDivisions,
  this.postContainerTrackStartParticular,
  this.postContainerTrackEndParticular,
    }) : super(key: key);



  @override
  AudioPlayerContainerState createState() => AudioPlayerContainerState();
}

class AudioPlayerContainerState extends State<AudioPlayerContainer> {


  // VARIABLES FOR PLAY A TRACK ON POST CONTAINER //
  AudioPlayer audioPlayer = new AudioPlayer();
  List<int> subListFeedbackCategorie = [];
  Duration durationTrack;
  Duration currentPositionTrack;
  double trackDragStart = 0.0;
  ///////////////////////////////////////

  FocusNode _focusNode = new FocusNode();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        border: new Border.all(
          width: 2.0,
          color: audioPlayer.playerState.playing == true
          ? Colors.purple
          : Colors.transparent,
          ),
          ),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new Center(
                  child: new Text('A specific part was put forward by ' + widget.adminUsername,
                  style: new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
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
                      audioPlayer.playerState.playing == true 
                    ? CupertinoIcons.pause_circle_fill
                    : CupertinoIcons.play_circle_fill,
                      size: 40.0,
                      color: Colors.white,
                      ), 
                      onPressed: () async {
                        if(audioPlayer.playerState.playing == false && durationTrack == null ) {
                          print('AudioPlayer : launch new track');
                          await audioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                            audioPlayer.durationStream.listen((event) {
                              setState(() {
                                durationTrack = audioPlayer.duration;
                              });
                              audioPlayer.positionStream.listen((event) {
                                setState(() {
                                  currentPositionTrack = event;
                                });
                                print('Track duration = ' + Duration(milliseconds: durationTrack.inMilliseconds.toInt()).toString());
                                print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: currentPositionTrack.inMilliseconds.toInt()).toString());
                                if(currentPositionTrack >= Duration(milliseconds: durationTrack.inMilliseconds.toInt())) {
                                  print('AudioPlayer: Extract finished');
                                  audioPlayer.pause();
                                  }
                              });
                              audioPlayer.play();
                            });
                          });
                        }  else if(audioPlayer.playerState.playing == false
                          && ((trackDragStart > currentPositionTrack.inMilliseconds) || (trackDragStart < currentPositionTrack.inMilliseconds))) {
                          audioPlayer.seek(Duration(milliseconds: trackDragStart.toInt())).whenComplete(() {
                            print('AudioPlayer : play after seek');
                            audioPlayer.play();
                          });
                      
                        } else if(//_trackURLPlaying == widget.trackURL
                        audioPlayer.playerState.playing == true) {
                          print('AudioPlayer : Pause');
                          audioPlayer.pause();
                        }
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
                                  trackHeight: 15.0,
                                  disabledThumbColor: Colors.transparent,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0), 
                                  thumbColor: Colors.cyanAccent,
                                  //disabledThumbColor: Colors.transparent,
                                  //trackShape: RoundedRectSliderTrackShape(),
                                  //inactiveTrackColor: Colors.grey[900],
                                  inactiveTrackColor: Color(0xff0d1117),
                                  activeTrackColor: Colors.cyanAccent,
                                // disabledInactiveTickMarkColor: Colors.transparent,
                                  //activeTickMarkColor: Colors.deepPurpleAccent.withOpacity(0.6),
                                  //inactiveTickMarkColor: Colors.grey[600],
                                // tickMarkShape: SliderTickMarkShape.noTickMark,
                                ),
                              child: ExcludeSemantics(
                              child: new RangeSlider(
                                labels: RangeLabels('',''),
                                min: 0.0,
                                max: durationTrack != null ? durationTrack.inMilliseconds.toDouble() : widget.trackDuration,
                                values: new RangeValues(widget.postContainerTrackStartParticular.toDouble(), widget.postContainerTrackEndParticular.toDouble()),
                                onChangeStart: (value) {},
                                onChanged: (value) {},
                                divisions: audioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
                                ),
                              )),
                              new SliderTheme(
                                data: Theme.of(context).sliderTheme.copyWith(
                                  trackHeight: 15.0,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0), 
                                  thumbColor: widget.colorButton,
                                  //disabledThumbColor: Colors.transparent,
                                  //trackShape: RoundedRectSliderTrackShape(),
                                  inactiveTrackColor: Colors.transparent,
                                  activeTrackColor: Colors.cyanAccent.withOpacity(0.2),
                                // disabledInactiveTickMarkColor: Colors.transparent,
                                  activeTickMarkColor: Colors.cyanAccent.withOpacity(0.6),
                                  inactiveTickMarkColor: Color(0xff21262D),
                                // tickMarkShape: SliderTickMarkShape.noTickMark,
                                ),
                              child: new Slider(
                                label: new Duration(milliseconds: (trackDragStart).toInt()).toString().split('.')[0],
                                min: 0.0,
                                max: durationTrack != null ? durationTrack.inMilliseconds.toDouble() : widget.trackDuration,
                                value: audioPlayer.playerState.playing == true ? currentPositionTrack.inMilliseconds.toDouble() : trackDragStart,
                                onChangeStart: (value) {
                                  if(audioPlayer.playerState.playing == true) {
                                    audioPlayer.pause();
                                  }
                                },
                                onChanged: (value) {
                                  setState((){
                                    trackDragStart = value;
                                  });
                                },
                                divisions: audioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
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
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text('Duration :',
                      style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: new Text(
                        trackDragStart != null && currentPositionTrack != null
                        ? 
                        (audioPlayer.playerState.playing == true
                        ? Duration(milliseconds: (durationTrack.inMilliseconds-currentPositionTrack.inMilliseconds).toInt()).toString().split('.')[0]
                        : Duration(milliseconds: (durationTrack.inMilliseconds-trackDragStart).toInt()).toString().split('.')[0]
                        )
                        : Duration(milliseconds: (widget.trackDuration).toInt()).toString().split('.')[0],
                        style: new TextStyle(color: Colors.grey[600], fontSize: 14.0, fontWeight: FontWeight.normal),
                      
                      //_dragValueEndFeedback.toInt().round()).toString().split('.')[0]
                      ),
                        ),
                    ],
                  )
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 40.0),
                      child: new Center(
                        child: new Text('Give now your feedback about',
                        style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ),
                   new Padding(
                   padding: EdgeInsets.only(top: 20.0),
                   child: new Container(
                     height: 200.0,
                     width: MediaQuery.of(context).size.width*0.40,
                     decoration: new BoxDecoration(
                       color: Color(0xff0d1117),
                       borderRadius: new BorderRadius.circular(10.0),
                     ),
                     child: new TextField(
                       focusNode: _focusNode,
                       showCursor: true,
                       //textAlignVertical: TextAlignVertical.center,
                       textAlign: TextAlign.left,
                       style: new TextStyle(color: Colors.white, fontSize: 16.0),
                       keyboardType: TextInputType.multiline,
                       scrollPhysics: new ScrollPhysics(),
                       keyboardAppearance: Brightness.dark,
                       minLines: null,
                       maxLines: null,
                       controller: _textEditingController,
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
                   new Padding(
                     padding: EdgeInsets.only(top: 30.0),
                    child: new InkWell(
                      onTap: () {
                      if(_textEditingController.text.length > 0) {
                      widget.reactedBy[widget.currentUser] = widget.currentNotificationsToken;
                      widget.commentedBy[widget.currentUser] = widget.currentUserUsername;
                      int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
                      Map<dynamic, dynamic> likedBy = {};
                      Map<dynamic, dynamic> commentedBy = {};
                      FirebaseFirestore.instance
                        .collection('${widget.channelDiscussion}')
                        .doc(widget.postID)
                        .collection('comments')
                        .doc('$_timestampCreation${widget.currentUserUsername}')
                        .set({
                          'adminUID': widget.adminUID,
                          'commentatorProfilephoto': widget.currentUserPhoto,
                          'commentatorUID': widget.currentUser,
                          'commentatorUsername': widget.currentUserUsername,
                          'content': _textEditingController.value.text,
                          'postID': widget.postID,
                          'subject': widget.subject,
                          'timestamp': _timestampCreation,
                          'withImage': false,
                          'imageURL': null,
                          'commentedBy': commentedBy,
                          'comments': 0,
                          'likedBy': likedBy,
                          'likes': 0,
                          'reactedBy': {
                            '${widget.currentUser}': widget.currentNotificationsToken,
                          }
                        }).whenComplete(() {
                          _textEditingController.clear();
                          Navigator.pop(context);
                          FirebaseFirestore.instance
                            .collection('${widget.channelDiscussion}')
                            .doc(widget.postID)
                            .update({
                              'comments': FieldValue.increment(1),
                              'commentedBy': widget.commentedBy,
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
                                    _focusNode.unfocus();
                                  });
                                }
                              });
                            });
                        });
                      } else {
                        print('TextEditing : Nothing to send');
                      }
                      },
                    child: new Container(
                      height: 45.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(40.0),
                        color: widget.colorButton,
                      ),
                      child: new Center(
                        child: new Text('Publish',
                        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                        )
                      ),
                    ),
                    ),
                   ),
                ],
              ),
    );
  }
}