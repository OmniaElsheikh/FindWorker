import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/workerPages/home_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

late globals.FireBase db = new globals.FireBase();

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late dynamic ref = '';
  late dynamic id = '';
  late dynamic uid;
  late dynamic imageId;
  dynamic path = '';
  late File file = new File(path);
  var name, phone, category, imageurl;
  late List<dynamic> categorie = [];
  CollectionReference categories = db.categories();
  @override
  void initState() {
    uid = db.Uid();
    getData();
    super.initState();
  }

  var selectedJob;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  List workers = [];
  CollectionReference Workers = db.worker();
  getData() async {
    if (file == null) {
    } else {
      var responseWork = await Workers.get();
      responseWork.docs.forEach((element) {
        setState(() {
          if (element['workerUID'] == uid) {
            setState(() {
              workers.add(element['id']);
              id = element['id'];
              name = element['workerName'];
              category = element['category'];
              phone = element['phone'];
              imageurl = element['imageURL'];
            });
          }
        });
      });
      var response1 = await categories.get();
      response1.docs.forEach((element) {
        setState(() {
          categorie.add(element['name']);
        });
      });
    }
  }

  void editinfo({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (path == '') {
          Workers.doc(id).update({
            'workerName': name,
            'phone': phone,
            'category': category,
          });
          print("updated succefully");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return WorkerHomePage();
          }));
        } else {
          final TaskSnapshot snapshot = await ref.putFile(file);
          imageurl = await snapshot.ref.getDownloadURL();
          Workers.doc(id).update({
            'workerName': name,
            'phone': phone,
            'category': category,
            'imageURL': imageurl
          });
          print("updated succefully");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return WorkerHomePage();
          }));
        }
      } catch (e) {
        print(e.toString());
      }
    }
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
            "Edit Info",
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
              )),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(globals.BGImg),
          fit: BoxFit.fill,
        )),
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _userNameController,
                        //initialValue: "user old name",
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter Your Name',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.deepOrange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: globals.ContColor,
                          focusColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        //initialValue: "0123134654",
                        controller: _phoneNumberController,
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your phone Number',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.deepOrange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: globals.ContColor,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: globals.ContColor,
                          borderRadius: BorderRadius.circular(15)),
                      width: double.infinity,
                      child: DropdownButton(
                        hint: Text(
                          "Select you category",
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.bold),
                        ),
                        dropdownColor: Colors.grey,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        items: categorie
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    "$item",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo[900]),
                                  ),
                                  value: item,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            category = val;
                            selectedJob = val;
                          });
                        },
                        value: selectedJob,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.grey.withOpacity(0.7),
                                  padding: EdgeInsets.all(15),
                                  height: 170,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please Choose Image",
                                        style: TextStyle(
                                            fontSize: 25,
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
                                              path = picked.path;
                                              var rand = DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .remainder(100000)
                                                  .toString();
                                              var nameImage = "$rand" +
                                                  basename(picked.path);
                                              ref = FirebaseStorage.instance
                                                  .ref('profile')
                                                  .child('$nameImage');
                                            });
                                          }
                                          Navigator.of(context).pop();
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
                                                "From Gallary",
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
                                              path = picked.path;
                                              var rand = DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .remainder(100000)
                                                  .toString();
                                              var nameImage = "$rand" +
                                                  basename(picked.path);
                                              ref = FirebaseStorage.instance
                                                  .ref('profile')
                                                  .child('$nameImage');
                                            });
                                          }
                                          Navigator.of(context).pop();
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
                                                "From Camera",
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
                          "Edit Image",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 20),
                        )),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          editinfo(context: context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Center(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
