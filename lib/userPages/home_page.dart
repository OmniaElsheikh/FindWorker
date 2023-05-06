import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/t_key.dart';
import 'package:gp_1/userPages/categories_page.dart';
import 'package:gp_1/userPages/notification_page.dart';
import 'package:gp_1/userPages/user_profile.dart';

import '../controller/localization_service.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectedindex = 2;
  List <Widget> Widgets=[
    Notifications(),
    UserProfile(),
    CategoriesPage(),
  ];

  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedindex,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.indigo.shade900,
          selectedFontSize: 20,
          onTap: (index){
            setState((){
              selectedindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(label: TKeys.WnavbarNotificationButton.translate(context), icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(label: TKeys.WnavbarProfileButton.translate(context), icon: Icon(Icons.person_pin)),
            BottomNavigationBarItem(label: TKeys.WcategoriesTitle.translate(context), icon: Icon(Icons.home)),

          ],
        ),
            body: Widgets.elementAt(selectedindex),
    );
  }
}


