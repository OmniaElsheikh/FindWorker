
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/userPages/userSurvay.dart';
import '../controller/localization_service.dart';
import '../t_key.dart';
import 'User_complain_page.dart';
import 'home_page.dart';

late globals.FireBase db = new globals.FireBase();

class UserOngoingRequestPage extends StatefulWidget {
  final id;
  const UserOngoingRequestPage({this.id, Key? key}) : super(key: key);

  @override
  State<UserOngoingRequestPage> createState() => _UserOngoingRequestPageState();
}

bool isRequested = false;
var textforbutton = "Send Request";
dynamic fontSize = 18.0;
dynamic sizedBox = 15.0;
late dynamic city='Faisal';
late dynamic country='Giza';
late dynamic data = {'': dynamic};
late dynamic Wdata = {'': dynamic};

class _UserOngoingRequestPageState extends State<UserOngoingRequestPage> {
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
    Stream<QuerySnapshot> usersSnapshot =
    await db.worker().doc('${data['workerId']}').get().then(
          (DocumentSnapshot doc) {
        setState(() {
          Wdata = doc.data() as Map<String, dynamic>;
        });
        return Wdata;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    location(Wdata['location']);
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
  updateRate(New,Old,Id){
    double rate=(New+Old)/2.0;
    FirebaseFirestore.instance.collection('worker').doc(data['workerId']).update({
      'rate':rate
    });
    print('done rate update');
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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading: Container(
            margin: EdgeInsets.all(3),
            child: CircleAvatar(
              foregroundImage: AssetImage("images/worker-icon2.png"),
            )),
        title: Center(
          child: Text(
            TKeys.WongoingTitle.translate(context),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.deepOrange,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
           color: Color(0xff33f0b7a1)),
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
                      "${data['workerImage']}",
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
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Name : ${data['workerName']}",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Phone ${data['workerPhone']}",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Location : ${city}, ${country}",
                            style: TextStyle(
                                fontSize: fontSize, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: sizedBox,
                          ),
                          Text(
                            "Min Transportation Fee : 30 L.E",
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
              )
              ),
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
                        UserSurvayPage(workerId:data['workerId']);
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
                                                  title: Container(
                                                    height: 100,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            IconButton(onPressed: (){
                                                              Navigator.of(context).pushReplacementNamed("customerHomePage");
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
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("${data['workerName']}")
                                                          ],
                                                        )
                                                      ],
                                                    ),
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
                                                              "${data['workerImage']}",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height:35,
                                                          child: Text(
                                                            "Name : ${data['workerName']}",
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
                                                              "Rate : ${data['workerRate'].toStringAsFixed(2)}",
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
                                                        width: 150,
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            RatingBar.builder(
                                                                updateOnDrag: true,
                                                                itemSize:25,
                                                                minRating:1,
                                                                allowHalfRating:true,
                                                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                                                initialRating: data['workerRate'].toDouble(),
                                                                itemCount: 5,
                                                                itemBuilder: (context,i){
                                                                  return Icon(Icons.star,size:1,color:Colors.amber);
                                                                },
                                                                onRatingUpdate: (newRating){
                                                                  setState(() {
                                                                    updateRate(newRating,data['workerRate'].toDouble(),data['workerId']);
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
                                                                        context).pop();
                                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                                  return UserSurvayPage(workerId: data['workerId'],);
                                                                }));
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
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      UserComplainPage(
                                                                    Cid: data[
                                                                        'customerId'],
                                                                    Wid: data[
                                                                        'workerId'],
                                                                    Wname: data[
                                                                        'workerName'],
                                                                  ),
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
                                                const UserHomePage(),
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
