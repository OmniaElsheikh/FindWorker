import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/t_key.dart';
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
dynamic whereToUpdate=true;
dynamic fontSize = 18.0;
dynamic sizedBox = 15.0;
late dynamic data = {'': dynamic};

class _OngoingRequestPageState extends State<OngoingRequestPage> {
  getData() async {
    Stream<QuerySnapshot> usersSnapshot2 =
        await db.requests().doc(widget.id).get().then(
      (DocumentSnapshot doc) {
        setState(() {
          data = doc.data() as Map<String, dynamic>;
        });
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  List workers = [];
  CollectionReference Workers = db.worker();
  List customers = [];
  CollectionReference Customers = db.customer();

  updateRate(New,Old,Id)async{
    double rate=(New+Old)/2.0;
    var Wresponse = await Workers.get();
    var Cresponse = await Customers.get();
    Wresponse.docs.forEach((element) {
      if (element['id'] == Id) {
        Workers.doc(Id).update({
          'rate':rate
        });
        print("==========================================");
        print('is worker');
        print("==========================================");
      }
    });
    Cresponse.docs.forEach((element) {
      if (element['id'] == Id) {
        Customers.doc(Id).update({
          'rate':rate
        });
        print("==========================================");
        print('is customer');
        print("==========================================");
        print('done rate update for customer');
      }
    });

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.deepOrange,
          onPressed: () {
            Navigator.pop(context);
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
            image: DecorationImage(
          image: AssetImage(globals.BGImg),
          fit: BoxFit.fill,
        )),
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.withOpacity(0.8)),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Client Name ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Phone ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Location ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Distance in KM ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Estimated Time ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Transportation Fee ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            ": ",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "${data['customerName']}",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "${data['customerPhone']}",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Giza,El-Hwamdia",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "10 KM",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "5 Minutes",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "30 L.E.",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
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
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.white.withOpacity(0.0),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // icon: Icon(Icons.note,color: Colors.red,size: 50,),
                                title: Text(TKeys.WongoingInEndMessageTitle.translate(context)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content:
                                    Text(TKeys.WongoingInEndMessageContent.translate(context)),
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
                                          CollectionReference Noti =
                                              db.requests();
                                          var response = await Noti.get();
                                          response.docs.forEach((element) {
                                            setState(() {
                                              if (element.id == widget.id) {
                                                Noti.doc(widget.id).delete();
                                              }
                                            });
                                          });
                                          showModalBottomSheet(
                                              backgroundColor: Colors.black26
                                                  .withOpacity(0.5),
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: Text(
                                                      "${TKeys.WongoingInReviewTitle.translate(context)} : ${data['customerName']}"),
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
                                                          height:35,
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
                                                              "Rate : ${data['customerRate'].toStringAsFixed(2) }",
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
                                                      Expanded(child:Container(
                                                        width: 180,
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            RatingBar.builder(
                                                                updateOnDrag: true,
                                                                itemSize:25,
                                                                minRating:1,
                                                                allowHalfRating:true,
                                                                glowColor:Colors.amber,
                                                                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                                                initialRating: data['customerRate'].toDouble(),
                                                                itemCount: 5,
                                                                itemBuilder: (context,i){
                                                                  return Icon(Icons.star,size:5,color:Colors.amber);
                                                                },
                                                                onRatingUpdate: (newRating){
                                                                  setState(() {
                                                                    updateRate(newRating.toDouble(),data['customerRate'].toDouble(),data['customerId']);
                                                                  });
                                                                }
                                                            ),
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
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                        MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      const WorkerHomePage(),
                                                                ));
                                                              },
                                                              child: Text(
                                                                TKeys.WongoingInReviewDoneButton.translate(context),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
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
                                                                  builder: (BuildContext context) => ComplainPage(
                                                                      Wid: data[
                                                                          'workerId'],
                                                                      Cid: data[
                                                                          'customerId'],
                                                                      Cname: data[
                                                                          'customerName']),
                                                                ));
                                                              },
                                                              child: Text(
                                                                TKeys.WongoingInComplainButton.translate(context),
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
                                          TKeys.WongoingInEndDoneButton.translate(context),
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
                                          TKeys.WongoingInEndCancelButton.translate(context),
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
                                title: Text(TKeys.WongoingInCancelMessageTitle.translate(context)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content:
                                    Text(TKeys.WongoingInCancelMessageContent.translate(context)),
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
                                          CollectionReference Noti =
                                              db.requests();
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
                                          TKeys.WongoingInCancelMessageOkButton.translate(context),
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
                                          TKeys.WongoingInCancelMessageNoButton.translate(context),
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
