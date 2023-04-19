import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/worker_categories_page.dart';
import '../userPages/categories_page.dart';
import 'home_page.dart';
dynamic UID;
class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({Key? key}) : super(key: key);

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();


}

bool isRequested = false;
var textforbutton = "Send Request";

List post = [
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
];
bool noti = false;
late dynamic id;
late dynamic uid;
late dynamic data;
class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  getData()async{
    var response=await Workers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
          workers.add(element['id']);
          id=element['id'];
        }
      });
    });
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection("worker").doc(id).get().then(
          (DocumentSnapshot doc){
            data = doc.data() as Map<String, dynamic>;
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

  }






  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid;
    getData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading: Container(
            margin: EdgeInsets.all(3),
            child: CircleAvatar(
              foregroundImage: AssetImage("images/worker-icon2.png"),
            )),
        title: Center(
          child: Text(
            "My Profile",
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          SizedBox(
            width: 5,
          ),
          Container(
            padding: EdgeInsets.only(top: 5, right: 5),
            height: 30,
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  noti ? "Activated" : "Deactivated",
                  style:
                      TextStyle(color: noti ? Colors.green[900] : Colors.black),
                ),
                Expanded(
                  child: Switch(
                      value: noti,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        setState(() {
                          noti = val;
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      body: workers==null||workers.isEmpty
          ?Container(child:Center(child: Text("Loading",style: TextStyle(color: Colors.indigo.shade900,fontSize: 35),),),)
          :StreamBuilder(
          stream:FirebaseFirestore.instance.collection('worker').doc(id).get().asStream(),
          builder: (BuildContext context,snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }

            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(globals.BGImg),
                      fit: BoxFit.fill,
                    )),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 180,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  "https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['workerName']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Location : Giza, Faisal",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${data['category']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${data['phone']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.deepOrange,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "9.5",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 200,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        height: 50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)),
                                        color: Colors.deepOrange,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.symmetric(vertical: 5),
                                          child: InkWell(
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Search for Worker",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setState(() {});
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                        return WorkerCategoriesPage();
                                                      }));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      thickness: 2,
                    ),
                    MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "Upload More",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      thickness: 2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          Text(
                            "Your Uploded work ",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: 15,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: post.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10),
                            itemBuilder: (context, i) => Container(
                              width: 100,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 120,
                                      child: Image.network(
                                        "${post[i]}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    height: 20,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.grey[200],
                                    onPressed: () {
                                      showBottomSheet(
                                          backgroundColor:
                                          Colors.black26.withOpacity(0.5),
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              //icon: Icon(Icons.warning,color: Colors.red,size: 50,),
                                              title: Text("Warning"),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(40)),
                                              content: Text(
                                                  "Are you sure you want to delete it?"),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    MaterialButton(
                                                      height: 40,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                      ),
                                                      color: Colors.green,
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        "Agree",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    MaterialButton(
                                                      height: 40,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                      ),
                                                      color: Colors.deepOrange[400],
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
