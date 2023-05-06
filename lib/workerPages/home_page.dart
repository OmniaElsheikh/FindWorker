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
}
