// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/LogIn&signUp/signup_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/workerPages/ongoingReq_page.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/workerPages/worker_profile_page.dart';
import 'workerPages/home_page.dart';
bool isLogin;
dynamic uid;
dynamic Wid;
dynamic Cid;
List workers=[];
CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
List customers=[];
CollectionReference Customers = FirebaseFirestore.instance.collection('customer');

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user =FirebaseAuth.instance.currentUser;
  uid=FirebaseAuth.instance.currentUser.uid;

  if(user==null){
    isLogin=false;
  }
  else
    isLogin=true;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getData()async{
    globals.isUser=true;
    var Wresponse=await Workers.get();
    var Cresponse=await Customers.get();
    Wresponse.docs.forEach((element) {
      if(element['workerUID']==uid) {
        workers.add(element['id']);
        Wid=element['id'];
        globals.isUser=false;
        print("==========================================");
        print('is worker');
        print("==========================================");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return WorkerHomePage();
        }
        )
        );
      }
    });
    if(globals.isUser)
    {
      Cresponse.docs.forEach((element) {
        if(element['customerUID']==uid) {
          workers.add(element['id']);
          Cid=element['id'];
          print("==========================================");
          print('is customer');
          print("==========================================");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return UserHomePage();
          }
          )
          );
        }
      });
    }
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin==false
          ?LoginPage()
          :globals.isUser==false
            ?WorkerHomePage()
            :globals.userOnReq
              ?WorkerInUserProfilePage(id:globals.WorkerIdForMain)
              :UserHomePage()
    ,
      routes: {
    "login" :(context)=> LoginPage(),
        "userSettings":(context)=> UserSettingPage(),
        "workerHome":(context)=> WorkerHomePage(),

      },
    );
  }
}
//LoginPage