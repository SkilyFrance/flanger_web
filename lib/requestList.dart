import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


  requestPost(
  String collectionPost,
  bool withImage,
  String imageURL,
  String currentUser,
  String currentUserUsername,
  String currentUserPhoto,
  String currentNotificationsToken,
  String body, 
  String subject, 
  StateSetter setState, 
  bool publishingInProgress, 
  BuildContext context, 
  TextEditingController subjectEditingController, 
  TextEditingController bodyEditingController,
  ) {
  List<String> keywords;
  setState((){
    publishingInProgress = true;
    keywords = subject.toLowerCase().split(' ');

  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('$collectionPost')
    .doc('$_timestampCreation$currentUser')
    .set({
      'withImage': withImage,
      'imageURL': imageURL,
      'adminNotificationsToken': currentNotificationsToken,
      'adminProfilephoto': currentUserPhoto,
      'adminUID': currentUser,
      'adminUsername': currentUserUsername,
      'body': body,
      'commentedBy': FieldValue.arrayUnion(['000000']),
      'comments': 0,
      'likedBy': FieldValue.arrayUnion(['000000']),
      'likes': 0,
      //
      'postID': '$_timestampCreation$currentUser',
      'subject': subject,
      'timestamp': _timestampCreation,
      'keywords': FieldValue.arrayUnion(keywords),
      'savedBy': FieldValue.arrayUnion([000000]),
      'reactedBy': {
        '$currentUser': currentNotificationsToken,
      }
    }).whenComplete(() {
      print('Cloud firestore : $collectionPost uploaded');
      subjectEditingController.clear();
      bodyEditingController.clear();
      setState((){
        publishingInProgress = false;
      });
      Navigator.pop(context);
    });
  });
  }

































publicationPostWithOrWithoutPhoto(
  bool withImage,
  String imageURL,
  String currentUser,
  String currentUserUsername,
  String currentUserPhoto,
  String currentNotificationsToken,
  String currentSoundCloud,
  String body, 
  String subject, 
  StateSetter setState, 
  bool publishingInProgress, 
  BuildContext context, 
  TextEditingController subjectEditingController, 
  TextEditingController bodyEditingController, 
  int typeOfPost) {


  List<String> keywords;
  setState((){
    publishingInProgress = true;
    keywords = subject.toLowerCase().split(' ');
  });
  
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('posts')
    .doc('$_timestampCreation$currentUser')
    .set({
      'withImage': withImage,
      'imageURL': imageURL,
      'adminNotificationsToken': currentNotificationsToken,
      'adminProfilephoto': currentUserPhoto,
      'adminSoundCloud': currentSoundCloud,
      'adminUID': currentUser,
      'adminUsername': currentUserUsername,
      'body': body,
      'fires': 0,
      'firedBy': FieldValue.arrayUnion(['000000']),
      'rockets': 0,
      'rocketedBy': FieldValue.arrayUnion(['000000']),
      'commentedBy': FieldValue.arrayUnion(['000000']),
      'comments': 0,
      'dislikedBy': FieldValue.arrayUnion(['000000']),
      'dislikes': 0,
      'likedBy': FieldValue.arrayUnion(['000000']),
      'likes': 0,
      //
      'postID': '$_timestampCreation$currentUser',
      'subject': subject,
      'timestamp': _timestampCreation,
      'typeOfPost': typeOfPost == 0 ? 'issue' : typeOfPost == 1 ? 'tip' : 'project',
      'keywords': FieldValue.arrayUnion(keywords),
      'savedBy': FieldValue.arrayUnion([000000]),
      'reactedBy': {
        '$currentUser': currentNotificationsToken,
      }
    }).whenComplete(() {
      print('Cloud firestore : publication done');
      subjectEditingController.clear();
      bodyEditingController.clear();
      setState((){
        publishingInProgress = false;
      });
      Navigator.pop(context);
    });
}




/*publicationRequestForPost(
  String currentUser,
  String currentUserUsername,
  String currentUserPhoto,
  String currentNotificationsToken,
  String currentSoundCloud,
  String body, 
  String subject, 
  StateSetter setState, 
  bool publishingInProgress, 
  BuildContext context, 
  TextEditingController subjectEditingController, 
  TextEditingController bodyEditingController, 
  int typeOfPost) {


  List<String> keywords;
  setState((){
    publishingInProgress = true;
    keywords = subject.toLowerCase().split(' ');
  });
  
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('test')
    .doc('$_timestampCreation$currentUser')
    .set({
      'adminNotificationsToken': currentNotificationsToken,
      'adminProfilephoto': currentUserPhoto,
      'adminSoundCloud': currentSoundCloud,
      'adminUID': currentUser,
      'adminUsername': currentUserUsername,
      'body': body,
      'fires': 0,
      'firedBy': FieldValue.arrayUnion(['000000']),
      'rockets': 0,
      'rocketedBy': FieldValue.arrayUnion(['000000']),
      'commentedBy': FieldValue.arrayUnion(['000000']),
      'comments': 0,
      'dislikedBy': FieldValue.arrayUnion(['000000']),
      'dislikes': 0,
      'likedBy': FieldValue.arrayUnion(['000000']),
      'likes': 0,
      //
      'postID': '$_timestampCreation$currentUser',
      'subject': subject,
      'timestamp': _timestampCreation,
      'typeOfPost': typeOfPost == 0 ? 'issue' : typeOfPost == 1 ? 'tip' : 'project',
      'keywords': FieldValue.arrayUnion(keywords),
      'savedBy': FieldValue.arrayUnion([000000]),
      'reactedBy': {
        '$currentUser': currentNotificationsToken,
      }
    }).whenComplete(() {
      print('Cloud firestore : publication done');
      subjectEditingController.clear();
      bodyEditingController.clear();
      setState((){
        publishingInProgress = false;
      });
      Navigator.pop(context);
    });
}*/

  publicationRequestForFeedback(
  String trackURL,
  double trackDuration,
  int divisions,
  double startParticularPart,
  double endParticularPart,
  String currentUser,
  String currentUserUsername,
  String currentUserPhoto,
  String currentNotificationsToken,
  String currentSoundCloud,
  String body, 
  String subject, 
  StateSetter setState, 
  bool publishingInProgress, 
  BuildContext context, 
  TextEditingController subjectEditingController, 
  TextEditingController bodyEditingController, 
  int typeOfPost) {

  List<String> keywords = ['feedback', 'section'];
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('feedbacks')
    .doc('$_timestampCreation$currentUser')
    .set({
      'trackURL': trackURL,
      'trackDuration': trackDuration,
      'divisions': divisions,
      'startParticularPart': startParticularPart,
      'endParticularPart': endParticularPart,
      'adminNotificationsToken': currentNotificationsToken,
      'adminProfilephoto': currentUserPhoto,
      'adminSoundCloud': currentSoundCloud,
      'adminUID': currentUser,
      'adminUsername': currentUserUsername,
      'body': body,
      'fires': 0,
      'firedBy': FieldValue.arrayUnion(['000000']),
      'rockets': 0,
      'rocketedBy': FieldValue.arrayUnion(['000000']),
      'commentedBy': FieldValue.arrayUnion(['000000']),
      'comments': 0,
      'dislikedBy': FieldValue.arrayUnion(['000000']),
      'dislikes': 0,
      'likedBy': FieldValue.arrayUnion(['000000']),
      'likes': 0,
      //
      'postID': '$_timestampCreation$currentUser',
      'subject': subject,
      'timestamp': _timestampCreation,
      'typeOfPost': 'feedback',
      'keywords': FieldValue.arrayUnion(keywords),
      'savedBy': FieldValue.arrayUnion([000000]),
      'reactedBy': {
        '$currentUser': currentNotificationsToken,
      }
    }).whenComplete(() {
      print('Cloud firestore : publication done');
      subjectEditingController.clear();
      bodyEditingController.clear();
      Navigator.pop(context);
    });
}



//Like request


likeRequest(String typeOfPost, String postID, int likes, String subject, String currentUser, String currentUsername, List<dynamic> likedByList, String adminUID, String adminNotificationToken, String currentProfilephoto) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'likes': likes+1,
      'likedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() {
      print('Cloud firestore : Postliked');
      if(currentUser == adminUID) {
        print('No notifications sended cause currenUser is the admin.');
      } else {
      FirebaseFirestore.instance
        .collection('users')
        .doc(adminUID)
        .collection('notifications')
        .doc(_timestampCreation.toString()+currentUser)
        .set({
          'alreadySeen': false,
          'notificationID': _timestampCreation.toString()+currentUser,
          'body': 'has liked this post 👍',
          'currentNotificationsToken': adminNotificationToken,
          'lastUserProfilephoto': currentProfilephoto,
          'lastUserUID': currentUser,
          'lastUserUsername': currentUsername,
          'postID': postID,
          'title': subject,
        }).whenComplete(() {
          print('Cloud firestore : notifications added (AdminUID)');
        });
      }
    });
}

deletelikeRequest(String typeOfPost, String postID, int likes, String currentUser, List<dynamic> likedByList) {
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'likes': likes-1,
      'likedBy': FieldValue.arrayRemove([currentUser]),
    }).whenComplete(() => print('Cloud firestore : like removed'));
}

///Like end
///
///
///
///
///
fireRequest(String typeOfPost, String postID, int fires, String subject, String currentUser, String currentUsername, List<dynamic> firedByList, String adminUID, String adminNotificationToken, String currentProfilephoto) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'fires': fires+1,
      'firedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() {
      print('Cloud firestore : PostFired');
      if(currentUser == adminUID) {
        print('No notifications sended cause currenUser is the admin.');
      } else {
      FirebaseFirestore.instance
        .collection('users')
        .doc(adminUID)
        .collection('notifications')
        .doc(_timestampCreation.toString()+currentUser)
        .set({
          'alreadySeen': false,
          'notificationID': _timestampCreation.toString()+currentUser,
          'body': 'has put a fire on this post 🔥',
          'currentNotificationsToken': adminNotificationToken,
          'lastUserProfilephoto': currentProfilephoto,
          'lastUserUID': currentUser,
          'lastUserUsername': currentUsername,
          'postID': postID,
          'title': subject,
        }).whenComplete(() {
          print('Cloud firestore : notifications added (AdminUID)');
        });
      }
    });
}

deleteFireRequest(String typeOfPost, String postID, int fires, String currentUser, List<dynamic> firedByList) {
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'fires': fires-1,
      'firedBy': FieldValue.arrayRemove([currentUser]),
    }).whenComplete(() => print('Cloud firestore : fire removed'));
}


///
///
///
///
//Rocket request
rocketRequest(String typeOfPost, String postID, int rockets, String subject, String currentUser, String currentUsername, List<dynamic> rocketedByList, String adminUID, String adminNotificationToken, String currentProfilephoto) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'rockets': rockets+1,
      'rocketedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() {
      print('Cloud firestore : PostRocketed');
      if(currentUser == adminUID) {
        print('No notifications sended cause currentUser is the admin.');
      } else {
      FirebaseFirestore.instance
        .collection('users')
        .doc(adminUID)
        .collection('notifications')
        .doc(_timestampCreation.toString()+currentUser)
        .set({
          'alreadySeen': false,
          'notificationID': _timestampCreation.toString()+currentUser,
          'body': 'has put a rocket on this post 🚀',
          'currentNotificationsToken': adminNotificationToken,
          'lastUserProfilephoto': currentProfilephoto,
          'lastUserUID': currentUser,
          'lastUserUsername': currentUsername,
          'postID': postID,
          'title': subject,
        }).whenComplete(() {
          print('Cloud firestore : notifications added (AdminUID)');
        });
      }
    });
}

deleteRocketRequest(String typeOfPost, String postID, int rockets, String currentUser, List<dynamic> rocketedByList) {
  FirebaseFirestore.instance
    .collection(typeOfPost == 'feedback'? 'feedbacks' : 'posts')
    .doc(postID)
    .update({
      'rockets': rockets-1,
      'rocketedBy': FieldValue.arrayRemove([currentUser]),
    }).whenComplete(() => print('Cloud firestore : rocket removed'));
}