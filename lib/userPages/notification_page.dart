import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import 'User_ongoingReq_page.dart';
late dynamic Cid='';
late dynamic uid;
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
  List customers=[];
  CollectionReference Customers = FirebaseFirestore.instance.collection('customer');
  List requests=[];
  getData()async{
    var response=await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['customerUID']==uid) {
          setState(() {
            Cid=element['id'];
          });
        }
      });
    });
  }
  @override
  void initState() {
    uid=FirebaseAuth.instance.currentUser?.uid;
    getData();
    super.initState();
  }
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
        child: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('requests').where("customerId",isEqualTo: Cid).where("reqStatus",whereIn: ["Pending","On"]).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: (){
                    if(snapshot.data?.docs[i]['reqStatus']=='Pending')
                      {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              title: Text('Note',style:TextStyle(color: Colors.indigo.shade900,fontSize: 20),),
                              content: Text('You Can Come Back When The Worker Accept The Job',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              actions: <Widget>[
                                MaterialButton(
                                  color: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    else if(snapshot.data?.docs[i]['reqStatus']=='On')
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return UserOngoingRequestPage(id:snapshot.data?.docs[i].id);
                      }));
                    }
                  },
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
                                    "${snapshot.data?.docs[i]['workerImage']}",
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
                                        "${snapshot.data?.docs[i]['workerName']}",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,color: Colors.indigo.shade900),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        "${snapshot.data?.docs[i]['reqStatus']} Request",
                                        style: TextStyle(fontSize: 20,color: Colors.deepOrange),
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
            );
          }
        ),
      ),
    );
  }
}
