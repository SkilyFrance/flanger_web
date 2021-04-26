import 'package:firebase_auth/firebase_auth.dart';
import 'package:flanger_web_version/inscription/usernamePage.dart';
import 'package:flanger_web_version/mainView.dart';
import 'package:flanger_web_version/inscription/signIn.dart';
import 'package:flutter/material.dart';

import 'usernamePage.dart';


class SignPage extends StatefulWidget {
  @override
  SignPageState createState() => SignPageState();
}

class SignPageState extends State<SignPage> {


  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  bool _invalidEmail = false;

  @override
  void initState() {
    super.initState();
  }

  


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: new GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
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
              minHeight: 60.0,
            ),
            ),
          new Center(
            child: new Text('Create your account with an email.',
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal, fontSize: 18.0,letterSpacing: 2.0,
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
                  _invalidEmail == true 
                  ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Center(
                    child: new Text('Email already in use.',
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
                  createAccountButton(),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width,
                    constraints: new BoxConstraints(
                      minHeight: 20.0,
                    ),
                    ),
                  alreadyAccountButton(),
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


  createAccountButton() {
    return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () async {
      if(_emailTextController.value.text.length > 4 && _passwordTextController.value.text.length > 3) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL).then((value) {
       return FirebaseAuth.instance
         .createUserWithEmailAndPassword(email: _emailTextController.value.text, password: _passwordTextController.value.text).then((authResult) {
           print('authResult = $authResult');
         //Go to creationProcess
         Navigator.pushAndRemoveUntil(
         context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
         new UsernamePage(
           currentUser: authResult.user.uid, 
           currentUserEmail: _emailTextController.value.text)),
         (route) => false);
         }).catchError((error) {
           print(error.code);
           if(error.code == 'email-already-in-use') {
             setState(() {
               _invalidEmail = true;
             });
           }
         });
        });
      } else {
        print('Enter datas');
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
        color: Colors.deepPurpleAccent[400],
        borderRadius: new BorderRadius.circular(50.0),
        /*border: new Border.all(
          color: Colors.purpleAccent,
          width: 1.0,
        ),*/
      ),
      child: new Center(
        child: new Text('SIGN UP',
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


  alreadyAccountButton() {
      return new InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
        new SignInPage()), 
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
        child: new Text('Already have an account',
        style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
        ),
      ),
    ));

  }



}