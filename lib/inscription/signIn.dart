import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_web_version/inscription/sign.dart';
import 'package:flutter/material.dart';

import '../mainView.dart';


class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {


  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  bool userNotFound = false;
  bool wrongPassword = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: new GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
      child: new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
          ),
          new Center(
            child: new Text("Let's connect.",
            style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.02,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 50.0,
            ),
            ),
          new Center(
            child: new Text('Connect with your account.',
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal, fontSize: 18.0,letterSpacing: 2.0,
            ),
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.02,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 60.0,
            ),
            ),
          new Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height*0.30,
            constraints: new BoxConstraints(
              minWidth: 250.0,
              minHeight: 320.0,
              maxHeight: 400.0
            ),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  emailInput(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                  userNotFound == true 
                  ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Center(
                    child: new Text('User not found.',
                    style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                    ],
                  )
                  : new Container(),
                  passwordInput(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                  wrongPassword == true 
                  ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Center(
                    child: new Text('Wrong password.',
                    style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                    ],
                  )
                  : new Container(),
                  connectButton(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                  //dontHaveAccount(),
                ],
              ),
          ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.10,
            width: MediaQuery.of(context).size.width,
            constraints: new BoxConstraints(
              minHeight: 120.0,
            ),
            ),
        ],
        ),
        ),
        ),
    );
  }


  connectButton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        if(_emailTextController.value.text.length > 4 && _passwordTextController.value.text.length > 3 && _emailTextController.value.text == 'testdev@gmail.com') {
          FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailTextController.value.text.toString(), 
            password: _passwordTextController.value.text.toString())
          .then((authResult) {
            FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .get()
              .then((value) {
                if(value.exists) {
                    Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                    new MainViewPage(
                    currentUser: authResult.user.uid, 
                    currentUserUsername: value.data()['username'],
                    currentUserPhoto: value.data()['profilePhoto'],
                    notificationsToken: value.data()['notificationsToken']
                    )), 
                    (route) => false);
                } else {
                }
              });
          }).catchError((error){
                print(error.code);
                switch (error.code) {
                  case 'user-not-found': setState(() {userNotFound = true;});
                    break;
                  case 'wrong-password': setState(() {wrongPassword = true;});
                }
              
              });
          
        } else {

        }
      },
    child: new Container(
      constraints: new BoxConstraints(
        minWidth: 250.0,
        maxWidth: 250.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(50.0),
        border: new Border.all(
          color: Colors.purpleAccent,
          width: 1.0,
        ),
      ),
      child: new Center(
        child: new Text('SIGN IN',
        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }


  emailInput() {
    return new Container(
      constraints: new BoxConstraints(
        minWidth: 350.0,
        maxWidth: 350.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 15.0),
        keyboardType: TextInputType.text,
        scrollPhysics: new ScrollPhysics(),
        keyboardAppearance: Brightness.dark,
        minLines: 1,
        maxLines: 1,
        controller: _emailTextController,
        cursorColor: Colors.white,
        obscureText: false,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.mail_outline, color: Colors.white),
          contentPadding: EdgeInsets.only(left: 20.0),
          border: InputBorder.none,
          hintText: 'Email',
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    );

  }


  passwordInput() {
    return new Container(
      constraints: new BoxConstraints(
        minWidth: 350.0,
        maxWidth: 350.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: new Border.all(
          width: 1.0,
          color: Colors.grey,
        ),
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        style: new TextStyle(color: Colors.white, fontSize: 15.0),
        keyboardType: TextInputType.text,
        scrollPhysics: new ScrollPhysics(),
        keyboardAppearance: Brightness.dark,
        minLines: 1,
        maxLines: 1,
        controller: _passwordTextController,
        cursorColor: Colors.white,
        obscureText: true,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle: new TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }


  dontHaveAccount() {
      return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
        new SignPage()), 
        (route) => false);
      },
    child: new Container(
      constraints: new BoxConstraints(
        minWidth: 250.0,
        maxWidth: 250.0,
        minHeight: 50.0,
        maxHeight: 50.0,
      ),
      height: MediaQuery.of(context).size.height*0.40,
      width: MediaQuery.of(context).size.width*0.40,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(50.0),
      ),
      child: new Center(
        child: new Text("Don't have an account",
        style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
        ),
      ),
    ));

  }



}