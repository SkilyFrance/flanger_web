import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkify/linkify.dart';
import 'commentContainer.dart';


class PostContainer extends StatefulWidget {

  bool comesFromHome;

  //CurrentUserDatas
  String currentUser;
  String currentUsername;
  String currentUserphoto;
  String currentSoundCloud;

  //Post datas
  List<bool> listIsExpanded;
  int index;
  List<TextEditingController> listTextEditingController;
  String postID;
  String typeOfPost;
  int timestamp;
  String adminUID;
  String subject;
  String body;
  int likes;
  int comments;
  String adminProfilephoto;
  String adminUsername;
  String adminSoundCloud;

  PostContainer({
    Key key,
    this.comesFromHome,
    this.currentUser,
    this.currentUsername,
    this.currentUserphoto,
    this.currentSoundCloud,
    this.listIsExpanded,
    this.index,
    this.listTextEditingController,
    this.postID,
    this.typeOfPost,
    this.timestamp,
    this.adminUID,
    this.subject,
    this.body,
    this.likes,
    this.comments,
    this.adminProfilephoto,
    this.adminUsername,
    this.adminSoundCloud,
    }) : super(key: key);



  @override
  PostContainerState createState() => PostContainerState();
}

class PostContainerState extends State<PostContainer> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
   return new InkWell(
    onTap: () {
      if(widget.listIsExpanded[widget.index] == true) {
        setState(() {
          widget.listIsExpanded[widget.index] = false;
        });
      } else {
        setState(() {
            widget.listIsExpanded[widget.index] = true;
          });
      }
    },
  child: new Container(
    decoration: new BoxDecoration(
      color: Colors.grey[900].withOpacity(0.5),
      borderRadius: new BorderRadius.circular(10.0),
      border: new Border.all(
        width: 1.5,
        color: widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'issue'
        ? Color(0xff7360FC) 
        : widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'tip'
        ? Color(0xff62DDF9)
        : widget.listIsExpanded[widget.index] == true && widget.typeOfPost == 'project'
        ? Color(0xffBF88FF)
        : Colors.transparent,
      ),
    ),
        child: new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            new Container(
              child: new Container(
                height: 12.0,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: 
                  widget.typeOfPost == 'issue' 
                  ? Color(0xff7360FC)
                  : widget.typeOfPost == 'tip'
                  ? Color(0xff62DDF9)
                  : widget.typeOfPost == 'project'
                  ? Color(0xffBF88FF)
                  : Color(0xff62DDF9),
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            //adminProfilephoto
            new ListTile(
            contentPadding: EdgeInsets.all(20.0),
              leading: new InkWell(
                onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      backgroundColor: Color(0xff121212),
                        title: new Column(
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
                                child: widget.adminProfilephoto != null
                                ? new ClipOval(
                                  child: new Image.network(widget.adminProfilephoto, fit: BoxFit.cover),
                                )
                                : new Container(),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Center(
                                child: new Text(
                                  widget.adminUsername != null
                                  ? widget.adminUsername
                                  : 'Username',
                                style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)
                                ),
                              ),
                              ),
                          ],
                        ),
                        content: new Container(
                          height: 40.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.adminSoundCloud != 'null'
                              ? new InkWell(
                                onTap: () async {
                                if(await canLaunch(widget.adminSoundCloud)) {
                                  await launch(widget.adminSoundCloud);
                                } else {
                                  print(widget.adminSoundCloud + ' error to launch');
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
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            
                            //  ds['adminSoundCloud'] != null
                              // ? 
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
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
                                ))),
                            //  : new Container(),
                            ],
                          )
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
                child: widget.adminProfilephoto != null
                ? new ClipOval(
                  child: new Image.network(widget.adminProfilephoto, fit: BoxFit.cover),
                )
                : new Container()
              )),
              title: new RichText(
              textAlign: TextAlign.justify,
              text: new TextSpan(
                text: widget.adminUsername != null
                ? widget.adminUsername + ' -  '
                : 'Unknown' + ' -  ',
                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
                height: 1.1,
                ),
                children: [
                  new TextSpan(
                    text:  widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes < 1
                    ? 'few sec ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes < 60
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes.toString() + ' min ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inMinutes >= 60
                    && widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours <= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours.toString() + ' hours ago'
                    : widget.timestamp != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inHours >= 24
                    ? DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.timestamp)).inDays.toString() + ' days ago'
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
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Text(widget.subject != null
              ? widget.subject + ' -'
              : '(error on this title)',
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
              height: 1.1,
              ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 5.0),
            

                
              ),
              ],
            ),
            /*child: new RichText(
              textAlign: TextAlign.justify,
            text: new TextSpan(
              text: widget.subject != null
              ? widget.subject + ' -'
              : '(error on this title)',
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold,
              height: 1.1,
              ),
              children: [
                new TextSpan(
                  text: widget.body != null
                  ? '  ' + widget.body
                  : '   ' + ' (Error on this message)',
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                  height: 1.5,
                  letterSpacing: 1.1,
                  ),
                  ),
                ],
              ),
            ),*/
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
                  },
                  itemBuilder: (BuildContext ctx) => [
                    new PopupMenuItem(
                      child: new Row(
                        children: [
                          new Text(widget.comesFromHome == true ? 'Save' : 'Remove'),
                          new Padding(padding: EdgeInsets.only(left: 5.0),
                          child: new Icon(CupertinoIcons.cloud_download))]
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
                          widget.likes != null
                          ? widget.likes.toString()
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
                          widget.comments != null
                          ? widget.comments.toString()
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
                  controller: widget.listTextEditingController[widget.index],
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
                child: widget.listIsExpanded[widget.index] == true ? new CommentContainer(
                  currentUser: widget.currentUser,
                  currentUsername: widget.currentUsername,
                  currentUserphoto: widget.currentUserphoto,
                  currentSoundcloud: widget.currentSoundCloud,
                  postID: widget.postID,
                )
                : new Container(),
              ),
            ],
          ),
        ),
        ),
      );
  }
}
