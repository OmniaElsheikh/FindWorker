// @dart=2.9
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/LogIn&signUp/signup_page.dart';
import 'package:gp_1/workerPages/ongoingReq_page.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/workerPages/worker_profile_page.dart';
import 'workerPages/home_page.dart';
bool isLogin;
bool isWorker;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user =FirebaseAuth.instance.currentUser;
  if(user==null){
    isLogin=false;
  }
  else
    isLogin=true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin==false
          ?LoginPage()
          :globals.isUser
            ?UserHomePage()
            :WorkerHomePage()
    ,
      routes: {
    "login" :(context)=> LoginPage(),
        "userSettings":(context)=> UserSettingPage(),
      },
    );
  }
}
//LoginPage