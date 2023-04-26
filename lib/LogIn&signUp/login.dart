import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/signup_page.dart';
import '../userPages/home_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import '../workerPages/home_page.dart';
late dynamic Wid='';
late dynamic Cid='';
late dynamic uid;
late dynamic data;
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var email,password;
  late UserCredential userCredential;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isLoading = false;
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  List customers=[];
  CollectionReference Customers = FirebaseFirestore.instance.collection('customer');
  getData()async{
    globals.isUser=true;
    var Wresponse=await Workers.get();
    var Cresponse=await Customers.get();
    Wresponse.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
          workers.add(element['id']);
          Wid=element['id'];
          globals.isUser=false;
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return WorkerHomePage();
          }
          )
          );
        }
        else if(Wid==''){
          showDialog(
              context: context, builder: (context){
            return AlertDialog(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              icon: Icon(Icons.warning,color: Colors.red,size: 30,),
              title: Text("Warning",style: TextStyle(color: Colors.red,fontSize: 30),),
              content: Text("You Are Not A User Or You Are Blocked",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),),
              actions: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.deepOrange,
                  onPressed: (){
                    Navigator.of(context).popAndPushNamed('login');
                  },
                  child: Text("Ok"),
                )
              ],
            );
          });
         // Navigator.of(context).popAndPushNamed('login');
        }
      });
    });

    if(globals.isUser)
      {
        Cresponse.docs.forEach((element) {
          setState(() {
            if(element['customerUID']==uid) {
              workers.add(element['id']);
              Cid=element['id'];
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return UserHomePage();
              }
              )
              );
            }
            else if(Cid==''){
              showDialog(
                  context: context, builder: (context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  icon: Icon(Icons.warning,color: Colors.red,size: 30,),
                  title: Text("Warning",style: TextStyle(color: Colors.red,fontSize: 30),),
                  content: Text("You Are Not A User Or You Are Blocked",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),),
                  actions: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      color: Colors.deepOrange,
                      onPressed: (){
                        Navigator.of(context).popAndPushNamed('login');
                      },
                      child: Text("Ok"),
                    )
                  ],
                );
              });
              //Navigator.of(context).popAndPushNamed('login');
            }
          });
        });
      }

  }


  // Sign In Function
  void login()async {
    if (_formKey.currentState!.validate()) {
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        uid = FirebaseAuth.instance.currentUser?.uid;
        await getData();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      isLoading = true;
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
              )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'images/worker-logo2-inside.png',
                width: 250.0,
                height: 250.0,
                fit: BoxFit.fill,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    TextFormField(
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
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: showPassword ? false : true,
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
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
                        prefixIcon: const Icon(
                          Icons.security,
                          color: Colors.deepOrange,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: globals.ContColor,
                        focusColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        login();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(150),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 20),
                      child: Container(child: Text("dont have account?",style: TextStyle(color: Colors.white,fontSize: 15),)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return SignupPage();
                          },
                        ));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }
}
