import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_alarm.dart';
import 'login.dart';

class Alarm extends StatefulWidget {
  const Alarm({Key? key}) : super(key: key);

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  bool isSwitched = true;
  var alarmsound = 'homecoming';


  final _auth = FirebaseAuth.instance;
  static String userEmail="";
  void getCurrentUserEmail() async {
    final user = await _auth.currentUser!.email;
    print(user);
    userEmail=user!;
    print(userEmail);
  }
  void initState() {
    getCurrentUserEmail();
    super.initState();
  }

  void onSelected(BuildContext context,int item){
    switch(item){
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => user()));
        break;
    }
  }
  bool check=true;


  delete(int index)async{
    try{
      QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('alarm').get();
      if(querySnap.docs.length>=1){
        setState(() {
          QueryDocumentSnapshot doc = querySnap.docs[index];
          DocumentReference docRef = doc.reference;
          // final DocUser=FirebaseFirestore.instance.collection("alarm").doc(docRef.id);
          FirebaseFirestore.instance.collection('alarm').doc(docRef.id).delete();
          print(docRef.id);
          print("upp");
          print("deleted");
        });
      }
    }catch(e){
      log(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int value;
    return Scaffold(
      backgroundColor: Color(0xff010101),
      body:NestedScrollView(
        headerSliverBuilder:(cpntext,innerBoxIsScrolled)=>[
          SliverAppBar(
            toolbarHeight: 70,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back,size: 35,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => user()));},
              ),
              IconButton(
                icon: Icon(Icons.add,size: 35,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Add()));},
              ),
              PopupMenuButton<int>(
                onSelected:(item)=>onSelected(context,item),
                itemBuilder:(contex)=>[
                  PopupMenuItem<int>(
                    value: value = 0,
                    child:Text('Settings'),
                  ),
                ],
              ),
            ],

            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Alarm",style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,fontSize: 25),
              ),
            ),


            floating: true,
            pinned: true,
            backgroundColor: Color(0xff010101),
            expandedHeight: 200,
            flexibleSpace: StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection("alarm").where("status",isEqualTo: true).where("user",isEqualTo: userEmail).snapshots(),
                builder:(context,snapshot){
                  if(snapshot.hasError){
                    return Center(child:Text("Error pccured",style: TextStyle(color: Colors.white,fontSize: 20),));
                  }
                  if(snapshot.hasData){
                    var count =snapshot.data!.docs.length;
                    if(count==0){
                      return FlexibleSpaceBar(
                        background: Align(alignment: Alignment.center,
                          child: Text("all alarms are off",style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        ),
                      );
                    }
                    else{
                      List<Duration> best=[];
                      var timee=(snapshot.data!.docs[count-1]["time"]);
                      DateTime tempDate = new DateFormat("hh:mm").parse(timee);
                      var formattedDate = DateFormat('hh:mm').format(DateTime.now());
                      DateTime dayee= DateFormat('hh:mm').parse(formattedDate);
                      var dur=tempDate.difference(dayee);
                      var besst=dur;
                      while(count>0){
                        var text;
                        var timee=(snapshot.data!.docs[count-1]["time"]);
                        DateTime tempDate = new DateFormat("hh:mm").parse(timee);
                        var formattedDate = DateFormat('hh:mm').format(DateTime.now());
                        DateTime dayee= DateFormat('hh:mm').parse(formattedDate);
                        var dur=tempDate.difference(dayee);
                        if(besst>dur){
                          besst=dur;
                        }
                        best.add(dur);
                        count--;
                      }

                      int min;
                      int hour;
                      print(besst);
                      print(besst.isNegative);
                      if(besst.isNegative){
                        min=besst.inMinutes as int;
                        hour=besst.inHours as int;
                        hour=(hour*60) as int;
                        min=min-hour;
                        min=min.abs();
                        hour=(hour/60).round();
                        hour+=24;
                        print("neg");
                        print(hour);
                        print(min);
                      }
                      else{
                        min=besst.inMinutes as int;
                        print(min);
                        hour=besst.inHours as int;
                        print(hour);
                        hour=(hour*60) as int;
                        print(hour);
                        min=min-hour;
                        hour=(hour/60).round() as int;
                        print(hour);
                        print(min);
                      }
                      print(besst);

                      if(min==0 && hour!=0){
                        return FlexibleSpaceBar(
                          background: Align(alignment: Alignment.center,
                            child: Text("Alarm in $hour hours",style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            // background: Text("all alarms are off",style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        );
                      }
                      else if(hour==0 && min!=0){
                        return FlexibleSpaceBar(
                          background: Align(alignment: Alignment.center,
                            child: Text("Alarm in $min minutes",style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            // background: Text("all alarms are off",style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        );
                      }
                      else if(hour==0 && min==0){
                        return FlexibleSpaceBar(
                          background: Align(alignment: Alignment.center,
                            child: Text("Alarm up",style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            // background: Text("all alarms are off",style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        );
                      }
                      else {
                        return FlexibleSpaceBar(
                          background: Align(alignment: Alignment.center,
                            child: Text("Alarm in $hour hours\n $min minutes",style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            // background: Text("all alarms are off",style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        );
                      }

                    }

                  }

                  return Center(child:CircularProgressIndicator());
                }

            ),
          ),
        ],

        body:StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection("alarm").snapshots(),
            builder:(context,snapshot){
              if(snapshot.hasError){
                return Center(child:Text("Error pccured"));
              }
              if(snapshot.hasData){
                var checks=snapshot.data!.docs.length;
                if(checks>0){
                  return ListView.builder(
                    itemCount:snapshot.data!.docs.length,
                    itemBuilder:(context,index)=>
                        Container(
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
                                  color: Color(0xfff303030),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        onLongPress: (){
                                          // savealarm(index);
                                          print(snapshot.data?.docs[index]["time"]);
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (context)=>
                                                builderActionSheet(BuildContext,context,index),
                                          );
                                        } ,
                                        // leading: Text(snapshot.data!.docs[index]["Alarm_name"],style:TextStyle(fontSize: 15,color: Colors.white),),
                                        subtitle: Text(snapshot.data!.docs[index]["time"], style:TextStyle(fontSize: 25,color: Colors.white),),
                                        title: Text(snapshot.data!.docs[index]["Alarm_name"],textAlign: TextAlign.end, style: TextStyle(fontSize: 15,color: Colors.white),),
                                        trailing:Transform.scale(
                                            scale: 1.3,
                                            child: Switch(
                                              onChanged:(bool value) async {
                                                if(!snapshot.data!.docs[index]["status"])
                                                {
                                                  QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('alarm')
                                                      .where('time', isEqualTo: snapshot.data!.docs[index]["time"]).get();
                                                  setState(() {
                                                    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document, THE doc you are looking for.
                                                    DocumentReference docRef = doc.reference;
                                                    // print(docRef.id);
                                                    final DocUser=FirebaseFirestore.instance.collection("alarm").doc(docRef.id);
                                                    DocUser.update({
                                                      "status":true
                                                    });
                                                    // print(D/ocUser);
                                                    alarmsound = 'homecoming';
                                                  });
                                                }
                                                else
                                                {
                                                  QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('alarm')
                                                      .where('time', isEqualTo: snapshot.data!.docs[index]["time"]).get();
                                                  setState(() {
                                                    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document, THE doc you are looking for.
                                                    DocumentReference docRef = doc.reference;
                                                    final DocUser=FirebaseFirestore.instance.collection("alarm").doc(docRef.id);
                                                    DocUser.update({
                                                      "status":false
                                                    });
                                                    alarmsound = 'off';
                                                  });
                                                }
                                              },
                                              value: snapshot.data!.docs[index]["status"],
                                              activeColor: Colors.white,
                                              activeTrackColor: Color(0xff8587fe),
                                              inactiveThumbColor: Colors.white,
                                              // inactiveTrackColor: Colors.black,
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),

                  );
                }

                else{
                  return Center(child: Text("No alarms",style: TextStyle(fontSize: 20,color:Colors.white,)));

                }


              }

              return Center(child:CircularProgressIndicator());
            }

        ),
        // Container(
        //   child: Column(
        //     children: [
        //       if(check)...[
        //         Container(
        //           height: 120,
        //           child: Card(
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
        //             color: Color(0xfff303030),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 ListTile(
        //                   leading: Text("check",style:TextStyle(fontSize: 15,color: Colors.white),),
        //                   subtitle: Text("60", style:TextStyle(fontSize: 25,color: Colors.white),),
        //                   title: Text("sundey",textAlign: TextAlign.end, style: TextStyle(fontSize: 15,color: Colors.white),),
        //                   trailing:Transform.scale(
        //                       scale: 1.3,
        //                       child: Switch(
        //                         onChanged: soundSwitch,
        //                         value: isSwitched,
        //                         activeColor: Colors.white,
        //                         activeTrackColor: Color(0xff8587fe),
        //                         inactiveThumbColor: Colors.white,
        //                         // inactiveTrackColor: Colors.black,
        //                       )
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 15,),
        //
        //
        //
        //       ]
        //       else if(!check)...[
        //         SizedBox(height: 30,),
        //         Text("No alarms",style: TextStyle(fontSize: 20,color:Colors.white24,),),
        //       ]
        //
        //     ],
        //   ),
        // ),
      ),

    );

  }

  Widget builderActionSheet(BuildContext,context, int id)=>CupertinoTheme(
    data: CupertinoThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.dark,
    ),
    child: CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: ()async {
          delete(id);
          Navigator.pop(context);
        },
        child: Text('delete'),
      ),
    ),
  );

}
