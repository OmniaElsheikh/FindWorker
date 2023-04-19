import 'package:flutter/material.dart';
import 'package:gp_1/workerPages/notification_page.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'complain_page.dart';
import 'home_page.dart';

class OngoingRequestPage extends StatefulWidget {
  const OngoingRequestPage({Key? key}) : super(key: key);

  @override
  State<OngoingRequestPage> createState() => _OngoingRequestPageState();
}

bool isRequested = false;
var textforbutton = "Send Request";
dynamic fontSize = 18.0;
dynamic sizedBox = 15.0;

class _OngoingRequestPageState extends State<OngoingRequestPage> {
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
            "Ongoing Request",
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
                "Ongoing Request",
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
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFxnhyWUbRrd-xrwdGcLypuLqJy4gaKg-v2Q&usqp=CAU",
                      fit: BoxFit.fill,
                    )),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Column(
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
                    Column(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: sizedBox,
                        ),
                        Text(
                          "Ahmed",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: sizedBox,
                        ),
                        Text(
                          "0123456789",
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
                          "10 Minutes",
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
                                title: Text("Note"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content:
                                    Text("Are you sure you want to end it?"),
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
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor: Colors.black26
                                                  .withOpacity(0.5),
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: Text(
                                                      "Review On Client : Ahmed"),
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
                                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFxnhyWUbRrd-xrwdGcLypuLqJy4gaKg-v2Q&usqp=CAU",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            "Name : Ahmed",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 20),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Rate : 7.5",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .deepOrange,
                                                              size: 20,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .deepOrange,
                                                              size: 20,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .deepOrange,
                                                              size: 20,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .deepOrange,
                                                              size: 20,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                                                "Done",
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
                                                                      const ComplainPage(),
                                                                ));
                                                              },
                                                              child: Text(
                                                                "Complain",
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
                                          "End",
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
                                          "Cancel",
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
                        "End Job",
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
                                title: Text("Note"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content:
                                    Text("Are you sure you want to cancel it?"),
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
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const WorkerHomePage(),
                                          ));
                                        },
                                        child: Text(
                                          "Yes",
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
                                          "No",
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
                        "Cancel Job",
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
