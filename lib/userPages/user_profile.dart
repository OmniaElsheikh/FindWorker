import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/workerPages/setting_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import 'package:gp_1/workerPages/worker_categories_page.dart';
import '../LogIn&signUp/login.dart';
import '../userPages/categories_page.dart';
import 'home_page.dart';
dynamic UID;
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();


}

bool isRequested = false;
var textforbutton = "Send Request";

List post = [
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
];
bool noti = false;
late dynamic id;
late dynamic uid;
late dynamic data;
class _UserProfileState extends State<UserProfile> {
  List customers=[];
  CollectionReference Customers = FirebaseFirestore.instance.collection('customer');
  getData()async{
    var response=await Customers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['customerUID']==uid) {
          customers.add(element['id']);
          id=element['id'];
        }
      });
    });
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection("customer").doc(id).get().then(
          (DocumentSnapshot doc){
        data = doc.data() as Map<String, dynamic>;
        return data;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

  }






  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid;
    getData();
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
          SizedBox(width: 5,),
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement( MaterialPageRoute (
              builder: (BuildContext context) => const LoginPage(),));
          }, icon:Icon(Icons.logout_outlined,color: Colors.deepOrange,)),
        ],
      ),
      body: customers==null||customers.isEmpty
          ?Container(child:Center(child: Text("Loading",style: TextStyle(color: Colors.indigo.shade900,fontSize: 35),),),)
          :StreamBuilder(
          stream:FirebaseFirestore.instance.collection('customer').doc(id).get().asStream(),
          builder: (BuildContext context,snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(globals.BGImg),
                    fit: BoxFit.fill,
                  )),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                shrinkWrap: false,
                children:[
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
                                    "https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",
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
                                    "Location : Giza, Faisal",
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
                                        fontWeight: FontWeight.bold, fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.deepOrange,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "9.5",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 20),
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
                              Navigator.of(context).pushNamed("userSettings");
                            },
                            child: Text(
                              "Edit Info",
                              style: TextStyle(color: Colors.deepOrange,fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]
              ),
            );
          }
      ),
    );
  }
}
