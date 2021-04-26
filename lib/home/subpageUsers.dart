import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SubPageUsers extends StatefulWidget {

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
  String userProfileUID;
  String userProfileUsername;
  String userProfileLevel;
  String userProfilePhoto;

  SubPageUsers({
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
    this.userProfileUID,
    this.userProfileUsername,
    this.userProfileLevel,
    this.userProfilePhoto,
    }) : super(key: key);

  @override
  SubPageUsersState createState() => SubPageUsersState();
}

class SubPageUsersState extends State<SubPageUsers> with SingleTickerProviderStateMixin  {

  ScrollController _testViewController = new ScrollController();
  TabController _tabbarController; 
  PageController _categorieLevelPageView;

  @override
  void initState() {
    _tabbarController = new TabController(length: 4, vsync: this);
    _categorieLevelPageView = new PageController(viewportFraction: 1, initialPage: 0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xff121212),
        iconTheme: new IconThemeData(
          color: Colors.white
        ),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xff121212),
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
                          child: new Text(widget.userProfileUsername,
                          style: new TextStyle(color: Colors.grey[600],fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),
                      new Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new FittedBox(
                          fit: BoxFit.fitWidth,
                          child: new Text('Profile',
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
                    color: Colors.grey[900],
                    borderRadius: new BorderRadius.circular(10.0),
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
                              child: widget.userProfilePhoto != null
                               ? new Image.network(widget.userProfilePhoto, fit: BoxFit.cover)
                               : new Container(),
                            ),
                          ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 0.0),
                          child: new Text(
                            widget.userProfileUsername != null
                            ? widget.userProfileUsername
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
                                new Text('Global level',
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
                                  child: new Text('239',
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
                ],
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: new Center(
                child: new Text('Level by categorie',
                style: new TextStyle(fontSize: 16.0, color: Colors.grey)
                ),
              ),
              ),
            new Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Container(
                height: 90.0,
                width: 400.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                new IconButton(
                  icon: Icon(CupertinoIcons.left_chevron, color: Colors.white, size: 20.0),
                  onPressed: (){
                    _categorieLevelPageView.previousPage(duration: Duration(milliseconds: 1), curve: Curves.bounceIn);
                  }),
                new Container(
                height: 90.0,
                width: 200.0,
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.5),
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: new PageView.builder(
                  physics: new NeverScrollableScrollPhysics(),
                  itemCount: 11,
                  controller: _categorieLevelPageView,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int indexCategories){
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Center(
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
                          style: new TextStyle(fontSize: 17.0, color: Colors.grey),
                          ),
                        ),
                        new Center(
                          child: new Text('Ninja',
                          style: new TextStyle(fontSize: 20.0, color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ],
                    );
                }),
              ),
                new IconButton(
                  icon: Icon(CupertinoIcons.right_chevron, color: Colors.white, size: 20.0),
                  onPressed: (){
                    _categorieLevelPageView.nextPage(duration: Duration(milliseconds: 1), curve: Curves.bounceIn);
                  }),
              ],
                ),
              ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Container(
                  width: MediaQuery.of(context).size.width*0.70,
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                controller: _testViewController,
                itemBuilder: (BuildContext contex, int testIndex) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  child: new Container(
                    height: 500.0,
                    width: MediaQuery.of(context).size.width*0.70,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                  ),
                  );
                })
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