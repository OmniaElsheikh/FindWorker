import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/userPages/filterd_page.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/workerPages/worker_filterd_page.dart';

import '../controller/localization_service.dart';
import '../t_key.dart';
import 'home_page.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
late globals.FireBase db=new globals.FireBase();

class WorkerInWorkerProfilePage extends StatefulWidget {
  final id;
  final cateName;
  const WorkerInWorkerProfilePage({this.id,this.cateName,Key? key}) : super(key: key);

  @override
  State<WorkerInWorkerProfilePage> createState() => _WorkerInWorkerProfilePageState();
}
bool favorit = false;
bool isRequested= false;
late dynamic reqId='';
late dynamic Wid='';
late dynamic Cid='';
late dynamic Cname='';
late dynamic Cphone='';
late dynamic Cimage='';
late dynamic Wname='';
late dynamic Wphone='';
late dynamic Wimage='';
late dynamic Wrate=0;
late dynamic Crate=0;

late dynamic uid;
late dynamic data={'':dynamic};
late dynamic reqstatus='';
class _WorkerInWorkerProfilePageState extends State<WorkerInWorkerProfilePage> {
  List workers=[];
  CollectionReference Workers = db.worker();
  List customer=[];
  CollectionReference customers = db.worker();
  List Request=[];
  CollectionReference Requests = db.requests();

  getData()async{
    var response=await Workers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['id']==widget.id) {
          setState(() {
            workers.add(element['id']);
            Wid=element['id'];
            Wname=element['workerName'];
            Wphone=element['phone'];
            Wimage=element['imageURL'];
            Wrate=element['rate'];
            globals.WorkerIdForMain=widget.id;
          });
          print(Wid);
        }
      });
    });

    var response1=await customers.get();
    response1.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
          setState(() {
            Cid=element['id'];
            Cname=element['workerName'];
            Cphone=element['phone'];
            Cimage=element['imageURL'];
            Crate=element['rate'];
            print(element.id);
          });
        }
      });
    });
    setState(() {
     reqstatus='';
    });
    await Requests.where("customerId",isEqualTo:Cid).where("workerId",isEqualTo: Wid).get().then((value) {
      value.docs.forEach((element) {
        if(element['reqStatus']=='Pending'||element['reqStatus']=='On')
        {
          setState(() {
            reqId=element.id;
            reqstatus=element['reqStatus'];
            return reqstatus;
          });
        }
        else
        {
          setState(() {
            reqstatus='false';
            return reqstatus;
          });
        }
      });
    });
    setState(() {
      if(reqstatus==null)
        reqstatus='';
    });
    Stream<QuerySnapshot> usersSnapshot = await Workers.doc(widget.id).get().then(
          (DocumentSnapshot doc){
            setState(() {
              data = doc.data() as Map<String, dynamic>;
            });
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    
  }

  updateWorkerReq(){
    DocumentReference documentReference1=Workers.doc(Wid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot1 = await transaction.get(documentReference1);
      if (!snapshot1.exists) {
        throw Exception("User does not exist!");
      }
      int newWarnCount = snapshot1['prevReq']+1;
      transaction.update(documentReference1, {'prevReq': newWarnCount});

      return newWarnCount;
    });
  }
  updateCustomerReq(){
    DocumentReference documentReference2=customers.doc(Cid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot1 = await transaction.get(documentReference2);
      if (!snapshot1.exists) {
        throw Exception("User does not exist!");
      }
      int newWarnCount = snapshot1['prevReq']+1;
      transaction.update(documentReference2, {'prevReq': newWarnCount});

      return newWarnCount;
    });
  }

  @override
  void initState() {
    uid=db.Uid();
    getData();
    super.initState();
  }

  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(TKeys.WworkerInWorkerTitle.translate(context),style: TextStyle(
            color: Colors.deepOrange
          ),),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.deepOrange
        ),
        automaticallyImplyLeading: false,
        leading: globals.userOnReq
            ?IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepOrange,onPressed: (){
        },)
        :IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepOrange,onPressed: (){
          widget.cateName!=null
          ?Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return WorkerFilterdPage(cateName: widget.cateName,);
          }))
          :Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return WorkerHomePage();
          }));
        },),
      ),
      body:workers.isEmpty
          ?Container(child:Center(child: Text("Loading",style: TextStyle(color: Colors.indigo.shade900,fontSize: 35),),),)
          :StreamBuilder(
          stream:Workers.doc(widget.id).get().asStream(),
          builder: (BuildContext context,snapshot){
            print(reqstatus+"=========================here===========");
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }

            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: globals.backColor
              ),
              child: ListView(
                children:[
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: globals.boxColor,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network("${data['imageURL']}",fit: BoxFit.fill,width: 109,height: 180,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data['workerName']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${data['phone']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        SizedBox(width:8),
                                        MaterialButton(
                                            height: 20,
                                            color:Colors.white,
                                            minWidth:15,
                                            shape:RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(35)
                                            ),
                                            onPressed: ()=>UrlLauncher.launchUrl(Uri.parse('tel:${data['phone']}')), child: Icon(Icons.phone,color:Colors.green,size:18)
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${TKeys.CfilterdRate.translate(context)} : ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          RatingBar.builder(
                                            itemSize: 12,
                                            glowColor:
                                            Colors
                                                .amber,
                                            itemPadding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                4),
                                            initialRating: data['rate']
                                                .toDouble(),
                                            itemCount: 5,
                                            itemBuilder:
                                                (context,
                                                i) {
                                              return Icon(
                                                  Icons
                                                      .star,
                                                  color: Colors
                                                      .amber);
                                            }, onRatingUpdate: (double value) {  },),
                                        ],
                                      ),
                                    ),
                                    Row(
                                          children: [
                                            Expanded(
                                              child: MaterialButton(
                                                minWidth: 30,
                                                onPressed: () {
                                                  setState(() {
                                                  });
                                                  if(reqstatus=="Pending"||reqstatus=='On')
                                                    {
                                                      Requests.doc(reqId).delete();
                                                      setState(() {
                                                        getData();
                                                      });
                                                      print("Canceled=================");
                                                    }
                                                  else {
                                                      Requests.add({'customerId':Cid, 'workerId':Wid,
                                                        'reqStatus':'Pending', 'customerName':Cname, 'customerPhone':Cphone, 'customerImage':Cimage,
                                                        'customerRate':Crate, 'workerName':Wname, 'workerPhone':Wphone, 'workerImage':Wimage,
                                                        'workerRate':Wrate,
                                                      }
                                                    );
                                                      setState(() {
                                                        getData();
                                                      });
                                                      print('success------------------------------');
                                                    }
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                textColor: Colors.deepOrange,
                                                color: Colors.white,
                                                child: Text(reqstatus=='Pending'||reqstatus=='On'?TKeys.WworkerInWorkerCancelReq.translate(context):TKeys.WworkerInWorkerSendReq.translate(context),style:reqstatus=='Pending'||reqstatus=='On'? TextStyle(color: Colors.red):TextStyle(color: Colors.green),),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                    Container(
                                        margin: EdgeInsets.only(top: 1),
                                        child:Text( reqstatus=='Pending'||reqstatus=='On'?TKeys.WworkerInWorkerYouOnReq.translate(context):TKeys.WworkerInWorkerYouSendReq.translate(context),style: reqstatus=='Pending'||reqstatus=='On'?TextStyle(color: Colors.red,fontWeight: FontWeight.bold):TextStyle(color: Colors.green,fontWeight: FontWeight.bold),))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Center(child: Text(TKeys.WworkerInWorkerWork.translate(context),style: TextStyle(color: Colors.black,fontSize: 25),),),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: globals.boxColor,
                        ),
                        child:  StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('posts').where("workerId",isEqualTo:'$Wid').snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData)
                                return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
                              if(snapshot.hasError)
                                return Center(child: const Text("Something Went wrong",style: TextStyle(fontSize: 30),));
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 10),
                                itemBuilder: (context, i) => Container(
                                  width: 100
                                  ,height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        child: Image.network(
                                          "${snapshot.data?.docs[i]['imageURL']}",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            );}),
    );
  }
}
