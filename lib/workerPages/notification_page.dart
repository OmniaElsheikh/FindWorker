import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import '../controller/localization_service.dart';
import '../t_key.dart';
import 'home_page.dart';
import 'ongoingReq_page.dart';

late globals.FireBase db=new globals.FireBase();

late dynamic Wid='';
late dynamic Cid='';
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

bool isRequested= false;
var textforbutton="Send Request";
dynamic count=4;
class _NotificationPageState extends State<NotificationPage> {

  List workers=[];
  CollectionReference Workers = db.worker();
  List customers=[];
  CollectionReference Customers = db.customer();
  List requests=[];

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
    DocumentReference documentReference2=Customers.doc(Cid);
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

  getData()async{
    var response=await Workers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
          setState(() {
            Wid=element['id'];
          });
        }
      });
    });
  }

  CollectionReference Noti =  db.requests();
  deleteNoti(Docid)async{
    var response=await Noti.get();
    response.docs.forEach((element) {
      setState(() {
        if(element.id==Docid) {
          Noti.doc(Docid).delete();
        }
      });
    });
  }
  statusNoti(BuildContext context,Docid)async{
    var response=await Noti.get();
    response.docs.forEach((element) {
      setState(() {
        if(element.id.toString()==Docid.toString()) {
          Noti.doc(Docid).update({
            "reqStatus":"On"
          });
        }
      });
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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading:Container(
            margin: EdgeInsets.all(3),
            child: CircleAvatar(foregroundImage: AssetImage("images/worker-icon2.png"),
            )
        ),
        title: Center(
          child: Text(
            TKeys.WnotificationTitle.translate(context),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        actions: [
          SizedBox(width: 5,),
          IconButton(onPressed: ()async{
            await db.signOut();
            Navigator.of(context).pushReplacement( MaterialPageRoute (
              builder: (BuildContext context) => const LoginPage(),));
          }, icon:Icon(Icons.logout_outlined,color: Colors.deepOrange,)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(globals.BGImg),
              fit: BoxFit.fill,
            )
        ),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: db.requests().where("workerId",isEqualTo: Wid).snapshots(),
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
                        height: 115,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                            color: globals.ContColor,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ListTile(
                          onTap: (){
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  child: CircleAvatar(foregroundImage: NetworkImage("${snapshot.data?.docs[i]['customerImage']}"),
                                  )),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?.docs[i]['reqStatus']=='Pending'?TKeys.WnotiIncomingReq.translate(context):TKeys.WnotiOngoingReq.translate(context),style: TextStyle(color: Colors.red.shade200,fontSize: 15),),
                                  Text("Name : ${snapshot.data?.docs[i]['customerName']}",style: TextStyle(color: Colors.black)),
                                  MaterialButton(
                                    onPressed: (){
                                      showBottomSheet(backgroundColor:Colors.black26.withOpacity(0.5),context: context, builder: (context){
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[500],
                                          title: Text(TKeys.WnotiMoreInfoTitle.translate(context)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40)
                                          ),
                                          content: Container(
                                              height: 300,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    width: 150,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Image.network("${snapshot.data?.docs[i]['customerImage']}",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Text("Name : ${snapshot.data?.docs[i]['customerName']}",style: TextStyle(fontWeight: FontWeight.bold)),
                                                  SizedBox(height: 5,),
                                                  Text("Estimated Time : 5 Minutes",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.deepOrange,size: 20,),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Rate : ${snapshot.data?.docs[i]['customerRate'].toStringAsFixed(2)}",
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.phone, color: Colors.deepOrange,size: 20,),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Phone : ${snapshot.data?.docs[i]['customerPhone']}",
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  height: 40,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  color: Colors.indigo.shade900,
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(TKeys.WnotiMoreInfoOkButton.translate(context),style: TextStyle(color: Colors.white,fontSize: 20),),
                                                ),
                                                SizedBox(width: 10,),
                                              ],
                                            )

                                          ],
                                        );
                                      });

                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    height: 30,
                                    color: Colors.indigo,
                                    child: Text(TKeys.WnotiMoreInfoButton.translate(context),style: TextStyle(color: Colors.white),),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              snapshot.data?.docs[i]['reqStatus']=='Pending'?Expanded(
                                flex: 18,
                                child: MaterialButton(
                                  minWidth: 80,
                                  height: 30,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.green,
                                  onPressed: (){
                                    setState(() {
                                      Cid=snapshot.data?.docs[i]['customerId'];
                                    });
                                    updateCustomerReq();
                                    updateWorkerReq();
                                    statusNoti(context,snapshot.data?.docs[i].id);
                                  },
                                  child: Text(TKeys.WnotiAcceptReq.translate(context),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                ),
                              ):Text("${snapshot.data?.docs[i]['reqStatus']} Request",style: TextStyle(color: Colors.white,fontSize: 18),),
                              SizedBox(width: 5,),
                              snapshot.data?.docs[i]['reqStatus']=='Pending'?Expanded(
                                flex: 18,
                                child: MaterialButton(
                                  minWidth: 80,
                                  height: 30,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.deepOrange[400],
                                  onPressed: (){
                                    setState(() {
                                      deleteNoti(snapshot.data?.docs[i].id);
                                    });
                                  },
                                  child: Text(TKeys.WnotiRefuseReq.translate(context),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                ),
                              ):Expanded(child: Container()),

                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context,i)=>SizedBox(height: 5,),
                      itemCount: snapshot.data!.docs.length
                  );
                }
            ),
            StreamBuilder<QuerySnapshot>(
                stream: db.requests().where("customerId",isEqualTo: Wid).snapshots(),
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
                        height: 115,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                            color: globals.ContColor,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ListTile(
                          onTap: (){
                            if(snapshot.data?.docs[i]['reqStatus']=='Pending')
                              {}
                            else
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return OngoingRequestPage(id: snapshot.data?.docs[i].id,);
                                }));
                              }
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  child: CircleAvatar(foregroundImage: NetworkImage("${snapshot.data?.docs[i]['workerImage']}"),
                                  )),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?.docs[i]['reqStatus']=='Pending'?TKeys.WnotiSendingReq.translate(context):TKeys.WnotiOngoingReq.translate(context),style: TextStyle(color: Colors.red.shade200,fontSize: 15),),
                                  Text("Worker Name : ${snapshot.data?.docs[i]['workerName']}",style: TextStyle(color: Colors.black)),
                                  MaterialButton(
                                    onPressed: (){
                                      showBottomSheet(backgroundColor:Colors.black26.withOpacity(0.5),context: context, builder: (context){
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[500],
                                          title: Text(TKeys.WnotiMoreInfoTitle.translate(context)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40)
                                          ),
                                          content: Container(
                                              height: 300,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    width: 150,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Image.network("${snapshot.data?.docs[i]['workerImage']}",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Text("Name : ${snapshot.data?.docs[i]['workerName']}",style: TextStyle(fontWeight: FontWeight.bold)),
                                                  SizedBox(height: 5,),
                                                  Text("Estimated Time : 5 Minutes",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.deepOrange,size: 20,),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Rate : ${snapshot.data?.docs[i]['workerRate'].toStringAsFixed(2)}",
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.phone, color: Colors.deepOrange,size: 20,),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Phone : ${snapshot.data?.docs[i]['workerPhone']}",
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  height: 40,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  color: Colors.indigo.shade900,
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(TKeys.WnotiMoreInfoOkButton.translate(context),style: TextStyle(color: Colors.white,fontSize: 20),),
                                                ),
                                                SizedBox(width: 10,),
                                              ],
                                            )

                                          ],
                                        );
                                      });

                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    height: 30,
                                    color: Colors.indigo,
                                    child: Text(TKeys.WnotiMoreInfoButton.translate(context),style: TextStyle(color: Colors.white),),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Text("${snapshot.data?.docs[i]['reqStatus']} Request",style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context,i)=>SizedBox(height: 5,),
                      itemCount: snapshot.data!.docs.length
                  );
                }
            ),
            StreamBuilder<QuerySnapshot>(
                stream: db.replys().where("workerId",isEqualTo: Wid).snapshots(),
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
                        height: 115,
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
                                     Text("${TKeys.WnotiInReplyComplainAbout.translate(context)} : ",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                     SizedBox(height: 5,),
                                     Text("${snapshot.data?.docs[i]['customerName']}",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold)),
                                     SizedBox(height: 10,),
                                     Text("${TKeys.WnotiInReplyCompalinContent.translate(context)} :",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
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
                                     Text("${TKeys.WnotiInReplyContent.translate(context)} :",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
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
                                     child: Text(TKeys.WnotiInReplyOkButton.translate(context),style: TextStyle(color: Colors.white,fontSize: 20),),),
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
                                  Text(TKeys.WnotiReplyForComplain.translate(context),style: TextStyle(color: Colors.indigo[900],fontSize: 20,fontWeight: FontWeight.bold),),
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
