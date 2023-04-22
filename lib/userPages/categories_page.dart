import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;


import 'filterd_page.dart';
import 'home_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}
late dynamic id;
late dynamic uid;
late dynamic data={'':dynamic};
class _CategoriesPageState extends State<CategoriesPage> {
  final Stream<QuerySnapshot> _categoriesStream =
  FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid;
    getData();
    super.initState();
  }

  List category=[];
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  getData()async{
    var responseWork=await Workers.get();
    responseWork.docs.forEach((element) {
      setState(() {
        if(element['workerUID']==uid) {
          setState(() {
            workers.add(element['id']);
            id=element['id'];
          });
        }
      });
    });
    var response=await categories.get();
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
                    icon: Icon(Icons.menu,color: Colors.deepOrange,),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
            title: Center(child: Text("Categories",style: TextStyle(color: Colors.deepOrange),)),
            actions: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(icon: Icon(Icons.search,color: Colors.deepOrange,),onPressed: (){
                showSearch(context: context, delegate: DataSearch());
              }),
            ),],
          ),
      drawer:Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: globals.ContColor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              ListTile(
                tileColor: Colors.deepOrange.shade100,
                title: Text("log out"),
                leading: Icon(Icons.logout),
                onTap: () async{
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
      body:category.isEmpty||category==null
          ?Center(child: Text("Loading",style:TextStyle(color: Colors.black,fontSize: 40),),)
          :StreamBuilder<QuerySnapshot>(
          stream: _categoriesStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }
            return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(globals.BGImg),
                fit: BoxFit.fill,
              )
          ),
          child: GridView.builder(
              itemCount: snapshot.data?.docs.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {});
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return FilterdPage(cateName:snapshot.data?.docs[i]['name']);
                          },
                        ));
                      },
                    ),
                  )));}),
    );
  }
}

class DataSearch extends SearchDelegate{
  List workers = [
    "motasem mohamed",
    "omnia",
    "sheka"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton( icon: Icon(Icons.close,color: Colors.deepOrange),onPressed: (){
        query = "";
      },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return  IconButton( icon: Icon(Icons.arrow_back,color: Colors.deepOrange,),onPressed: (){
      close(context, null);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text("No Such Worker Name",style: TextStyle(color: Colors.indigo.shade900,fontSize: 30),));
  }

  @override
  Widget buildSuggestions(BuildContext context) {

return Container(
  color: globals.ContColor,
  child:   StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('worker').snapshots(),
    builder: (context, snapshot) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('worker').where("workerName",isEqualTo: '$query').snapshots(),
        builder: (context, snapshot2) {
          return ListView.builder(

                  itemCount: query ==""? snapshot.data?.docs.length: snapshot2.data?.docs.length,

                  itemBuilder: (context,i){

                    return InkWell(

                      onTap: (){

                        Navigator.of(context).push(MaterialPageRoute(

                          builder: (context) {

                            return WorkerInUserProfilePage(id:snapshot.data?.docs[i].id);

                          },

                        ));

                      },

                      child: Container(

                        padding: EdgeInsets.all(10),

                        child: query==""?Text("${snapshot.data?.docs[i]['workerName']}",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25),):

                            Text("${snapshot2.data?.docs[i]['workerName']}",style: TextStyle(color: Colors.indigo.shade900,fontSize: 25))

                      ),

                    );

                  }

              );
        }
      );
    }
  ),
);
  }
}
