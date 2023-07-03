library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

dynamic isUser = true;
dynamic userOnReq = false;
late dynamic WorkerIdForMain = '';
dynamic uid = '';
String BGImg = 'images/background.png';
String AppBarIcon = "worker-icon2.png";
Color ContColor = Colors.grey.withOpacity(0.75);
Color backColor=Color(0xff33f0b7a1);
Color boxColor=Colors.indigo.shade50;
class FireBase {
  var user = FirebaseAuth.instance.currentUser;
  User() {return FirebaseAuth.instance.currentUser;}
  
  replys(){return FirebaseFirestore.instance.collection('replys');}

  Uid() {
    if (user == null) {
    } else {return FirebaseAuth.instance.currentUser?.uid;}
  }

  signOut() {return FirebaseAuth.instance.signOut();}

  workerComplains() {return FirebaseFirestore.instance.collection('workerComplains');}

  customerComplains() {return FirebaseFirestore.instance.collection('customerComplains');}

  customer() {return FirebaseFirestore.instance.collection('customer');}

  worker() {return FirebaseFirestore.instance.collection('worker');}

  requests() {return FirebaseFirestore.instance.collection('requests');}

  posts() {return FirebaseFirestore.instance.collection('posts');}

  categories() {return FirebaseFirestore.instance.collection('categories');}
}
