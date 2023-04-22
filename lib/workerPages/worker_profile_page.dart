import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/worker_categories_page.dart';
import 'package:image_picker/image_picker.dart';
dynamic UID;
class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({Key? key}) : super(key: key);

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();


}

bool isRequested = false;
var textforbutton = "Send Request";

bool noti = false;
late File file;
late dynamic imageurl;
late dynamic isActiv='';
late dynamic ref;
late dynamic imageId;
late dynamic id='';
late dynamic uid;
late dynamic data={'':dynamic};
class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  getData()async{
    var responseWork=await Workers.get();
    responseWork.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
         setState(() {
           workers.add(element['id']);
           id=element['id'];
         });
        }
      });
    });
    Stream<QuerySnapshot> usersSnapshot2 = await FirebaseFirestore.instance.collection("worker").doc(id).get()
    .then(
          (DocumentSnapshot doc){
            setState(() {
              data = doc.data() as Map<String, dynamic>;
              return isActiv=data['status'];
            });
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print("==========================");
    print(data);

  }
  List Posts=[];
  CollectionReference Post = FirebaseFirestore.instance.collection('posts');
  getPostsData()async{
    var response=await Post.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['workerId']==id) {
          Posts.add(element['imageURL']);
        }
      });
    });
    print("==========================");
    print(id);
  }
  addImagePost()async{
    await ref.putFile(file);
    imageurl=await ref.getDownloadURL();
    setState(() {
      Post.doc('$imageId').set({
        'workerId':id,
        'imageURL':imageurl
      });
    });
  }
  deletePost(ImageUrl,Docid)async{
    var response=await Post.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['workerId']==id) {
          if(element['imageURL']=='$ImageUrl')
          {
            Post.doc(Docid).delete();
            print('post deleted');
          }
        }
      });
    });
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid;
    imageId=DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    getData();
    getPostsData();
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
                      value: isActiv=='true'?true:false,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        setState(() {
                          getData();
                          noti = val;
                          FirebaseFirestore.instance.collection('worker').doc(id).update(
                              {
                                'status':'$noti'
                              });
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      body: workers==null||workers.isEmpty||data==null
          ?Container(child:Center(child: Text("Loading",style: TextStyle(color: Colors.indigo.shade900,fontSize: 35),),),)
          :StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('worker').where("workerId",isEqualTo:'$id').snapshots(),
          builder: (BuildContext context,snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (data==null) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }
            return Container(
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
                                "${data['imageURL']}",
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
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context){
                            return Container(
                              color: Colors.grey.withOpacity(0.7),
                              padding: EdgeInsets.all(15),
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please Choose Image",
                                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                  Divider(height: 5,thickness: 0,),
                                  InkWell(
                                    onTap: ()async{
                                      var picked=await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if(picked!=null)
                                      {
                                        setState(() {
                                          file=File(picked.path);
                                          var rand =DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
                                          var nameImage="$rand"+basename(picked.path);
                                          ref =FirebaseStorage.instance.ref('posts').child('$nameImage');
                                          addImagePost();
                                        });
                                      }
                                      Navigator.of(context).popAndPushNamed("workerHome");
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.photo,color: Colors.deepOrange,size: 30,
                                          ),
                                          SizedBox(width: 15,),
                                          Text("From Gallary",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(height: 5,thickness: 1,color: Colors.white,),
                                  InkWell(
                                    onTap: ()async{
                                      var picked=await ImagePicker().pickImage(source: ImageSource.camera);
                                      if(picked!=null)
                                      {
                                        setState(() {
                                          file=File(picked.path);
                                          var rand =DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
                                          var nameImage="$rand"+basename(picked.path);
                                          ref =FirebaseStorage.instance.ref('posts').child('$nameImage');
                                          addImagePost();
                                        });
                                      }
                                      Navigator.of(context).popAndPushNamed("workerHome");
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.camera,color: Colors.deepOrange,size: 30,
                                          ),
                                          SizedBox(width: 15,),
                                          Text("From Camera",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
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
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('posts').where("workerId",isEqualTo:'$id').snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData)
                              {
                                return Center(child: Text("loading",style: TextStyle(color: Colors.white,fontSize: 20),));
                              }
                              return SizedBox(
                                height: 260,
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data?.docs.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                    itemBuilder: (context, i) => Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
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
                                                                deletePost(snapshot.data?.docs[i]['imageURL'],snapshot.data?.docs[i].id);
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
                                    )),
                              );
                            }
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }


}
/*Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              height: 120,
                                              child: Image.network(
                                                "${snapshot.data?.docs[i]['imageURL']}",
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
                                      );*/