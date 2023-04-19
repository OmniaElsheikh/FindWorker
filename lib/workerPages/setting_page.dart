import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/workerPages/home_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var items = [
    'carpenter',
    'Plumber',
    'blacksmith',
  ];
  var selectedJob ;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void editinfo() {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return WorkerHomePage();
          }), (_) => false);
      ;
    }
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
          "Edit Info",
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(globals.BGImg),
                fit: BoxFit.fill,
              )
          ),
          child: Column(
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your User Name';
                          }
                          if (value.length < 3) {
                            return 'User Name must be at least 3 characters';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter Your Name',
                          hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Enter Your Email',
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
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
                          hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your phone Number',
                          hintStyle: const TextStyle(color: Colors.white70,fontSize: 20,),
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
                        borderRadius: BorderRadius.circular(15)
                      ),
                      width: double.infinity,
                     
                      child: DropdownButton(
                        hint: Text("Select you category",style: TextStyle(color: Colors.indigo[900],fontWeight: FontWeight.bold),),
                        dropdownColor: Colors.grey,
                        icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                        items: items.map((item) =>DropdownMenuItem(
                          child: Text("$item"
                            ,style: TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.indigo[900]),),
                          value: item,))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedJob= val ;
                          });
                        },
                        value:selectedJob,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        color: Colors.white,
                        onPressed: (){
                        },
                        child:Text(
                          "Edit Image",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20
                          ),
                        )
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          editinfo();
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
        ),
      ),
    );
  }
}
