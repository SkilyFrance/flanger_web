import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ListFollowing extends StatefulWidget {

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

  ListFollowing({
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
  ListFollowingState createState() => ListFollowingState();
}

class ListFollowingState extends State<ListFollowing> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

 ScrollController _categorieDiscussionScrollController = new ScrollController();
 double heightCard = 130.0;
 double widthCard = 210.0;
 int categoriePointed;


@override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 40.0),
      child: new Container(
      height: 400.0,
      width: MediaQuery.of(context).size.width,
      child: new ListView.builder(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      controller: _categorieDiscussionScrollController,
      itemCount: 11,
      itemBuilder: (BuildContext context, int indexCategories) {
        return new Padding(
          padding: EdgeInsets.only(left: 15.0),
        child: new Container(
          height: 400.0,
          width: 500,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                height: 40.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.grey[900],
                        shape: BoxShape.circle,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Text('Username',
                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      )
                    )
                  ],
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new InkWell(
                  onTap: () {
                  },
                  child: new Container(
                    height: 300.0,
                    width: 500.0,
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                      indexCategories == 0
                      ? [Color(0xff3499FF), Color(0xff3A3985)]
                      : indexCategories == 1
                      ? [Color(0xff00B8BA), Color(0xff6454F0)]
                      : indexCategories == 2
                      ? [Color(0xff6454F0), Color(0xffF869D5)]
                      : indexCategories == 3
                      ? [Color(0xffFF6CAB), Color(0xff7366FF)]
                      : indexCategories == 4
                      ? [Color(0xff6EE2F5), Color(0xff6454F0)]
                      : indexCategories == 5
                      ? [Color(0xff7BF2E9), Color(0xffB65EBA)]
                      : indexCategories == 6
                      ? [Color(0xffFF9482), Color(0xff7D77FF)]
                      : indexCategories == 7
                      ? [Color(0xffF869D5), Color(0xff5650DE)]
                      : indexCategories == 8
                      ? [Color(0xffFF5B94), Color(0xff8441A4)]
                      : indexCategories == 9
                      ? [Color(0xffFF9897), Color(0xffF650A0)]
                      : indexCategories == 10
                      ? [Color(0xffFFCDA5), Color(0xffEE4D5F)]
                      : Colors.grey[900],
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Padding(
                          padding: EdgeInsets.all(0.0),
                          child: new Text(
                          indexCategories == 0
                          ? 'Melodies'
                          : indexCategories == 1
                          ? 'Vocals'
                          : indexCategories == 2
                          ? 'Sound Design'
                          : indexCategories == 3
                          ? 'Composition'
                          : indexCategories == 4
                          ? 'Drums'
                          : indexCategories == 5
                          ? 'Bass'
                          : indexCategories == 6
                          ? 'Automation'
                          : indexCategories == 7
                          ? 'Mixing'
                          : indexCategories == 8
                          ? 'Mastering'
                          : indexCategories == 9
                          ? 'Music theory'
                          :indexCategories == 10
                          ? 'Filling up'
                          : 'Melodies',
                          style: new TextStyle(fontSize: 30.0, color: Colors.white),
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
        );
      }),
      ),
    );
  }
}