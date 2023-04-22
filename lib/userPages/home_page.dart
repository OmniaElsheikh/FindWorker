import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/userPages/categories_page.dart';
import 'package:gp_1/userPages/notification_page.dart';
import 'package:gp_1/userPages/user_profile.dart';

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
            BottomNavigationBarItem(label: "Notification", icon: Icon(Icons.notifications)),
            BottomNavigationBarItem(label: "My Profile", icon: Icon(Icons.person_pin)),
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),

          ],
        ),
            body: Widgets.elementAt(selectedindex),
    );
  }
}


