import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/workerPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import '../controller/localization_service.dart';
import '../t_key.dart';
import 'notification_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class WorkerHomePage extends StatefulWidget {
  final uid;
  const WorkerHomePage({this.uid,Key? key}) : super(key: key);

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int selectedindex = 1;
  List <Widget> Widgets=[
    NotificationPage(),
    WorkerProfilePage(),
    SettingPage(),
  ];

  dynamic uid='';
  dynamic customerName='',reqStatus='';
  getData(){
    uid=FirebaseAuth.instance.currentUser?.uid;
    var id='';
    FirebaseFirestore.instance.collection('worker').where('workerUID',isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          id=element['id'];
        });
        print("=================بهى==============="+id);
      });
    });
    FirebaseFirestore.instance.collection('requests').where("workerId",isEqualTo:id).where("reqStatus",isEqualTo:'On').get().then((value) {
      value.docs.forEach((element) {
        print('true');
        customerName=element['customerName'];
        reqStatus=element['reqStatus'];

      });
      print(customerName+"=================بهى==============="+reqStatus);
    });
  }
  @override
  void initState(){
    getData();
  }

  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.indigo[900],
          selectedFontSize: 18,
          showUnselectedLabels: true,
          currentIndex: selectedindex,
          onTap: (index){
            setState((){
              selectedindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(label: TKeys.WnavbarNotificationButton.translate(context), icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(label: TKeys.WnavbarProfileButton.translate(context), icon: Icon(Icons.person)),
            BottomNavigationBarItem(label: TKeys.WnavbarEditButton.translate(context), icon: Icon(Icons.settings)),
          ],
        ),
            body: Widgets.elementAt(selectedindex),
    );
  }

  showNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'the first notification',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'my first notification',
      'a very long message for the user of app',
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
}


