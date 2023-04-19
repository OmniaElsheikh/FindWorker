import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import 'ongoingReq_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

bool isRequested= false;
var textforbutton="Send Request";
dynamic count=4;

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading:Container(
            margin: EdgeInsets.all(3),
            child: CircleAvatar(foregroundImage: AssetImage("images/worker-icon2.png"),
            )
        ),
        title: Center(
          child: Text(
            "Notifications",
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        actions: [
          SizedBox(width: 5,),
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement( MaterialPageRoute (
              builder: (BuildContext context) => const LoginPage(),));
          }, icon:Icon(Icons.logout_outlined,color: Colors.deepOrange,)),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        backgroundColor: Colors.white.withOpacity(0.7),
        child: IconButton(onPressed: (){}, icon:Icon(Icons.skip_previous,color: Colors.deepOrange,size: 35,) ),
      ),*/
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(globals.BGImg),
              fit: BoxFit.fill,
            )
        ),
        child: ListView.separated(itemBuilder: (context,i)=>Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: globals.ContColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                 child: CircleAvatar(foregroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFxnhyWUbRrd-xrwdGcLypuLqJy4gaKg-v2Q&usqp=CAU"),
                )),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Incoming Request",style: TextStyle(color: Colors.indigo[900],fontSize: 15),),
                    Text("Name : Ahmed",style: TextStyle(color: Colors.black)),
                    MaterialButton(
                        onPressed: (){
                          showBottomSheet(backgroundColor:Colors.black26.withOpacity(0.5),context: context, builder: (context){
                            return AlertDialog(
                              backgroundColor: Colors.grey[500],
                              title: Text("Client's Details"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              content: Container(
                                height: 300,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 180,
                                        width: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFxnhyWUbRrd-xrwdGcLypuLqJy4gaKg-v2Q&usqp=CAU",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text("Name : Ahmed",style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5,),
                                      Text("Estimated Time : 5 Minutes",style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.deepOrange,size: 20,),
                                          SizedBox(width: 5),
                                          Text(
                                            "Rate : 8.5",
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Icon(Icons.phone, color: Colors.deepOrange,size: 20,),
                                          SizedBox(width: 5),
                                          Text(
                                            "Phone : 01010948755",
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      height: 40,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.indigo.shade900,
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),),
                                    ),
                                    SizedBox(width: 10,),
                                    MaterialButton(
                                      height: 40,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.indigo.shade900,
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Call",style: TextStyle(color: Colors.white,fontSize: 20),),
                                    )
                                  ],
                                )

                              ],
                            );
                          });

                        },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      height: 30,
                      color: Colors.indigo,
                      child: Text("More info",style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
                Expanded(child: Container()),
                Expanded(
                  flex: 18,
                  child: MaterialButton(
                    minWidth: 80,
                    height: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.green,
                    onPressed: (){
                      Navigator.of(context).pushReplacement( MaterialPageRoute (
                        builder: (BuildContext context) => const OngoingRequestPage(),));
                      setState(() {
                        count--;
                      });
                    },
                    child: Text("Accept",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 18,
                  child: MaterialButton(
                    minWidth: 80,
                    height: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.deepOrange[400],
                    onPressed: (){
                      setState(() {
                        count--;
                      });
                    },
                    child: Text("Refuse",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                  ),
                ),

              ],
            ),
          ),
              separatorBuilder: (context,i)=>SizedBox(height: 5,),
              itemCount: count
          ),
      ),
    );
  }
}
