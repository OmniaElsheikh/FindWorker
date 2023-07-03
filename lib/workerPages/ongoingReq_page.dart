import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/t_key.dart';
import 'package:gp_1/workerPages/workerSurvay.dart';
import '../controller/localization_service.dart';
import 'complain_page.dart';
import 'home_page.dart';

late globals.FireBase db = new globals.FireBase();

class OngoingRequestPage extends StatefulWidget {
  final id;
  const OngoingRequestPage({this.id, Key? key}) : super(key: key);

  @override
  State<OngoingRequestPage> createState() => _OngoingRequestPageState();
}

bool isRequested = false;
dynamic whereToUpdate = true;
dynamic fontSize = 18.0;
dynamic sizedBox = 15.0;
late dynamic city='Faisal';
late dynamic country='Giza';
late dynamic data = {'': dynamic};
late dynamic Cdata = {'': dynamic};

class _OngoingRequestPageState extends State<OngoingRequestPage> {
  getData() async {
    Stream<QuerySnapshot> usersSnapshot2 =
        await db.requests().doc(widget.id).get().then(
      (DocumentSnapshot doc) {
        setState(() {
          data = doc.data() as Map<String, dynamic>;
        });
        print(data['customerId']);
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

  }
  location(location)async{
    GeoPoint position=location;
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      country=placemark[0].subAdministrativeArea;
      city=placemark[0].administrativeArea;
      print('done');
    });
  }
  List workers = [];
  CollectionReference Workers = db.worker();
  List customers = [];
  CollectionReference Customers = db.customer();

  updateRate(New, Old, Id) async {
    double rate = (New + Old) / 2.0;
    var Wresponse = await Workers.get();
    var Cresponse = await Customers.get();
    Wresponse.docs.forEach((element) {
      if (element['id'] == Id) {
        Workers.doc(Id).update({'rate': rate});
      }
    });
    Cresponse.docs.forEach((element) {
      if (element['id'] == Id) {
        Customers.doc(Id).update({'rate': rate});
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final localizationController = Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.deepOrange,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text(
            TKeys.WongoingTitle.translate(context),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color:globals.backColor),
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: globals.boxColor),
          child: Column(
            children: [
              Text(
                TKeys.WongoingTitle.translate(context),
                style: TextStyle(color: Colors.indigo[900], fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 150,
                height: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "${data['customerImage']}",
                      fit: BoxFit.fill,
                    )),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Name : ${data['customerName']}",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Phone : ${data['customerPhone']}",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Location : ${city}, ${country} ",
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MaterialButton(
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.deepOrange,
                      onPressed: () {
                        WorkerSurvayPage(customerId: data['customerId']);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.white.withOpacity(0.0),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // icon: Icon(Icons.note,color: Colors.red,size: 50,),
                                title: Text(
                                    TKeys.WongoingInEndMessageTitle.translate(
                                        context)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content: Text(
                                    TKeys.WongoingInEndMessageContent.translate(
                                        context)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.green,
                                        onPressed: () async {
                                          CollectionReference Noti =db.requests();
                                          var response = await Noti.get();
                                          response.docs.forEach((element) {
                                            setState(() {
                                              if (element.id == widget.id) {
                                                Noti.doc(widget.id).delete();
                                              }
                                            });
                                          });
                                          showModalBottomSheet(backgroundColor: Colors.black26.withOpacity(0.5),
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title:Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          IconButton(onPressed: (){
                                                            Navigator.of(context).pushReplacementNamed("workerHomePage");
                                                          }, icon:Icon(
                                                            Icons.cancel_rounded,
                                                            color:Colors.deepOrange,
                                                            size: 25,
                                                          ))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${TKeys.CongoingInReviewTitle.translate(context)} : "),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("${data['customerName']}")
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  content: Container(
                                                      //height: 400,
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              "${data['customerImage']}",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: 35,
                                                          child: Text(
                                                            "Name : ${data['customerName']}",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Rate : ${data['customerRate'].toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            ),
                                                            SizedBox(width: 10),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Container(
                                                        width: 180,
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            RatingBar.builder(
                                                                updateOnDrag:
                                                                    true,
                                                                itemSize: 25,
                                                                minRating: 1,
                                                                allowHalfRating:
                                                                    true,
                                                                glowColor:
                                                                    Colors
                                                                        .amber,
                                                                itemPadding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            4),
                                                                initialRating: data[
                                                                        'customerRate']
                                                                    .toDouble(),
                                                                itemCount: 5,
                                                                itemBuilder:
                                                                    (context,
                                                                        i) {
                                                                  return Icon(
                                                                      Icons
                                                                          .star,
                                                                      size: 5,
                                                                      color: Colors
                                                                          .amber);
                                                                },
                                                                onRatingUpdate:
                                                                    (newRating) {
                                                                  setState(() {
                                                                    updateRate(
                                                                        newRating
                                                                            .toDouble(),
                                                                        data['customerRate']
                                                                            .toDouble(),
                                                                        data[
                                                                            'customerId']);
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                      ))
                                                    ],
                                                  )),
                                                  actions: [
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                MaterialButton(
                                                              height: 40,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushReplacement(
                                                                        MaterialPageRoute(
                                                                  builder: (BuildContextcontext) => WorkerSurvayPage(customerId: data['customerId'],),
                                                                ));
                                                              },
                                                              child: Text(
                                                                TKeys.WongoingInReviewDoneButton
                                                                    .translate(
                                                                        context),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                MaterialButton(
                                                              height: 40,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                        MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ComplainPage(
                                                                    Wid: data[
                                                                        'workerId'],
                                                                    Cid: data[
                                                                        'customerId'],
                                                                    Cname: data[
                                                                        'customerName'],
                                                                  ),
                                                                ));
                                                              },
                                                              child: Text(
                                                                TKeys.WongoingInComplainButton
                                                                    .translate(
                                                                        context),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          TKeys.WongoingInEndDoneButton
                                              .translate(context),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      MaterialButton(
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.deepOrange[400],
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(TKeys.WongoingInEndCancelButton
                                              .translate(context),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        TKeys.WongoingInEndDoneButton.translate(context),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizedBox,
                  ),
                  Expanded(
                    child: MaterialButton(
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.indigo.shade900,
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.white.withOpacity(0.0),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // icon: Icon(Icons.note,color: Colors.red,size: 50,),
                                title: Text(TKeys.WongoingInCancelMessageTitle
                                    .translate(context)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content: Text(
                                    TKeys.WongoingInCancelMessageContent
                                        .translate(context)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.green,
                                        onPressed: () async {
                                          CollectionReference Noti = db.requests();
                                          var response = await Noti.get();
                                          response.docs.forEach((element) {
                                            setState(() {
                                              if (element.id == widget.id) {
                                                Noti.doc(widget.id).delete();
                                              }
                                            });
                                          });
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const WorkerHomePage(),
                                          ));
                                        },
                                        child: Text(
                                          TKeys.WongoingInCancelMessageOkButton
                                              .translate(context),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      MaterialButton(
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.deepOrange[400],
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          TKeys.WongoingInCancelMessageNoButton
                                              .translate(context),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        TKeys.WongoingInCancelJobButton.translate(context),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
