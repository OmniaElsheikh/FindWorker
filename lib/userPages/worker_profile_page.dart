import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/userPages/filterd_page.dart';
import 'package:gp_1/userPages/home_page.dart';

class WorkerInUserProfilePage extends StatefulWidget {
  final id;
  final cateName;
  const WorkerInUserProfilePage({this.id,this.cateName,Key? key}) : super(key: key);

  @override
  State<WorkerInUserProfilePage> createState() => _WorkerInUserProfilePageState();
}
bool favorit = false;
bool isRequested= false;
dynamic y=0;
var textforbutton="Send Request";

List posts = [
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
];
late dynamic reqId='';
late dynamic Wid='';
late dynamic Cid='';
late dynamic Cname='';
late dynamic Cphone='';
late dynamic Cimage='';
late dynamic Wname='';
late dynamic Wphone='';
late dynamic Wimage='';

late dynamic uid;
late dynamic data={'':dynamic};
late dynamic reqstatus='';
class _WorkerInUserProfilePageState extends State<WorkerInUserProfilePage> {
  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  List customer=[];
  CollectionReference customers = FirebaseFirestore.instance.collection('customer');
  List Request=[];
  CollectionReference Requests = FirebaseFirestore.instance.collection('requests');

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
            globals.WorkerIdForMain=widget.id;
          });
          print(Wid);
        }
      });
    });

    var response1=await customers.get();
    response1.docs.forEach((element) {
      setState(() {
        if(element['customerUID']==uid) {
          setState(() {
            Cid=element['id'];
            Cname=element['customerName'];
            Cphone=element['phone'];
            Cimage=element['imageURL'];
            print(element.id);
          });
        }
      });
    });
    setState(() {
     reqstatus='';
     print(reqstatus+"==============empty====================");
    });
    await Requests.where("customerId",isEqualTo:Cid).where("workerId",isEqualTo: Wid).get().then((value) {
      value.docs.forEach((element) {
        if(element['reqStatus']=='Pending'||element['reqStatus']=='On')
        {
          setState(() {
            reqId=element.id;
            print(reqstatus+"=================دخل=====");
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
        print("====================لا=============");
    });
    QuerySnapshot usersSnapshot = await Workers.doc(widget.id).get().then(
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
        title: Center(
          child: Text("Worker Profile",style: TextStyle(
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
            return FilterdPage(cateName: widget.cateName,);
          }))
          :Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return UserHomePage();
          }));
        },),
      ),
      body:  workers==null||workers.isEmpty
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
                  image: DecorationImage(
                    image: AssetImage(globals.BGImg),
                    fit: BoxFit.fill,
                  ),
              ),
              child: ListView(
                children:[
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: globals.ContColor,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network("${data['imageURL']}",fit: BoxFit.fill,width: 110,height: 180,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
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
                                    Text(
                                      "Phone: ${data['phone']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.deepOrange),
                                            SizedBox(width: 5),
                                            Text(
                                              "9.5",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                          children: [
                                            Expanded(
                                              child: MaterialButton(
                                                minWidth: 30,
                                                onPressed: () {
                                                  if(reqstatus=="Pending"||reqstatus=='On')
                                                    {
                                                      Requests.doc(reqId).delete();
                                                      setState(() {
                                                        getData();
                                                      });
                                                      print("Canceled=================");
                                                    }
                                                  else
                                                    {
                                                      Requests.add({
                                                        'customerId':Cid,
                                                        'workerId':Wid,
                                                        'reqStatus':'Pending',
                                                        'customerName':Cname,
                                                        'customerPhone':Cphone,
                                                        'customerImage':Cimage,
                                                        'workerName':Wname,
                                                        'workerPhone':Wphone,
                                                        'workerImage':Wimage
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
                                                child: Text(reqstatus=='Pending'||reqstatus=='On'?"Cancel Request":"Send Request",style:reqstatus=='Pending'||reqstatus=='On'? TextStyle(color: Colors.red):TextStyle(color: Colors.green),),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                          ],
                                        ),
                                    Container(
                                        margin: EdgeInsets.only(top: 1),
                                        child:Text( reqstatus=='Pending'||reqstatus=='On'?"You Are on Request":"You Can Send Request",style: reqstatus=='Pending'||reqstatus=='On'?TextStyle(color: Colors.red,fontWeight: FontWeight.bold):TextStyle(color: Colors.green,fontWeight: FontWeight.bold),))
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
                      Center(child: Text("Worker's Work",style: TextStyle(color: Colors.white,fontSize: 25),),),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: globals.ContColor,
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
