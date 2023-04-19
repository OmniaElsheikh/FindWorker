import 'package:flutter/material.dart';
import 'package:gp_1/LogIn&signUp/login.dart';
import 'package:gp_1/userPages/user_setting_page.dart';
import 'package:gp_1/userPages/worker_profile_page.dart';
import 'package:gp_1/shared/globals.dart' as globals;
import '../userPages/filterd_page.dart';
class WorkerCategoriesPage extends StatefulWidget {
  const WorkerCategoriesPage({Key? key}) : super(key: key);

  @override
  State<WorkerCategoriesPage> createState() => _WorkerCategoriesPageState();
}

class _WorkerCategoriesPageState extends State<WorkerCategoriesPage> {

  List category = [
    'carpenter',
    'Plumber',
    'blacksmith',
    'Plumber',
    'blacksmith',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.deepOrange,onPressed: (){
        Navigator.pop(context);
        },)

        ,backgroundColor: Colors.white,
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(icon: Icon(Icons.search,color: Colors.deepOrange,),onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          }),
        ),],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(globals.BGImg),
                fit: BoxFit.fill,
              )
          ),
          child: GridView.builder(
              itemCount: category.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36.0),
                      color: globals.ContColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(1, 1))
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${category[i]}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FilterdPage();
                      },
                    ));
                  },
                ),
              ))),
    );
  }
}

class DataSearch extends SearchDelegate{
  List workers = [
    "motasem mohamed",
    "omnia",
    "sheka"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton( icon: Icon(Icons.close,color: Colors.deepOrange),onPressed: (){
        query = "";
      },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return  IconButton( icon: Icon(Icons.arrow_back,color: Colors.deepOrange,),onPressed: (){
      close(context, null);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("data");
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List filterdworkers = workers.where((element) => element.startsWith(query)).toList();
    return Container(
      color: globals.ContColor,
      child:   ListView.builder(

          itemCount: query ==""? workers.length: filterdworkers.length,

          itemBuilder: (context,i){

            return InkWell(

              onTap: (){

                Navigator.of(context).push(MaterialPageRoute(

                  builder: (context) {

                    return WorkerProfilePage();

                  },

                ));

              },

              child: Container(

                  padding: EdgeInsets.all(10),

                  child: query==""?Text("${workers[i]}",style: TextStyle(color: Colors.indigo.shade900),):

                  Text("${filterdworkers[i]}")

              ),

            );

          }

      ),
    );
  }
}

