import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flanger_web_version/replyContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatefulWidget {

  String currentUser;
  String currentUsername;
  String currentUserphoto;
  String currentSoundcloud;
  String postID;

  CommentContainer({
    Key key,
    this.currentUser,
    this.currentUsername,
    this.currentUserphoto,
    this.currentSoundcloud,
    this.postID,
    }) : super(key: key);


  @override
  CommentContainerState createState() => CommentContainerState();

}

class CommentContainerState extends State<CommentContainer> {


  Stream<dynamic> _fetchAllComments;
  ScrollController _listCommentsScrollController = new ScrollController();
  List<TextEditingController> listTextEditingController = [];

  Stream<dynamic> fetchAllComments() {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(widget.postID)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }



@override
  void initState() {
    _fetchAllComments = fetchAllComments();
    _listCommentsScrollController = new ScrollController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _fetchAllComments,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
        return  new Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: MediaQuery.of(context).size.width,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
          color: Colors.transparent,
          child: new Center(
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            ),
          ),
        );
        }
        if(snapshot.hasError) {
        return  new Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: MediaQuery.of(context).size.width,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
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
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          constraints: new BoxConstraints(
            minHeight: 100.0,
          ),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  new Text('Be first to comment.',
                  style: new TextStyle(color: Colors.grey[600], fontSize: 18.0, fontWeight: FontWeight.normal,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0),
                child: new Icon(CupertinoIcons.bubble_left_bubble_right, color: Colors.grey[600], size: 30.0)),
              ],
            ),
        ));
        }
        return new Container(
          width: MediaQuery.of(context).size.width,
          child: new ListView.builder(
            controller: _listCommentsScrollController,
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var ds = snapshot.data.docs[index];
              listTextEditingController.add(TextEditingController());
              return new Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    border: new Border.all(
                      width: 0.5,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new ListTile(
                    contentPadding: EdgeInsets.all(20.0),
                      leading: new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      child: ds['commentatorProfilephoto'] != null
                      ? new ClipOval(
                        child: new Image.network(ds['commentatorProfilephoto'], fit: BoxFit.cover),
                      )
                      : new Container()
                      ),
                      title: new RichText(
                        textAlign: TextAlign.justify,
                        text: new TextSpan(
                          text: ds['commentatorUsername'] != null
                          ? ds['commentatorUsername'] + ' -  '
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
                    child: new Text(
                      ds['content'] != null
                      ? ds['content'].toString()
                      : '(Error on this message)',
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal,
                      height: 1.5,
                      letterSpacing: 1.1,
                      ),
                    ),
                    ),
                    ),
                    //TextEditingController
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
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
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                      child: new ReplyContainer(
                        currentUser: widget.currentUser,
                        currentUsername: widget.currentUsername,
                        currentUserphoto: widget.currentUserphoto,
                        currentSoundcloud: widget.currentSoundcloud,
                        postID: widget.postID,
                        commentID: ds['timestamp'].toString()+ds['commentatorUsername'],
                      ),
                    ),
                  ],
                ),
                ),
              );
            }),
        );
      },
    );
  }
}