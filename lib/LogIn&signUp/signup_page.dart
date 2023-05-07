import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../t_key.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

import '../controller/localization_service.dart';
import '../workerPages/home_page.dart';
import '../workerPages/worker_profile_page.dart';
import '../userPages/home_page.dart';

var id;
dynamic position;
late double lat = 0.0, long = 0.0;
var picked=XFile('images/worker.jpg');
dynamic file=XFile(picked.path);

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}


class _SignupPageState extends State<SignupPage> {
  late List<dynamic> categorie = [];
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  getData() async {
    var response = await categories.get();
    response.docs.forEach((element) {
      setState(() {
        categorie.add(element['name']);
      });
    });
  }
  var phonePattern =
      r'^(\+201|01)[1,2,0,5]{1}[0-9]{8}$';

  bool validatePhone(String email) {
    final regExp = RegExp(phonePattern);
    return regExp.hasMatch(email);
  }
  initState() {
    getData();
    id = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    _determinePosition();
    super.initState();
  }

  dynamic ref=FirebaseStorage.instance;
  var name, email, phone, password, category, imageurl;
  late UserCredential userCredential;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var selectedJob = "Carpenter";
  bool showPassword = false;
  bool isLoading = false;
  dynamic uid;
  // Email Validation


  Future<void> signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      try {
        if(position==null)
          {
            print("position is null");
          }
        else
          {
            userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: "$email", password: "$password");
            uid = FirebaseAuth.instance.currentUser?.uid;
            try {
              final TaskSnapshot snapshot = await ref.putFile(file);
              imageurl = await snapshot.ref.getDownloadURL();
              if (globals.isUser) {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return customer(
                    customerUID: uid.toString(),
                    customerName: name,
                    email: email,
                    phone: phone,
                    imageurlIn: imageurl,
                  );
                }));
              } else {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return worker(
                    workerUID: uid.toString(),
                    workerName: name,
                    email: email,
                    phone: phone,
                    category: category,
                    imageurlIn: imageurl,
                  );
                }));
              }
            } catch (e) {

              print(e.toString());
            }
            print("account created succefully");
          }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context, builder: (context){
            return AlertDialog(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              icon: Icon(Icons.warning,color: Colors.red,size: 30,),
              title: Text('Warning',style: TextStyle(color: Colors.red,fontSize: 30),),
              content: Text('${e.code.toString()}',style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),),
              actions: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.deepOrange,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context, builder: (context){
            return AlertDialog(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              icon: Icon(Icons.warning,color: Colors.red,size: 30,),
              title: Text('Warning',style: TextStyle(color: Colors.red,fontSize: 30),),
              content: Text('${e.code.toString()}',style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),),
              actions: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.deepOrange,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
      isLoading = false;

    }
  }

  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(globals.BGImg),
            fit: BoxFit.fill,
          )),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(30),
                  child:Container(
                    height:65,
                    child: Column(children: [
                      Row(children: [
                        Expanded(child: TextButton(onPressed: (){
                          setState(() {
                            localizationController.toggleLanguge();
                          });
                        },child: Text(TKeys.WsettingLanguageButton.translate(context),style: TextStyle(color: Colors.white,fontSize: 25,decoration: TextDecoration.underline, decorationThickness: 2,),),)),
                      ],)
                    ],),
                  )
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    child: Image.asset(
                      'images/worker-logo2-inside.png',
                      width: 250.0,
                      height: 250.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _userNameController,
                        autovalidateMode: AutovalidateMode.always,
                        //initialValue: "user old name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your User Name';
                          }
                          if (value.length < 3) {
                            return 'User Name must be at least 3 characters';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          name = val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '${TKeys.signupUserName.translate(context)}',
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        //   initialValue: "old use email",
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your email';
                          }
                          if (!EmailValidator.validate(_emailController.text)) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          email = val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            filled: true,
                            hintText: '${TKeys.signupUserEmail.translate(context)}',
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.deepOrange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: globals.ContColor,
                            focusColor: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        //initialValue: "old user password",
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          password = val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '${TKeys.signupUserPass.translate(context)}',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                          prefixIcon: const Icon(
                            Icons.security,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        // initialValue: "user old password",
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Password confirmation';
                          }
                          if (value != _passwordController.text) {
                            return 'passwords do not match';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '${TKeys.signupUserConPass.translate(context)}',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                          prefixIcon: const Icon(
                            Icons.security,
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        //initialValue: "0123134654",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your phone Number';
                          }
                          if(!validatePhone(_phoneNumberController.text))
                            {
                              return 'Please Enter Valid phone Number';
                            }
                          return null;
                        },
                        onChanged: (val) {
                          phone = val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '${TKeys.signupUserPhone.translate(context)}',
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
                                           picked = (await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery))!;
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
                                           picked = (await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera))!;
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
                          TKeys.signupUserAddImage.translate(context),
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 20),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  globals.isUser = false;
                                });
                              },
                              child: Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: globals.isUser
                                      ? Colors.white.withOpacity(0.75)
                                      : Colors.deepOrange.withOpacity(0.7),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.handyman,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          TKeys.signupChooseWorker.translate(context),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (globals.isUser)
                                      Icon(
                                        Icons.construction_sharp,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    if (!globals.isUser)
                                      Expanded(
                                        child: DropdownButton(
                                          hint: Text(
                                            "Select you category",
                                            style: TextStyle(
                                                color: Colors.black,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .indigo[900]),
                                                    ),
                                                    value: item,
                                                  ))
                                              .toList(),
                                          value: selectedJob,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedJob = value.toString();
                                              category = value.toString();
                                            });
                                          },
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          TKeys.signupChooseOr.translate(context),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  globals.isUser = true;
                                });
                              },
                              child: Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: globals.isUser
                                      ? Colors.deepOrange.withOpacity(0.7)
                                      : Colors.white.withOpacity(0.75),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      TKeys.signupChooseUser.translate(context),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15),
                                    Icon(
                                      Icons.supervised_user_circle,
                                      size: 50,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          signup(context);
                          //LocationPermission permission = await Geolocator.requestPermission();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Center(
                            child: isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    TKeys.loginSignupButton.translate(context),
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        TKeys.signupChooseOr.translate(context),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).popAndPushNamed("login");
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Center(
                            child: isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    TKeys.loginButton.translate(context),
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class worker extends StatelessWidget {
  late final workerUID;
  late final workerName;
  late final email;
  late final phone;
  late final category;
  late final imageurlIn;
  worker(
      {this.workerUID,
      this.workerName,
      this.email,
      this.phone,
      this.category,
      this.imageurlIn});

  @override
  Widget build(BuildContext context) {
    if (true) {
      lat = position.latitude;
      long = position.longitude;
      print(lat);
      print(long);
      FirebaseFirestore.instance.collection("worker").doc('$id').set({
        "workerUID": this.workerUID,
        "workerName": this.workerName,
        "email": this.email,
        "phone": this.phone,
        "category": this.category,
        "id": "$id",
        'rate':5,
        "onReq": "false",
        "status": "false",
        'prevReq': 0,
        "complains": 0,
        "warn": 0,
        "imageURL": this.imageurlIn,
        "location": GeoPoint(lat, long)
      });
    }

    return WorkerHomePage();
  }
}

class customer extends StatelessWidget {
  late final customerUID;
  late final customerName;
  late final email;
  late final phone;
  late final imageurlIn;
  customer(
      {this.customerUID,
      this.customerName,
      this.email,
      this.phone,
      this.imageurlIn});

  @override
  Widget build(BuildContext context) {
    if (true) {
      print("------------------------------------------------------------------->");
      print(position);
      print("------------------------------------------------------------------->");
      lat = position.latitude;
      long = position.longitude;
      print(lat);
      print(long);
      FirebaseFirestore.instance.collection("customer").doc('$id').set({
        "customerUID": this.customerUID,
        "customerName": this.customerName,
        "email": this.email,
        "phone": this.phone,
        "id": "$id",
        'prevReq': 0,
        'rate':5,
        "complain": 0,
        "warn": 0,
        "imageURL": this.imageurlIn,
        "location": GeoPoint(lat, long)
      });
    }
    return UserHomePage();
  }
}
