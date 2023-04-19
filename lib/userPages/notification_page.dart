import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

List notifications = [
  {
    'name': "motasem mohamed",
    'img':
        "https://th.bing.com/th/id/R.7b4e5903c7de5337a73e00f00d73f36d?rik=WrtiSDesVmn8Og&pid=ImgRaw&r=0",
    'message': "job accepted"
  },
  {
    'name': "omnia mohamed",
    'img':"https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",
      'message': "job done"
  },
];

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text("Notifications",style: TextStyle(color: Colors.deepOrange),)),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(globals.BGImg),
              fit: BoxFit.fill,
            )
        ),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, i) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: globals.ContColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage: NetworkImage(
                                "${notifications[i]['img']}",
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    "${notifications[i]['name']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    "${notifications[i]['message']}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
