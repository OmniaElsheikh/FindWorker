import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/worker_filterd_page.dart';
//import 'filterd_page.dart';

late globals.FireBase db = new globals.FireBase();

class workerCategoriesPage extends StatefulWidget {
  const workerCategoriesPage({Key? key}) : super(key: key);

  @override
  State<workerCategoriesPage> createState() => _workerCategoriesPageState();
}

late dynamic id;
late dynamic uid;
late dynamic data = {'': dynamic};

class _workerCategoriesPageState extends State<workerCategoriesPage> {
  final Stream<QuerySnapshot> _categoriesStream = db.categories().snapshots();

  @override
  void initState() {
    uid = db.Uid();
    getData();
    super.initState();
  }

  List category = [];
  CollectionReference categories = db.categories();
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
    var response = await categories.get();
    response.docs.forEach((element) {
      setState(() {
        category.add(element['name']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.deepOrange,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        title: Center(
            child: Text(
          "Categories",
          style: TextStyle(color: Colors.deepOrange),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.deepOrange,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: globals.ContColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Colors.deepOrange.shade100,
                title: Text("log out"),
                leading: Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }), (_) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: category.isEmpty || category == null
          ? Center(
              child: Text(
                "Loading",
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _categoriesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
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
                    child: GridView.builder(
                        itemCount: snapshot.data?.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0),
                                    color: globals.ContColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(1, 1))
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${snapshot.data?.docs[i]['name']}",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {});
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) {
                                      return WorkerFilterdPage(
                                          cateName: snapshot.data?.docs[i]
                                          ['name']);
                                    },
                                  ));
                                },
                              ),
                            )));
              }),
    );
  }
}
