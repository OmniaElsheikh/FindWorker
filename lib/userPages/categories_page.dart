import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/t_key.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import '../controller/localization_service.dart';
import 'filterd_page.dart';

late globals.FireBase db = new globals.FireBase();

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

late dynamic id;
late dynamic uid;
late dynamic data = {'': dynamic};

class _CategoriesPageState extends State<CategoriesPage> {
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
  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.backColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          TKeys.WcategoriesTitle.translate(context),
          style: TextStyle(color: Colors.deepOrange),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.deepOrange,
                ),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                }),
          ),
        ],
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
                                    color: globals.boxColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.indigo.shade100.withOpacity(0.5),
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
                                      return FilterdPage(
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

class DataSearch extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close, color: Colors.deepOrange),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.deepOrange,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      "No Such Worker Name",
      style: TextStyle(color: Colors.indigo.shade900, fontSize: 30),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: globals.ContColor,
      child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('worker')
                    .where("workerName", isEqualTo: '$query')
                    .snapshots(),
                builder: (context, snapshot2) {
                  return ListView.builder(
                      itemCount:snapshot2.data?.docs.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return WorkerInUserProfilePage(
                                    id: snapshot2.data?.docs[i].id);
                              },
                            ));
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child:Text(
                                      "${snapshot2.data?.docs[i]['workerName']}",
                                      style: TextStyle(
                                          color: Colors.indigo.shade900,
                                          fontSize: 25))),
                        );
                      });
                })
    );
  }
}
