// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:gp_1/LogIn&signUp/signup_page.dart';
import 'package:gp_1/controller/localization_service.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/workerPages/complain_page.dart';
import 'package:gp_1/workerPages/worker_categories_page.dart';
import 'package:gp_1/workerPages/notification_page.dart';
import 'package:gp_1/workerPages/ongoingReq_page.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/workerPages/worker_profile_page.dart';
import 'userPages/User_complain_page.dart';
import 'userPages/User_ongoingReq_page.dart';
import 'userPages/categories_page.dart';
import 'userPages/filterd_page.dart';
import 'userPages/notification_page.dart';
import 'userPages/user_profile.dart';
import 'workerPages/home_page.dart';

globals.FireBase db = new globals.FireBase();

bool isLogin;
dynamic uid = '';
dynamic Wid;
dynamic Cid;
List workers = [];
CollectionReference Workers = db.worker();
List customers = [];
CollectionReference Customers = db.customer();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  print('============================start');
  await Firebase.initializeApp();
  print('============================load');

  var user = db.User();
  if (user == null) {
    print("=======================================no user found");
    isLogin = false;
  } else {
    print("=======================================user found");
    uid = db.Uid();
    print("=======================================user $uid");
    isLogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getData() async {
    globals.isUser = true;
    var Wresponse = await Workers.get();
    var Cresponse = await Customers.get();
    Wresponse.docs.forEach((element) {
      if (element['workerUID'] == uid) {
        workers.add(element['id']);
        Wid = element['id'];
        setState(() {
          globals.isUser = false;
        });
        print("==========================================");
        print('is worker');
        print("==========================================");
      }

    });
    if (globals.isUser) {
      Cresponse.docs.forEach((element) {
        if (element['customerUID'] == uid) {
          workers.add(element['id']);
          Cid = element['id'];
          print("==========================================");
          print('is customer');
          print("==========================================");
        }
      });
    }
  }

  @override
  void initState() {
    uid=db.Uid();
    getData();
    super.initState();
  }

  final localizationController=Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      init: localizationController,
      builder:(LocalizationController _controller){
        print('========================here');
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          //localeResolutionCallback: LocalizationService.localeResolutionCallBack,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: LocalizationService.localizationsDelegate,
          locale: _controller.currentLanguage != ''
          ?Locale(_controller.currentLanguage,'')
          :null,
          home: isLogin == false
              ? LoginPage()
              : globals.isUser == false
              ? WorkerHomePage()
              : UserHomePage(),
          routes: {
            "login": (context) => LoginPage(),
            "signup": (context) => SignupPage(),
            "workerHomePage": (context) => WorkerHomePage(),
            "workerProfilePage": (context) => WorkerProfilePage(),
            "workerSettingPage": (context) => SettingPage(),
            "workerNotificationPage": (context) => NotificationPage(),
            "workeComplainPage": (context) => ComplainPage(),
            "workerOngoingRequestPage": (context) => OngoingRequestPage(),
            "workerCategoriesPage": (context) => workerCategoriesPage(),
            "customerHomePage": (context) => UserHomePage(),
            "customerProfilePage": (context) => UserProfile(),
            "customerSettingPage": (context) => UserSettingPage(),
            "customerNotificationPage": (context) => Notifications(),
            "customerComplainPage": (context) => UserComplainPage(),
            "customerOngoingRequestPage": (context) => UserOngoingRequestPage(),
            "customerCategoriesPage": (context) => CategoriesPage(),
            "customerFilterPage": (context) => FilterdPage(),
            "customerWorkerProfilePage": (context) => WorkerInUserProfilePage(),
          },
        );
      }
    );
  }
}
//LoginPage