import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import 'ongoingReq_page.dart';
late dynamic Wid='';
late dynamic Cid='';
late dynamic uid;
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
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  List customers=[];
  CollectionReference Customers = FirebaseFirestore.instance.collection('customer');
  List requests=[];
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
   /* Future<QuerySnapshot<Map<String, dynamic>>> Requests = FirebaseFirestore.instance.collection('requests').where("workerId",isEqualTo: Wid).where("reqStatus",isEqualTo: "Pending").get();
    Requests.then((value)async {
      var response1=await Customers.get();
      value.docs.forEach((element1) {
        response1.docs.forEach((element) {
          setState(() {
            if(element1['customerId']==element['customerId']) {
              setState(() {
                customers.add({
                  'name':element['customerName'],
                  'phone':element['phone'],
                  'image':element['imageURL']
                });
              });
            }
          });
        });
      });
    });
    print(customers);*/
  }

  CollectionReference Noti = FirebaseFirestore.instance.collection('requests');
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
    uid=FirebaseAuth.instance.currentUser?.uid;
    getData();
    super.initState();
  }
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
            "Notifications",
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
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement( MaterialPageRoute (
              builder: (BuildContext context) => const LoginPage(),));
          }, icon:Icon(Icons.logout_outlined,color: Colors.deepOrange,)),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        backgroundColor: Colors.white.withOpacity(0.7),
        child: IconButton(onPressed: (){}, icon:Icon(Icons.skip_previous,color: Colors.deepOrange,size: 35,) ),
      ),*/
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(globals.BGImg),
              fit: BoxFit.fill,
            )
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('requests').where("workerId",isEqualTo: Wid).snapshots(),
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
                    if(snapshot.data?.docs[i]['reqStatus']=='Pending')
                      {}
                    else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return OngoingRequestPage(id: snapshot.data?.docs[i].id,);
                      }));
                    }
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
                          Text(snapshot.data?.docs[i]['reqStatus']=='Pending'?"Incoming Request":"Ongoing Request",style: TextStyle(color: Colors.indigo[900],fontSize: 15),),
                          Text("Name : ${snapshot.data?.docs[i]['customerName']}",style: TextStyle(color: Colors.black)),
                          MaterialButton(
                              onPressed: (){
                                showBottomSheet(backgroundColor:Colors.black26.withOpacity(0.5),context: context, builder: (context){
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[500],
                                    title: Text("Client's Details"),
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
                                                  "Rate : 8.5",
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
                                            child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),),
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
                            child: Text("More info",style: TextStyle(color: Colors.white),),
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
                            statusNoti(context,snapshot.data?.docs[i].id);
                            Navigator.of(context).push( MaterialPageRoute (
                              builder: (BuildContext context) =>OngoingRequestPage(id:snapshot.data?.docs[i].id),));
                            setState(() {
                            });
                          },
                          child: Text("Accept",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
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
                          child: Text("Refuse",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
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
      ),
    );
  }
}
