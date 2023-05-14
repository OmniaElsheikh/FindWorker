import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp_1/shared/globals.dart' as globals;

import '../LogIn&signUp/login.dart';
import '../controller/localization_service.dart';
import '../t_key.dart';
late globals.FireBase db = new globals.FireBase();

class UserGuidePage extends StatefulWidget {
  const UserGuidePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  final localizationController=Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              TKeys.CguideNavbar.translate(context),
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.deepOrange),
          automaticallyImplyLeading: false,
          leading:Container(
              margin: EdgeInsets.all(3),
              child: CircleAvatar(
                foregroundImage: AssetImage("images/worker-icon2.png"),
              )
          ),
        actions: [
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                localizationController.toggleLanguge();
              });
            },child: Text(TKeys.WsettingLanguageButton.translate(context),style: TextStyle(color: Colors.deepOrange),),),
          ),
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
              )),],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(globals.BGImg),
          fit: BoxFit.fill,
        )),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Container(
          height: double.infinity,
          decoration:BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15)
          ),
          child: ListView(
            children:[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 8),
                alignment: Alignment.center,
                child: Center(
                    child:Text(TKeys.CguideTitle.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.indigo.shade900,fontSize: 25,fontWeight: FontWeight.bold))
                ),
              ),
              SizedBox(height: 15,),
              Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideNotifcatin.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.person_pin,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideProfile.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.category,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideCategory.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.logout,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideLogout.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.language,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideLanguage.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.search,color:Colors.deepOrange,size: 25,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.indigo.shade900,width: 0.8)
                              ),
                              child:Text(TKeys.CguideSearch.translate(context),textAlign: TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),)
            ]
          ),
        ),
      ),
    );
  }
}
