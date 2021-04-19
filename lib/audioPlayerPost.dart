import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerPost extends StatefulWidget {


  String adminUsername;
  String trackURL;
  AudioPlayer postContainerAudioPlayer;
  Duration postContainerDurationTrack;
  Duration postContainerCurrentPositionTrack;
  double postContainerTrackDragStart;
  double postContainerTrackStartParticular;
  double postContainerTrackEndParticular;
  int postContainerTrackDivisions;
  double trackDuration;

  AudioPlayerPost({
    Key key,
    this.adminUsername,
    this.trackURL,
    this.postContainerAudioPlayer,
    this.postContainerDurationTrack,
    this.postContainerCurrentPositionTrack,
    this.postContainerTrackDragStart,
    this.postContainerTrackStartParticular,
    this.postContainerTrackEndParticular,
    this.postContainerTrackDivisions,
    this.trackDuration,
    }) : super(key: key);


 @override
 AudioPlayerPostState createState() => AudioPlayerPostState();
}


class AudioPlayerPostState extends State<AudioPlayerPost> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Container(
    child: new Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        border: new Border.all(
          width: 2.0,
          color: widget.postContainerAudioPlayer.playerState.playing == true
          ? Colors.purple
          : Colors.transparent,
        ),
      ),
      height: 110.0,
                     child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      new Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: new Center(
                          child: new Text('A specific part was put forward by ' + widget.adminUsername,
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
                              widget.postContainerAudioPlayer.playerState.playing == true 
                             ? CupertinoIcons.pause_circle_fill
                             : CupertinoIcons.play_circle_fill,
                              size: 40.0,
                              color: Colors.white,
                              ), 
                              onPressed: () async {
                                if(widget.postContainerAudioPlayer.playerState.playing == false && widget.postContainerDurationTrack == null ) {
                                  await widget.postContainerAudioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                                    widget.postContainerAudioPlayer.durationStream.listen((event) {
                                      setState(() {
                                        widget.postContainerDurationTrack = widget.postContainerAudioPlayer.duration;
                                      });
                                      widget.postContainerAudioPlayer.positionStream.listen((event) {
                                        setState(() {
                                          widget.postContainerCurrentPositionTrack = event;
                                        });
                                        print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                        print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack.inMilliseconds.toInt()).toString());
                                        if(widget.postContainerCurrentPositionTrack >= Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt())) {
                                          print('AudioPlayer: Extract finished');
                                          widget.postContainerAudioPlayer.pause();
                                          }
                                      });
                                      widget.postContainerAudioPlayer.play();
                                    });
                                  });
                                }  else if(widget.postContainerAudioPlayer.playerState.playing == false
                                  && ((widget.postContainerTrackDragStart > widget.postContainerCurrentPositionTrack.inMilliseconds) || (widget.postContainerTrackDragStart < widget.postContainerCurrentPositionTrack.inMilliseconds))) {
                                  widget.postContainerAudioPlayer.seek(Duration(milliseconds: widget.postContainerTrackDragStart.toInt())).whenComplete(() {
                                    print('AudioPlayer : play after seek');
                                    widget.postContainerAudioPlayer.play();
                                  });
                              
                                } else if(//_trackURLPlaying == widget.trackURL
                                 widget.postContainerAudioPlayer.playerState.playing == true) {
                                  print('AudioPlayer : Pause');
                                  widget.postContainerAudioPlayer.pause();
                                }








                             /* if(_trackURLPlaying != widget.trackURL) {
                                if(_trackURLPlaying != '') {
                                         widget.postContainerAudioPlayer.stop().whenComplete(() async {
                                        setState(() {
                                          _trackURLPlaying = widget.trackURL;
                                        });
                                        await widget.postContainerAudioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                                          widget.postContainerAudioPlayer.durationStream.listen((event) {
                                            setState(() {
                                              widget.postContainerDurationTrack = widget.postContainerAudioPlayer.duration;
                                            });
                                            widget.postContainerAudioPlayer.positionStream.listen((event) {
                                              setState(() {
                                                widget.postContainerCurrentPositionTrack = event;
                                              });
                                              //print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                            // print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack[widget.index].inMilliseconds.toInt()).toString());
                                              if(widget.postContainerCurrentPositionTrack >= Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt())) {
                                                print('AudioPlayer: Extract finished');
                                                widget.postContainerAudioPlayer.pause();
                                                }
                                            });
                                            widget.postContainerAudioPlayer.play();
                                          });
                                        });
                                        });
                                      
                             
                                } else {
                                  //_trackURLPlaying == ''
                                  print('AudioPlayer : Play cause no track played yet');
                                  /*setState(() {
                                    _trackURLPlaying = widget.trackURL;
                                    _trackIsPlayingIndex = widget.index;
                                  });*/
                                  await widget.postContainerAudioPlayer.setUrl(widget.trackURL).whenComplete(() async {
                                    widget.postContainerAudioPlayer.durationStream.listen((event) {
                                      setState(() {
                                        widget.postContainerDurationTrack = widget.postContainerAudioPlayer.duration;
                                      });
                                      widget.postContainerAudioPlayer.positionStream.listen((event) {
                                        setState(() {
                                          widget.postContainerCurrentPositionTrack = event;
                                        });
                                        print('Track duration = ' + Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt()).toString());
                                        print('widget.postContainerCurrentPositionTrack = ' + Duration(milliseconds: widget.postContainerCurrentPositionTrack.inMilliseconds.toInt()).toString());
                                        if(widget.postContainerCurrentPositionTrack >= Duration(milliseconds: widget.postContainerDurationTrack.inMilliseconds.toInt())) {
                                          print('AudioPlayer: Extract finished');
                                          widget.postContainerAudioPlayer.pause();
                                          }
                                      });
                                      widget.postContainerAudioPlayer.play();
                                    });
                                  });
                                }
                                
                              } else if(//_trackURLPlaying == widget.trackURL
                                   widget.postContainerAudioPlayer.playerState.playing == false
                                  && ((widget.postContainerTrackDragStart > widget.postContainerCurrentPositionTrack.inMilliseconds) || (widget.postContainerTrackDragStart < widget.postContainerCurrentPositionTrack.inMilliseconds))) {
                                  widget.postContainerAudioPlayer.seek(Duration(milliseconds: widget.postContainerTrackDragStart.toInt())).whenComplete(() {
                                    print('AudioPlayer : play after seek');
                                    widget.postContainerAudioPlayer.play();
                                  });
                              
                                } else if(//_trackURLPlaying == widget.trackURL
                                 widget.postContainerAudioPlayer.playerState.playing == true) {
                                  print('AudioPlayer : Pause');
                                  widget.postContainerAudioPlayer.pause();
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
                                        values: new RangeValues(widget.postContainerTrackStartParticular.toDouble(), widget.postContainerTrackEndParticular.toDouble()),
                                        onChangeStart: (value) {},
                                        onChanged: (value) {},
                                        divisions: widget.postContainerAudioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
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
                                        label: new Duration(milliseconds: (widget.postContainerTrackDragStart).toInt()).toString().split('.')[0],
                                        min: 0.0,
                                        max: widget.postContainerDurationTrack != null ? widget.postContainerDurationTrack.inMilliseconds.toDouble() : 120000,
                                        value: widget.postContainerAudioPlayer.playerState.playing == true ? widget.postContainerCurrentPositionTrack.inMilliseconds.toDouble() : widget.postContainerTrackDragStart,
                                        onChangeStart: (value) {
                                          if(widget.postContainerAudioPlayer.playerState.playing == true) {
                                            widget.postContainerAudioPlayer.pause();
                                          }
                                        },
                                        onChanged: (value) {
                                          setState((){
                                            widget.postContainerTrackDragStart = value;
                                          });
                                        },
                                        divisions: widget.postContainerAudioPlayer.playerState.playing == true ? null : widget.postContainerTrackDivisions,
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
                                widget.postContainerDurationTrack != null && widget. postContainerCurrentPositionTrack != null
                                ? 
                                (widget.postContainerAudioPlayer.playerState.playing == true
                                ? Duration(milliseconds: (widget.postContainerDurationTrack.inMilliseconds-widget.postContainerCurrentPositionTrack.inMilliseconds).toInt()).toString().split('.')[0]
                                : Duration(milliseconds: (widget.postContainerDurationTrack.inMilliseconds-widget.postContainerTrackDragStart).toInt()).toString().split('.')[0]
                                )
                                : Duration(milliseconds: (widget.trackDuration).toInt()).toString().split('.')[0],
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
    );
  }
}