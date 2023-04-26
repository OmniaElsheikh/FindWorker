import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'home_page.dart';
import 'notification_page.dart';

late globals.FireBase db = new globals.FireBase();

class UserComplainPage extends StatefulWidget {
  final Cid;
  final Wid;
  final Wname;
  const UserComplainPage({this.Cid, this.Wid, this.Wname, Key? key})
      : super(key: key);

  @override
  State<UserComplainPage> createState() => _UserComplainPageState();
}

class _UserComplainPageState extends State<UserComplainPage> {
  bool isRequested = false;

  final _formKey = GlobalKey<FormState>();
  var content = '';
  late dynamic complainId;
  final TextEditingController _complainController = TextEditingController();
  CollectionReference Workers = db.worker();

  updateWorkerComplain() {
    DocumentReference documentReference1 = Workers.doc(widget.Wid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot1 = await transaction.get(documentReference1);
      if (!snapshot1.exists) {
        throw Exception("User does not exist!");
      }
      int newWarnCount = snapshot1['complains'] + 1;
      transaction.update(documentReference1, {'complains': newWarnCount});
      return newWarnCount;
    });
  }

  void editinfo(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await db.customerComplains().doc('$complainId').set({
        'customerId': widget.Cid,
        'workerId': widget.Wid,
        'content': content
      });
    }
  }

  @override
  void initState() {
    complainId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
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
                    "Client's Name : ${widget.Wname}",
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
                    onChanged: (val) {
                      setState(() {
                        content = val;
                      });
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
                          updateWorkerComplain();
                          editinfo(context);
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text(
                                  'Note',
                                  style: TextStyle(
                                      color: Colors.indigo.shade900,
                                      fontSize: 20),
                                ),
                                content: Text(
                                  'Complain Done Succefully',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    color: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const UserHomePage(),
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
