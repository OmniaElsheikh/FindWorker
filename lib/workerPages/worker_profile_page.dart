import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/worker_categories_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../LogIn&signUp/login.dart';
import '../controller/localization_service.dart';
import '../t_key.dart';

late globals.FireBase db = new globals.FireBase();

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
late dynamic isActiv = '';
late dynamic ref=FirebaseStorage.instance.ref('posts');
late dynamic imageId;
late dynamic id = '';
late dynamic city='';
late dynamic country='';
late dynamic uid;
late dynamic data = {'': dynamic};

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List workers = [];
  CollectionReference Workers = db.worker();
  getData() async {
    var responseWork = await Workers.get();
    responseWork.docs.forEach((element) {
      setState(() {
        if (element['workerUID'] == uid) {
          setState(() {
            workers.add(element['id']);
            id = element['id'];
          });
        }
      });
    });
    Stream<QuerySnapshot> usersSnapshot2 = await Workers.doc(id).get().then(
      (DocumentSnapshot doc) {
        setState(() {
          data = doc.data() as Map<String, dynamic>;
          return isActiv = data['status'];
        });
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print("==========================");
    print(data);
  }
  location(location)async{
    GeoPoint position=location;
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      country=placemark[0].subAdministrativeArea;
      city=placemark[0].administrativeArea;
      print('done');
    });
  }
  List Posts = [];
  CollectionReference Post = db.posts();
  getPostsData() async {
    var response = await Post.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['workerId'] == id) {
          Posts.add(element['imageURL']);
        }
      });
    });
    print("==========================");
    print(id);
  }

  addImagePost() async {
    await ref.putFile(file);
    imageurl = await ref.getDownloadURL();
    setState(() {
      Post.doc('$imageId').set({'workerId': id, 'imageURL': imageurl});
    });
  }

  deletePost(ImageUrl, Docid) async {
    var response = await Post.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['workerId'] == id) {
          if (element['imageURL'] == '$ImageUrl') {
            Post.doc(Docid).delete();
            print('post deleted');
          }
        }
      });
    });
  }

  @override
  void initState() {
    uid = db.Uid();
    imageId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    getData();
    location(data['location']);
    getPostsData();
    super.initState();
  }

  final localizationController=Get.find<LocalizationController>();

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
            )
        ),
        title: Container(
          width: 195,
          child: Center(
            child: Text(
              TKeys.WmyProfileTitle.translate(context),
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        actions: [
          SizedBox(
            width: 5,
          ),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                localizationController.toggleLanguge();
              });
            },child: Text(TKeys.WsettingLanguageButton.translate(context),style: TextStyle(color: Colors.deepOrange),),),
          ),
          IconButton(
              onPressed: () async {
                await db.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ));
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.deepOrange,
              )),],
      ),
      body: workers.isEmpty || data == null
          ? Container(
              child: Center(
                child: Text(
                  "Loading",
                  style: TextStyle(color: Colors.indigo.shade900, fontSize: 35),
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: Workers.where("workerId", isEqualTo: '$id').snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (data == null) {
                  return Center(
                      child: const Text(
                    "Loading",
                    style: TextStyle(fontSize: 30),
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: const Text(
                    "Loading",
                    style: TextStyle(fontSize: 30),
                  ));
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
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 165,
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
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(onPressed: (){
                                        showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:50),
                                            title:Text(TKeys.WactivButtonTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                            content:Text(TKeys.WactivButtonContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  MaterialButton(
                                                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      color:Colors.white,
                                                      minWidth:40,
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.deepOrange),)
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                      }, icon: Icon(Icons.info_outline,color:Colors.white)),
                                      Container(
                                    height: 50,
                                    width: 65,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['status']=='true' ? TKeys.WactivButton.translate(context) : TKeys.WdeactivButton.translate(context),
                                          style:
                                          TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10,),
                                        Expanded(
                                          child: Switch(
                                              value: isActiv == 'true' ? true : false,
                                              activeColor: Colors.green,
                                              onChanged: (val) {
                                                setState(() {
                                                  getData();
                                                  noti = val;
                                                  Workers.doc(id).update({'status': '$noti'});
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],)
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
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
                                    Text(
                                      "Location : $city, $country",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "Category : ${data['category']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "Phone: ${data['phone']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.deepOrange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${TKeys.CfilterdRate.translate(context)} : ${data['rate'].toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          child: MaterialButton(
                                            onPressed: () {
                                              workerCategoriesPage();
                                            },
                                            height: 40,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Colors.deepOrange,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pushNamed("workerCategoriesPage");
                                                },
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
                                                      TKeys.WsearchButton.translate(context),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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
                        height: 40,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.grey.withOpacity(0.7),
                                  padding: EdgeInsets.all(15),
                                  height: 235,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                  TKeys.WuploadPhotos.translate(context),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        height: 5,
                                        thickness: 0,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var picked = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          if (picked != null) {
                                            setState(() {
                                              file = File(picked.path);
                                              var rand = DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .remainder(100000)
                                                  .toString();
                                              var nameImage = "$rand" +
                                                  basename(picked.path);
                                              ref = FirebaseStorage.instance
                                                  .ref('posts')
                                                  .child('$nameImage');
                                              addImagePost();
                                            });
                                          }
                                          Navigator.of(context)
                                              .popAndPushNamed("workerHome");
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.photo,
                                                color: Colors.deepOrange,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                TKeys.WphotoFromGal.translate(context),
                                                style: TextStyle(
                                                    color:
                                                        Colors.indigo.shade900,
                                                    fontSize: 25),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 5,
                                        thickness: 1,
                                        color: Colors.white,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var picked = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          if (picked != null) {
                                            setState(() {
                                              file = File(picked.path);
                                              var rand = DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .remainder(100000)
                                                  .toString();
                                              var nameImage = "$rand" +
                                                  basename(picked.path);
                                              ref = FirebaseStorage.instance
                                                  .ref('posts')
                                                  .child('$nameImage');
                                              addImagePost();
                                            });
                                          }
                                          Navigator.of(context)
                                              .popAndPushNamed("workerHome");
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.camera,
                                                color: Colors.deepOrange,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                TKeys.WphotoFromCam.translate(context),
                                                style: TextStyle(
                                                    color:
                                                        Colors.indigo.shade900,
                                                    fontSize: 25),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          TKeys.WuploadPostsButton.translate(context),
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      Divider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        child: Column(
                          children: [
                            Text(
                              TKeys.WuploadedWorkTitle.translate(context),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                              height: 8,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: db
                                    .posts()
                                    .where("workerId", isEqualTo: '$id')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: Text(
                                      "loading",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ));
                                  }
                                  return SizedBox(
                                    height: 250,
                                    child: GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data?.docs.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder: (context, i) => Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    color: Colors.grey[200],
                                                    onPressed: () {
                                                      showBottomSheet(
                                                          backgroundColor:
                                                              Colors.black26
                                                                  .withOpacity(
                                                                      0.5),
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              //icon: Icon(Icons.warning,color: Colors.red,size: 50,),
                                                              title: Text(
                                                                TKeys.WdeletePostMessageTitle.translate(context),),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40)),
                                                              content: Text(
                                                                TKeys.WdeletePostMessageContent.translate(context),),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    MaterialButton(
                                                                      height:
                                                                          40,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      color: Colors
                                                                          .green,
                                                                      onPressed:
                                                                          () {
                                                                        deletePost(
                                                                            snapshot.data?.docs[i]['imageURL'],
                                                                            snapshot.data?.docs[i].id);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                              TKeys.WdeletePostMessageAgree.translate(context),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    MaterialButton(
                                                                      height:
                                                                          30,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      color: Colors
                                                                              .deepOrange[
                                                                          400],
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                            TKeys.WdeletePostMessageCancel.translate(context),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
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
                                                      TKeys.WdeletePostButton.translate(context),
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                  );
                                }),
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
              }),
    );
  }
}

