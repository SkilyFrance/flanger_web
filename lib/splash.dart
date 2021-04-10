import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'inscription/landingPage.dart';
import 'inscription/usernamePage.dart';
import 'mainView.dart';



class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
    //User user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance
      .idTokenChanges()
      .listen((event) {
        if(this.mounted) {
        if(event != null) {
          event.getIdToken().then((token) => print('The user ID token is' + token));
          //User user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
            .collection('users')
            .doc(event.uid)
            .get()
            .then((value) {
              if(value.exists) {
                Navigator.pushReplacement(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                new MainViewPage(
                  currentUser: event.uid,
                  currentUserUsername: value.data()['username'],
                  currentUserPhoto: value.data()['profilePhoto'],
                  notificationsToken: value.data()['notificationsToken'],
                  )));
              } else {
                //Value No exist
                Navigator.pushReplacement(
                  context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                  new UsernamePage(
                    currentUser: event.uid, 
                    currentUserEmail: event.email)));
              }
            }).catchError((error) => print(error));
        } else {
          print('User is currently signed out');
          print('no user recognize');
          Navigator.pushReplacement(context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LandinPage()));
        }
      }
      });
    });
    super.initState();
  }
 
  checkIfLogged() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child: new Container(
          color: Colors.black,
          child: Text(""),
        ),
      ),
    );
  }
}