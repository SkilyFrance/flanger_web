import 'package:flanger_web_version/home/subpageCategorie/subpageCategorie.dart';
import 'package:flanger_web_version/transition/fadeRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ListCategorieDiscussion extends StatefulWidget {

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

  ListCategorieDiscussion({
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
  ListCategorieDiscussionState createState() => ListCategorieDiscussionState();
}

class ListCategorieDiscussionState extends State<ListCategorieDiscussion> {

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
    return new Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: new Container(
      height: 120.0,
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
          child: new MouseRegion(
            onEnter: (isEntering) {
              setState(() {
                categoriePointed = indexCategories;
              });
                },
            onExit: (isExiting) {
              setState(() {
               categoriePointed = null;
              });
                },
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context, 
                new FadeRoute(page: new SubPageCategorie(
                    indexCategories: indexCategories,
                    currentUser: widget.currentUser,
                    currentUserPhoto:  widget.currentUserPhoto,
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
                )));
            },
            child: new Container(
              height: heightCard,
              width: widthCard,
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
              child: categoriePointed == indexCategories
              ?  new Container(
              height: heightCard,
              width: widthCard,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.4),
                 ),
                 child: new Center(
                   child: new Icon(CupertinoIcons.eye_fill, color: Colors.white, size: 20.0),
                 ),
               )
              : new Column(
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
        );
      }),
      ),
    );
  }
}