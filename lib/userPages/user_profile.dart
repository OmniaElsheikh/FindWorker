
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import '../LogIn&signUp/login.dart';
import 'package:flutter/services.dart';


late globals.FireBase db = new globals.FireBase();

dynamic UID;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

bool isRequested = false;
var textforbutton = "Send Request";

bool noti = false;
late dynamic id = '';
late dynamic uid;
late dynamic city='Faisal';
late dynamic country='Giza';
late dynamic data={'': dynamic};

class _UserProfileState extends State<UserProfile> {
  List customers = [];
  CollectionReference Customers = db.customer();
  getData() async {
    var response = await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['customerUID'] == uid) {
          customers.add(element['id']);
          id = element['id'];
        }
      });
    });
    QuerySnapshot usersSnapshot = await Customers.doc(id).get().then(
      (DocumentSnapshot doc) {
        setState(() {
          data = doc.data() as Map<String, dynamic>;
        });
        return data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  location(location)async{
    GeoPoint position=location;
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      country=placemark[0].locality;
      city=placemark[0].subAdministrativeArea;
      print('done');
    });
  }
  @override
  void initState() {
    uid = db.Uid();
    getData();
    location(data['location']);
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
            "My Profile",
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          SizedBox(
            width: 5,
          ),
          IconButton(
              onPressed: () async {
                await db.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ));
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.deepOrange,
              )),
        ],
      ),
      body: customers.isEmpty
          ? Container(
              child: Center(
                child: Text(
                  "Loading",
                  style: TextStyle(color: Colors.indigo.shade900, fontSize: 35),
                ),
              ),
            )
          : StreamBuilder(
              stream: db.customer().doc(id).get().asStream(),
              builder: (BuildContext context, snapshot) {
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
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(globals.BGImg),
                    fit: BoxFit.fill,
                  )),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(shrinkWrap: false, children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Container(
                                height: 300,
                                width: 250,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      "${data['imageURL']}",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${data['customerName']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Location :$country-$city",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${data['phone']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.deepOrange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Rate : ${data['rate']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black26,
                          thickness: 2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("customerSettingPage");
                              },
                              child: Text(
                                "Edit Info",
                                style: TextStyle(
                                    color: Colors.deepOrange, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]),
                );
              }),
    );
  }
}
