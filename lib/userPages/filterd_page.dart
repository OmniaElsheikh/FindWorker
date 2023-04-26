import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

late globals.FireBase db = new globals.FireBase();

class FilterdPage extends StatefulWidget {
  final cateName;
  const FilterdPage({this.cateName, Key? key}) : super(key: key);

  @override
  State<FilterdPage> createState() => _FilterdPageState();
}

late dynamic data='';
late dynamic id = '';
late dynamic uid;

class _FilterdPageState extends State<FilterdPage> with WidgetsBindingObserver {
  CollectionReference Customers = db.customer();
  getData() async {
    var response = await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['customerUID'] == uid) {
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
    if(distanceInMeters>30) {
      print(distanceInMeters);
      return false;
    } else if(distanceInMeters<=30){
      print(distanceInMeters);
      return true;
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    uid = db.Uid();
    getData();
    super.initState();
  }

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
                return UserHomePage();
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
            stream: db
                .worker()
                .where("category", isEqualTo: widget.cateName.toString())
                .where("status", isEqualTo: "true")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData) {
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
                  child: ListView.separated(
                      itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: location(snapshot.data?.docs[i]['location'])==true?InkWell(
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
                                    SizedBox(
                                      width: 15,
                                    ),
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
                                                "${snapshot.data?.docs[i]['workerName']}",
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
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) {
                                  return WorkerInUserProfilePage(
                                      id: snapshot.data?.docs[i]['id'],
                                      cateName: widget.cateName);
                                },
                              ));
                            },
                          ):Container()
                      ),
                      separatorBuilder: (context, i) => Divider(
                            height: 10,
                            thickness: 0,
                          ),
                      itemCount: snapshot.data?.docs.length as int));
            }));
  }
}
