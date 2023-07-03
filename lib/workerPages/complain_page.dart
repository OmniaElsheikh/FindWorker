import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/workerPages/home_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import '../controller/localization_service.dart';
import '../t_key.dart';

late globals.FireBase db = new globals.FireBase();

class ComplainPage extends StatefulWidget {
  final Wid;
  final Cid;
  final Cname;
  const ComplainPage({this.Wid, this.Cid, this.Cname, Key? key})
      : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

late dynamic complainId;

class _ComplainPageState extends State<ComplainPage> {
  bool isRequested = false;
  var content;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complainController = TextEditingController();
  CollectionReference Customers = db.customer();
  bool check(){
    if(_formKey.currentState!.validate())
      return true;
    else
      return false;
  }
  updateCustomerComplain() {
    DocumentReference documentReference1 = Customers.doc(widget.Cid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot1 = await transaction.get(documentReference1);
      if (!snapshot1.exists) {
        throw Exception("User does not exist!");
      }
      int newWarnCount = snapshot1['complain'] + 1;
      transaction.update(documentReference1, {'complain': newWarnCount});

      return newWarnCount;
    });
  }

  void addcomplain(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await db.workerComplains().doc('$complainId').set({
        'customerId': widget.Cid,
        'workerId': widget.Wid,
        'content': content
      });
      print("complain added");
    }
  }

  @override
  void initState() {
    complainId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
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
            )),
        title: Center(
          child: Text(
            TKeys.WcomplainTitle.translate(context),
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
            color:globals.backColor),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: globals.boxColor,
                borderRadius: BorderRadius.circular(15)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    TKeys.WcomplainDetails.translate(context),
                    style: TextStyle(color: Colors.deepOrange, fontSize: 25),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.indigo.shade900.withOpacity(0.7),
                    height: 10,
                  ),
                  Text(
                    "Client's Name : ${widget.Cname}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "${TKeys.WcomplainContent.translate(context)} :",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _complainController,
                    //initialValue: "user old name",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    style: const TextStyle(color: Colors.black),
                    maxLines: 15,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '${TKeys.WcomplainTextField.translate(context)}',
                      hintStyle: const TextStyle(
                        color: Colors.black,
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
                          var bol=check();
                          if(bol){
                            updateCustomerComplain();
                            addcomplain(context);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const WorkerHomePage(),
                            ));
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        color: Colors.indigo.shade900,
                        child: Text(
                          TKeys.WcomplainSubmitButton.translate(context),
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
