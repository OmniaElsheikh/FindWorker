import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import '../controller/localization_service.dart';
import '../t_key.dart';
import 'home_page.dart';

late globals.FireBase db = new globals.FireBase();

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({Key? key}) : super(key: key);

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  late dynamic ref = '';
  late dynamic id = '';
  late dynamic path = '';
  late dynamic uid;
  late dynamic imageId;
  late File file = new File(path);
  var name, phone, imageurl;
  @override
  void initState() {
    uid = db.Uid();
    getData();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  List customers = [];
  CollectionReference Customers = db.customer();
  getData() async {
    var responseWork = await Customers.get();
    responseWork.docs.forEach((element) {
      setState(() {
        if (element['customerUID'] == uid) {
          setState(() {
            customers.add(element['id']);
            id = element['id'];
            phone = element['phone'];
            name = element['customerName'];
          });
        }
      });
    });
  }

  void editinfo(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (path == '') {
          Customers.doc(id).update({
            'customerName': name,
            'phone': phone,
          });
          print("updated succefully");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return UserHomePage();
          }));
        } else {
          final TaskSnapshot snapshot = await ref.putFile(file);
          imageurl = await snapshot.ref.getDownloadURL();
          Customers.doc(id).update(
              {'customerName': name, 'phone': phone, 'imageURL': imageurl});
          print("updated succefully");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return UserHomePage();
          }));
        }
      } catch (e) {
        print(e.toString());
      }
    }
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
            )),
        title: Center(
          child: Text(
            TKeys.WeditInfoTitle.translate(context),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.deepOrange,
          size: 25,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(globals.BGImg),
          fit: BoxFit.fill,
        )),
        child: ListView(children: [
          Column(
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
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '${TKeys.WsettingNameField.translate(context)}',
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
                          hintText: '${TKeys.WsettingPhoneFiled.translate(context)}',
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
                    MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.grey.withOpacity(0.7),
                                  padding: EdgeInsets.all(15),
                                  height: 225,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        TKeys.WuploadPhotos.translate(context),
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
                          TKeys.WsettingEditImageButoon.translate(context),
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 20),
                        )),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          editinfo(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Center(
                            child: Text(
                              TKeys.WsettingDoneButton.translate(context),
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
