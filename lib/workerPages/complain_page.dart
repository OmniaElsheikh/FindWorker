import 'package:flutter/material.dart';
import 'package:gp_1/workerPages/home_page.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'notification_page.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({Key? key}) : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  bool isRequested = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complainController = TextEditingController();

  void editinfo() {
    if (_formKey.currentState!.validate()) {
      setState(() {});

      ;
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
            "Complaining",
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(globals.BGImg),
            fit: BoxFit.fill,
          )),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.75),
                borderRadius: BorderRadius.circular(15)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Complain's Details",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.indigo.shade900.withOpacity(0.7),
                    height: 10,
                  ),
                  Text(
                    "Client's Name : Ahemd",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Content :",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _complainController,
                    //initialValue: "user old name",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Complain';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    maxLines: 15,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Your Complain',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      prefixIcon: const Icon(
                        Icons.comment_outlined,
                        color: Colors.deepOrange,
                        size: 40,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusColor: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const WorkerHomePage(),
                          ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        color: Colors.indigo.shade900,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
