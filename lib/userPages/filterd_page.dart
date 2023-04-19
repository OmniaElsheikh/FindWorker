import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

class FilterdPage extends StatefulWidget {
  final cateName;
  const FilterdPage({this.cateName,Key? key}) : super(key: key);

  @override
  State<FilterdPage> createState() => _FilterdPageState();
}
late List<dynamic> workers=[];
late dynamic data;
class _FilterdPageState extends State<FilterdPage> with WidgetsBindingObserver{

  final Stream<QuerySnapshot> _workerStream =
  FirebaseFirestore.instance.collection('worker').snapshots();


  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  getData()async{
    await Workers.get().then((value) => {
    value.docs.forEach((element) async{
      if(element['category']==widget.cateName)
        {
          setState(() {
            workers.add({
              'name':element['workerName'],
              'id':element['id']
          });
          });
          data=element['id'];
        }
    })
    });
    print(workers);
  }


  @override
  void initState() {
    workers=[];
    getData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  List favorits = [
    {
      'name': "omnia mohamed",
      'category': "Plumber",
      'img':"https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",
      'rate': "8.5",
      'distance': "7 km",
    },
    {
      'name': "motasem mohamed",
      'category': "carpenter",
      'img':
      "https://th.bing.com/th/id/R.7b4e5903c7de5337a73e00f00d73f36d?rik=WrtiSDesVmn8Og&pid=ImgRaw&r=0",

      'rate': "9.9",
      'distance': "5 km",
    },
    {
      'name': "omnia mohamed",
      'category': "Plumber",
      'img':"https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",
      'rate': "8.5",
      'distance': "7 km",
    },
    {
      'name': "Sehkaa ",
      'category': "Plumber",
      'img':  "https://th.bing.com/th/id/OIP.TfmC0UsikoZDsn_QxdVOBgHaE8?pid=ImgDet&rs=1",
      'rate': "7",
      'distance': "9.5 km",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
            leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepOrange,onPressed: (){
              Navigator.pop(context);
            },),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("${widget.cateName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange
              ),),
            ),
          ),
        ),
        body: workers.isEmpty||workers==null
        ?Container(
          color: Colors.white,
            child: Center(child: Text("Loading",style: TextStyle(color: Colors.black,fontSize: 35),),))
        :StreamBuilder<QuerySnapshot>(
          key: UniqueKey(),
          stream: _workerStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child:ListView.separated(
                  itemBuilder: (context,i)=>Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.blueAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(1, 1))
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: globals.ContColor,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width:  15,),
                                Container(
                                  width: 250,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            "${workers[i]['name']}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return WorkerProfilePage(id: workers[i]['id'],);
                            },
                          ));
                        },
                      )),
                  separatorBuilder: (context,i)=>Divider(height: 10,thickness: 0,),
                  itemCount: workers.length
              )
            );
          }
        ));
  }
}
