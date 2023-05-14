import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/t_key.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/workerINworker_profile_page.dart';

import '../controller/localization_service.dart';
import 'home_page.dart';

late globals.FireBase db = new globals.FireBase();

class WorkerFilterdPage extends StatefulWidget {
  final cateName;
  const WorkerFilterdPage({this.cateName, Key? key}) : super(key: key);

  @override
  State<WorkerFilterdPage> createState() => _WorkerFilterdPageState();
}

late dynamic data=GeoPoint(11.11111, 12.11111);
late dynamic id = '';
late dynamic uid;

class _WorkerFilterdPageState extends State<WorkerFilterdPage> with WidgetsBindingObserver {
  CollectionReference Customers = db.worker();
  getData() async {
    var response = await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['workerUID'] == uid) {
          id = element['id'];
          data=element['location'];
        }
      });
    });
  }
  location(location){
    GeoPoint Wposition = location;
    GeoPoint Cposition = data;
    var WLatitude=Wposition.latitude;
    var WLongtitude = Wposition.longitude;
    var CLatitude=Cposition.latitude;
    var CLongtitude=Cposition.longitude;
    double distanceInMeters = Geolocator.distanceBetween(CLatitude, CLongtitude, WLatitude, WLongtitude)/1000;
    if(distanceInMeters>10) {
      print(distanceInMeters);
      return distanceInMeters;
    } else if(distanceInMeters<=10){
      print(distanceInMeters);
      return distanceInMeters;
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    uid = db.Uid();
    getData();
    super.initState();
  }
  final localizationController=Get.find<LocalizationController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.deepOrange,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return WorkerHomePage();
              }));
            },
          ),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${widget.cateName}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            key: UniqueKey(),
            stream:FirebaseFirestore.instance.collection('worker')
                .where("category", isEqualTo: widget.cateName.toString())
                .where("id",isNotEqualTo:"$id" ).orderBy('id').orderBy("rate",descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong with error');
              }
              if (!snapshot.hasData) {
                return const Text('Something went wrong with data');
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
                  child: ListView.separated(
                      itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:InkWell(
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
                                height:100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: globals.ContColor,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,horizontal: 3),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              "${snapshot.data?.docs[i]['workerName']}",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child:Container()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "${TKeys.CfilterdRate.translate(context)} : ${snapshot.data?.docs[i]['rate'].toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors
                                                .deepOrange,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,horizontal: 3),
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child:  snapshot.data?.docs[i]['status']=='true'
                                                  ?Row(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.start,
                                                    TKeys.CfilterdOnline.translate(context),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width:4),
                                                  Icon(Icons.circle,color:Colors.green.shade700,size: 10,)
                                                ],
                                              )
                                                  :Row(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.start,
                                                    TKeys.CfilterdOffiline.translate(context),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width:4),
                                                  Icon(Icons.circle,color:Colors.grey.shade900,size: 10,)
                                                ],
                                              )
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,horizontal: 5),
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child:Row(
                                                children: [
                                                  location(snapshot.data?.docs[i]['location'])>10.00
                                                      ?Icon(Icons.social_distance,color:Colors.black,size: 20,)
                                                      :Icon(Icons.social_distance,color:Colors.green.shade900,size: 20,),
                                                  SizedBox(width:4),
                                                  location(snapshot.data?.docs[i]['location'])>10.00?Text(
                                                    textAlign: TextAlign.start,
                                                    "(${TKeys.CfilterdAway.translate(context)}) ${location(snapshot.data?.docs[i]['location']).toStringAsFixed(2)} ${TKeys.CfilterdKM.translate(context)}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ):Text(
                                                    textAlign: TextAlign.start,
                                                    "(${TKeys.CfilterdNearby.translate(context)}) ${location(snapshot.data?.docs[i]['location']).toStringAsFixed(2)} ${TKeys.CfilterdKM.translate(context)}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),


                                                ],
                                              )

                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) {
                                  return WorkerInWorkerProfilePage(
                                      id: snapshot.data?.docs[i]['id'],
                                      cateName: widget.cateName);
                                },
                              ));
                            },
                          )
                      ),
                      separatorBuilder: (context, i) => Divider(
                            height: 10,
                            thickness: 0,
                          ),
                      itemCount: snapshot.data?.docs.length as int));
            }));
  }
}
