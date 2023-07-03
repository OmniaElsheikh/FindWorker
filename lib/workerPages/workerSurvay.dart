import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp_1/t_key.dart';
import 'package:gp_1/userPages/home_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import 'home_page.dart';

late globals.FireBase db = new globals.FireBase();

class WorkerSurvayPage extends StatefulWidget {
  final customerId;
  const WorkerSurvayPage({this.customerId, Key? key}) : super(key: key);

  @override
  State<WorkerSurvayPage> createState() => _WorkerSurvayPageState();
}

late dynamic data = GeoPoint(11.11111, 12.11111);
late dynamic id = '';
late dynamic uid;

class _WorkerSurvayPageState extends State<WorkerSurvayPage>
    with WidgetsBindingObserver {
  CollectionReference Workers = db.worker();
  getData() async {
    var response = await Workers.get();
    response.docs.forEach((element) {
      setState(() {
        if (element['customerUID'] == uid) {
          id = element['id'];
          data = element['location'];
        }
      });
    });
  }
dynamic var1=0.0,var2=0.0,var3=0.0,var4=0,var5=0.0;
  done(BuildContext context)async{
    dynamic y=0.0;
    var x=((var1+var2+var3+var4+var5)/25.0)/5.0;
    print(x);
    await FirebaseFirestore.instance.collection('customer').doc("${widget.customerId}").get().then((value) {y=value.data()!['rate'];});
    var z=x+y;
   await FirebaseFirestore.instance.collection('customer').doc("${widget.customerId}").update({'rate':z,});
    showDialog(context: context, builder:(context){return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
        title:Text(TKeys.CsurveyDoneTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
        content:Text(TKeys.CsurveyDoneContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color:Colors.deepOrange,
                  minWidth:40,
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (contex){
                      return WorkerHomePage();
                    })
                    );
                  },
                  child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
              )
            ],
          )
        ],
      );
    });
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
      body: Container(
          decoration: BoxDecoration(
            color: globals.backColor),
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return WorkerHomePage();
                      }));
                    },
                    icon: Icon(Icons.cancel_rounded,color:Colors.white,size: 30,),
                  ),
                  Expanded(child: Container(),),
                  Text(TKeys.CsurveyTitle.translate(context),style: TextStyle(color: Colors.black,fontSize: 30),)
                ],
              ),
              SizedBox(height: 50,),
              Row(
                children: [
                  Column(
                    children: [
                      Text(TKeys.WsurveyQ1.translate(context),style: TextStyle(color:Colors.black),),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 70,
                            child: RatingBar.builder(
                                updateOnDrag: true,
                                itemSize:40,
                                minRating:1,
                                allowHalfRating:true,
                                unratedColor: Colors.grey,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                initialRating: 1,
                                itemCount: 5,
                                itemBuilder: (context,i){
                                  return Icon(Icons.circle,size:1,color:Colors.deepOrange);
                                },
                                onRatingUpdate: (newRating){
                                  setState(() {
                                    var1=newRating;
                                  });
                                }
                            ),
                          ),
                          SizedBox(width: 50,),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
                                title:Text(TKeys.CsurveyInfoTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                content:Text(TKeys.CsurveyInfoContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          color:Colors.deepOrange,
                                          minWidth:40,
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.info_outline,color:Colors.deepOrange,size:40)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    children: [
                      Text(TKeys.WsurveyQ2.translate(context),style: TextStyle(color:Colors.black),),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 70,
                            child: RatingBar.builder(
                                updateOnDrag: true,
                                itemSize:40,
                                minRating:1,
                                allowHalfRating:true,
                                unratedColor: Colors.grey,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                initialRating: 1,
                                itemCount: 5,
                                itemBuilder: (context,i){
                                  return Icon(Icons.circle,size:1,color:Colors.deepOrange);
                                },
                                onRatingUpdate: (newRating){
                                  setState(() {
                                    var2=newRating;
                                  });
                                }
                            ),
                          ),
                          SizedBox(width: 50,),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
                                title:Text(TKeys.CsurveyInfoTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                content:Text(TKeys.CsurveyInfoContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          color:Colors.deepOrange,
                                          minWidth:40,
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.info_outline,color:Colors.deepOrange,size:40)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    children: [
                      Text(TKeys.WsurveyQ3.translate(context),style: TextStyle(color:Colors.black),),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 70,
                            child: RatingBar.builder(
                                updateOnDrag: true,
                                itemSize:40,
                                minRating:1,
                                allowHalfRating:true,
                                unratedColor: Colors.grey,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                initialRating: 1,
                                itemCount: 5,
                                itemBuilder: (context,i){
                                  return Icon(Icons.circle,size:1,color:Colors.deepOrange);
                                },
                                onRatingUpdate: (newRating){
                                  setState(() {
                                    var3=newRating;
                                  });
                                }
                            ),
                          ),
                          SizedBox(width: 50,),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
                                title:Text(TKeys.CsurveyInfoTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                content:Text(TKeys.CsurveyInfoContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          color:Colors.deepOrange,
                                          minWidth:40,
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.info_outline,color:Colors.deepOrange,size:40)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    children: [
                      Text(TKeys.WsurveyQ4.translate(context),maxLines:2,style: TextStyle(color:Colors.black),),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 70,
                            child: RatingBar.builder(
                                updateOnDrag: true,
                                itemSize:40,
                                minRating:1,
                                allowHalfRating:true,
                                unratedColor: Colors.grey,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                initialRating: 1,
                                itemCount: 5,
                                itemBuilder: (context,i){
                                  return Icon(Icons.circle,size:1,color:Colors.deepOrange);
                                },
                                onRatingUpdate: (newRating){
                                  setState(() {
                                    var4=newRating;
                                  });
                                }
                            ),
                          ),
                          SizedBox(width: 50,),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
                                title:Text(TKeys.CsurveyInfoTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                content:Text(TKeys.CsurveyInfoContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          color:Colors.deepOrange,
                                          minWidth:40,
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.info_outline,color:Colors.deepOrange,size:40)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    children: [
                      Text(TKeys.WsurveyQ5.translate(context),maxLines:2,style: TextStyle(color:Colors.black),),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 70,
                            child: RatingBar.builder(
                                updateOnDrag: true,
                                itemSize:40,
                                minRating:1,
                                allowHalfRating:true,
                                unratedColor: Colors.grey,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                initialRating: 1,
                                itemCount: 5,
                                itemBuilder: (context,i){
                                  return Icon(Icons.circle,size:1,color:Colors.deepOrange);
                                },
                                onRatingUpdate: (newRating){
                                  setState(() {
                                    var5=newRating;
                                  });
                                }
                            ),
                          ),
                          SizedBox(width: 50,),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                icon:Icon(Icons.info_outline,color:Colors.deepOrange,size:60),
                                title:Text(TKeys.CsurveyInfoTitle.translate(context),style:TextStyle(fontSize:25,color:Colors.indigo.shade900)),
                                content:Text(TKeys.CsurveyInfoContent.translate(context),style:TextStyle(fontSize: 15,color:Colors.indigo.shade900)),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          color:Colors.deepOrange,
                                          minWidth:40,
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child:Text(TKeys.WactivButtonOk.translate(context),style: TextStyle(color:Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.info_outline,color:Colors.deepOrange,size:40)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: (){
                      done(context);
                    },child: Text(TKeys.CsurveyDone.translate(context),style: TextStyle(color:Colors.white),),
                    color: Colors.green,
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}
