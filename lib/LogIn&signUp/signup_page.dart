import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import '../workerPages/home_page.dart';
import '../workerPages/worker_profile_page.dart';
import '../userPages/home_page.dart';
var id;
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}
late List<dynamic> items=['Carpenter','Black Smith','Engineer','Plumber'] ;
class _SignupPageState extends State<SignupPage> {
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  getData()async{
    var response=await categories.get();
    response.docs.forEach((element) {
      setState(() {
        items.add(element['name']);
      });
    });
  }

  initState(){
    //getData();
    id=DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    super.initState();
  }
  var name,email,phone,password,category;
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
  late final uid;
  // Email Validation
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      try {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "$email",
            password: "$password"
        );
        uid=FirebaseAuth.instance.currentUser?.uid;
        print("account created succefully");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
        isLoading = false;
      try{
        if (globals.isUser) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return customer(customerUID:uid.toString(),customerName: name,email: email,phone: phone,);
              }), (_) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return worker(workerUID: uid.toString(),workerName: name,email: email,phone: phone,category: category,);
              }), (_) => false);
        }
      }catch(e){
        print(e.toString());
      }
      }

    }


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
              SizedBox(
                height: 20,
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
                        onChanged: (val){
                          name=val;
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        //   initialValue: "old use email",
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your email';
                          }
                          if (!validateEmail(_emailController.text)) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                        onChanged: (val){
                          email=val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Enter Your Email',
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
                        onChanged: (val){
                          password=val;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Password',
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
                          hintText: 'Confirm your password',
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
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your phone Number';
                          }
                          return null;
                        },
                        onChanged: (val){
                          phone=val;
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
                    MaterialButton(
                        color: Colors.white,
                        onPressed: () {},
                        child: Text(
                          "Add Image",
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
                                          'WORKER',
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
                                      DropdownButton(
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
                                        items: items
                                            .map((item) => DropdownMenuItem(
                                                  child: Text(
                                                    "$item",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.indigo[900]),
                                                  ),
                                                  value: item,
                                                ))
                                            .toList(),
                                        value: selectedJob,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedJob = value.toString();
                                            category=value.toString();
                                          });
                                        },

                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Or",
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
                                      'USER',
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
                        onTap: () {
                          signup();
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
                                : const Text(
                                    'Signup',
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
                    Center(child: Text("Or",style: TextStyle(color: Colors.white,fontSize: 20),),),
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
                                : const Text(
                              'Login',
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


class worker extends StatelessWidget{
  late final workerUID;
  late final workerName;
  late final email;
  late final phone;
  late final category;
  worker({this.workerUID,this.workerName,this.email,this.phone,this.category});

  @override
  Widget build(BuildContext context) {
    if(true)
      {
        FirebaseFirestore.instance.collection("worker").doc('$id').set({
          "workerUID":this.workerUID,
          "workerName":this.workerName,
          "email":this.email,
          "phone":this.phone,
          "category":this.category,
          "id":"$id",
          "onReq":"false",
          'prevReq':0,
          "complains":0,
          "warn":0,
        });
        }

        return WorkerHomePage();
  }


}

class customer extends StatelessWidget{
  late final customerUID;
  late final customerName;
  late final email;
  late final phone;
  customer({this.customerUID,this.customerName,this.email,this.phone});

  @override
  Widget build(BuildContext context) {
    if(true)
    {
      FirebaseFirestore.instance.collection("customer").doc('$id').set({
        "customerUID":this.customerUID,
        "customerName":this.customerName,
        "email":this.email,
        "phone":this.phone,
        "id":"$id",
        "onReq":"false",
        'prevReq':0,
        "complain":0,
        "warn":0,
      });
    }
    return UserHomePage();
  }

}