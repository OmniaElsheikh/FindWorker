import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_1/shared/globals.dart' as globals;

class WorkerProfilePage extends StatefulWidget {
  final id;
  const WorkerProfilePage({this.id,Key? key}) : super(key: key);

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}
bool favorit = false;
bool isRequested= false;
var textforbutton="Send Request";

List posts = [
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
  "https://cdn.accentuate.io/5804795035810/1669665007055/Photo-Gallery-4.jpg?v=1669665007055",
];
late dynamic id;
late dynamic data;
class _WorkerProfilePageState extends State<WorkerProfilePage> {
  List workers=[];
  CollectionReference Workers = FirebaseFirestore.instance.collection('worker');
  getData()async{
    var response=await Workers.get();
    response.docs.forEach((element) {
      setState(() {
        if(element['id']==widget.id) {
          setState(() {
            workers.add(element['id']);
            id=element['id'];
          });
          print(id);
        }
      });
    });
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection("worker").doc(widget.id).get().then(
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Worker Profile",style: TextStyle(
            color: Colors.deepOrange
          ),),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.deepOrange
        ),
        automaticallyImplyLeading: true,
      ),
      body:  workers==null||workers.isEmpty
          ?Container(child:Center(child: Text("Loading",style: TextStyle(color: Colors.indigo.shade900,fontSize: 35),),),)
          :StreamBuilder(
          stream:FirebaseFirestore.instance.collection('worker').doc(widget.id).get().asStream(),
          builder: (BuildContext context,snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const Text("Loading",style: TextStyle(fontSize: 30),));
            }

            return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(globals.BGImg),
                fit: BoxFit.fill,
              ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  color: globals.ContColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.network("https://th.bing.com/th/id/OIP.idZujeAveK_cp-_JidMxWQHaGD?pid=ImgDet&rs=1",   fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                      children: [
                      Text(
                        "${data['workerName']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${data['phone']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.deepOrange),
                              SizedBox(width: 5),
                              Text(
                                "9.5",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          icon: favorit?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border,),
                        onPressed: (){
                          setState(() {});
                          favorit =!favorit;
                        }, ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {globals.userOnReq=!globals.userOnReq;});
                            isRequested? textforbutton="Send Request" :textforbutton = "Cancel Request";
                            isRequested=!isRequested;
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          textColor: Colors.deepOrange,
                          color: Colors.white,
                          child: Text("${textforbutton}"),
                        ),
                      ),
                        Container(
                          margin: EdgeInsets.only(top: 1),
                            child: globals.userOnReq?Text("You Are on Request",style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):Text("You can Send Request",style:TextStyle(color: Colors.green,fontWeight: FontWeight.w900)))
                      ],
                    ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: globals.ContColor,
                ),
                child:  GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, i) => Container(
                    width: 100
                    ,height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Image.network(
                                "${posts[i]}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                    ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );}),
    );
  }
}
