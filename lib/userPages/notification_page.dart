import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import 'User_ongoingReq_page.dart';

late globals.FireBase db = new globals.FireBase();

late dynamic Cid = '';
late dynamic uid;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List customers = [];
  CollectionReference Customers = db.customer();
  List requests = [];
  getData() async {
    var response = await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['customerUID'] == uid) {
          setState(() {
            Cid = element['id'];
          });
        }
      });
    });
  }

  @override
  void initState() {
    uid = db.Uid();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          "Notifications",
          style: TextStyle(color: Colors.deepOrange),
        )),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(globals.BGImg),
          fit: BoxFit.fill,
        )),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: db
                    .requests()
                    .where("customerId", isEqualTo: Cid)
                    .where("reqStatus", whereIn: ["Pending", "On"]).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: const Text(
                      "Loading",
                      style: TextStyle(fontSize: 30),
                    ));
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: const Text(
                      "Loading",
                      style: TextStyle(fontSize: 30),
                    ));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          if (snapshot.data?.docs[i]['reqStatus'] == 'Pending') {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text(
                                    'Note',
                                    style: TextStyle(
                                        color: Colors.indigo.shade900,
                                        fontSize: 20),
                                  ),
                                  content: Text(
                                    'You Can Come Back When The Worker Accept The Job',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      color: Colors.deepOrange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
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
                          } else if (snapshot.data?.docs[i]['reqStatus'] == 'On') {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return UserOngoingRequestPage(
                                  id: snapshot.data?.docs[i].id);
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: Text(
                                              "${snapshot.data?.docs[i]['workerName']}",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo.shade900),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              "${snapshot.data?.docs[i]['reqStatus']} Request",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.deepOrange),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: Text(
                                              "Rate : ${snapshot.data?.docs[i]['workerRate']}",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo.shade900),
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
                }),
            StreamBuilder<QuerySnapshot>(
                stream: db.replys().where("customerId",isEqualTo: Cid).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                  {
                    return const Center(child: Text("Loading",style: TextStyle(color: Colors.white,fontSize: 30),),);
                  }
                  if(snapshot.hasError)
                  {
                    return const Center(child: Text("Loading",style: TextStyle(color: Colors.white,fontSize: 30),),);
                  }
                  return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context,i)=>Container(
                        height: 100,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                            color: globals.ContColor,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ListTile(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                backgroundColor: Colors.white,
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Complain About Worker : ",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Text("${snapshot.data?.docs[i]['workerName']}",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10,),
                                    Text("Complain Content :",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5,),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey.shade300
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: Text("${snapshot.data?.docs[i]['content']}",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Reply For Your Complain:",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5,),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey.shade300
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text("${snapshot.data?.docs[i]['reply']}",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                actions: [

                                  MaterialButton(
                                    onPressed: (){
                                      db.replys().doc(snapshot.data?.docs[i].id).delete();
                                      Navigator.of(context).pop();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    minWidth: 50,
                                    height: 30,
                                    color: Colors.indigo.shade900,
                                    child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),),),
                                ],
                              );
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Reply For Your Previous Complain",style: TextStyle(color: Colors.indigo[900],fontSize: 20,fontWeight: FontWeight.bold),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: (){
                                          db.replys().doc(snapshot.data?.docs[i].id).delete();
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        minWidth: 50,
                                        height: 30,
                                        color: Colors.white,
                                        child: Icon(Icons.delete,color: Colors.deepOrange,size: 25,),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context,i)=>SizedBox(height: 5,),
                      itemCount: snapshot.data!.docs.length
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
