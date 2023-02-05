import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'package:getwidget/getwidget.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController Alarm_name=TextEditingController();
  TextEditingController Alarm_sound =TextEditingController();
  bool Checkedm = false;
  bool Checkedt = false;
  bool Checkedw = false;
  bool Checkedth = false;
  bool Checkedf = false;
  bool Checkeds = false;
  bool Checkedsu = false;
  List<String> checks=[];
  String pri="";
  List<String> check(){
    List<bool> list = [Checkedm,Checkedt,Checkedw,Checkedth,Checkedf,Checkeds,Checkedsu];
    List<String> name = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    String names="";
    int count = 0;
    checks.clear();
    pri="";
    for (int i = 0; i < list.length; i++) {
      if (list.elementAt(i) == true) {
        names=name.elementAt(i);
        pri+="$names,";
        checks.add(names);
      }
    }
    setState(() {});
    return checks;
    //   return count;
    // }
  }


  bool alarmsound = true;
  bool vibration = true;
  bool snooze = true;
  var textalarmsound = 'homecoming';
  var textvibration = 'basic call';
  var textsnooze = '5 minutes';
  bool status=true;

  void soundSwitch(bool value) {

    if(alarmsound == false)
    {
      setState(() {
        alarmsound = true;
        textalarmsound = 'homecoming';
      });
      // print('Switch Button is ON');
    }
    else
    {
      setState(() {
        alarmsound = false;
        textalarmsound = 'off';
      });
      // print('Switch Button is OFF');
    }
  }
  void vibrationSwitch(bool value) {

    if(vibration == false)
    {
      setState(() {
        vibration = true;
        textvibration = 'basic call';
      });
      // print('Switch Button is ON');
    }
    else
    {
      setState(() {
        vibration = false;
        textvibration = 'off';
      });
      // print('Switch Button is OFF');
    }
  }
  void snoozeSwitch(bool value) {

    if(snooze == false)
    {
      setState(() {
        snooze = true;
        textsnooze = '5 minutes';
      });
      // print('Switch Button is ON');
    }
    else
    {
      setState(() {
        snooze = false;
        textsnooze = 'off';
      });
      // print('Switch Button is OFF');
    }
  }

  DateTime _dateTime=DateTime.now();
  var date=DateTime(DateTime.now().day+1);
  DateTime picked=DateTime.now();
  var formattedDate= DateFormat('hh:mm a').format(DateTime.now());

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


  bool isLoading=false;
  savealarm()async{
    try{
      print(Alarm_name);
      isLoading=true;

      QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('alarm')
          .where('time', isEqualTo: formattedDate).where('user',isEqualTo: userEmail).get();
      if(querySnap.docs.length==1){
        setState(() {
          QueryDocumentSnapshot doc = querySnap.docs[0];
          DocumentReference docRef = doc.reference;
          final DocUser=FirebaseFirestore.instance.collection("alarm").doc(docRef.id);
          DocUser.update({
              "Alarm_name":Alarm_name.text,
              "sound":alarmsound,
              "vibration":vibration,
              "snooze":snooze,
              "date":checks,
              "status":status,
          });
        });
      }
      else if(querySnap.docs.length==0){
        setState(() {});
        var response= await FirebaseFirestore.instance.collection("alarm").add({
          "Alarm_name":Alarm_name.text,
          "time":formattedDate,
          "sound":alarmsound,
          "vibration":vibration,
          "snooze":snooze,
          "date":checks,
          "status":status,
          "user":userEmail,
        });
      }
      print("SUCCESS");
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Home()));

    }catch(e){
      log(e.toString());
    }
    isLoading=false;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Color(0xff010101),
        bottomNavigationBar: Row(
          children: [
            Material(
              color: Color(0xff010101),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Home()));
                },
                child: const SizedBox(
                  height: kToolbarHeight,
                  width: 200,
                  child: Center(
                    child: Text(
                      'cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Color(0xff010101),
                child: InkWell(
                  onTap: () {
                    // print(time.toString());
                    print(formattedDate);
                    print(alarmsound);
                    print(vibration);
                    print(snooze);
                    print(checks);
                    print(Alarm_name);
                    savealarm();
                  },
                  child: const SizedBox(
                    height: kToolbarHeight,
                    child: Center(
                      child: Text(
                        'save',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox(height: 90,),
            SizedBox(
              height:200,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.white,
                      // color: CupertinoDynamicColor.resolve(CupertinoColors.white, context)
                    ),
                  ),
                ),
                child:CupertinoDatePicker(
                  minuteInterval: 1,
                  initialDateTime:_dateTime,
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged:(dateTime){
                    setState((){
                      _dateTime=dateTime;
                      // time=DateFormat('hh:mm a').format(dateTime) as DateTime;
                      picked=dateTime;
                      formattedDate =DateFormat('hh:mm a').format(dateTime);
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
                child: Card(
                  color: const Color(0xfff303030),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      if(checks.isEmpty)...[
                        ListTile(
                          leading: Text("tomorow-"+DateFormat('EE, d MMM').format(date).toString(),
                            style: TextStyle(fontSize: 20,color: Colors.white),),
                          trailing:Icon(Icons.date_range,color: Colors.white,),
                        ),
                      ]
                      else if(checks.isNotEmpty && checks.length <=6)...[
                        ListTile(
                          leading: Text("Every $pri",
                            style: TextStyle(fontSize: 20,color: Colors.white),),
                          trailing:Icon(Icons.date_range,color: Colors.white,),
                        ),
                      ]
                      else if(checks.isNotEmpty && checks.length==7)...[
                          ListTile(
                            leading: Text("Every day",
                              style: TextStyle(fontSize: 20,color: Colors.white),),
                            trailing:Icon(Icons.date_range,color: Colors.white,),
                          ),
                        ],

                      ///days
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 5,),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor:Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("M",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedm = value;
                                  check();
                                });
                              },
                              value: Checkedm,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("M",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),

                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("T",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedt = value;
                                  check();
                                });
                              },
                              value: Checkedt,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("T",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("W",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedw = value;
                                  check();
                                });
                              },
                              value: Checkedw,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("W",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("T",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedth = value;
                                  check();
                                });
                              },
                              value: Checkedth,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("T",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("F",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedf = value;
                                  check();
                                });
                              },
                              value: Checkedf,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("F",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),
                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("S",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkeds = value;
                                  check();
                                });
                              },
                              value: Checkeds,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("S",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            GFCheckbox(
                              size: 30,
                              type: GFCheckboxType.circle,
                              activeBgColor: Color(0xfff303030),

                              activeBorderColor: Color(0xff8587fe),
                              activeIcon:const Center(
                                  widthFactor: 20,
                                  child: Text("S",style: TextStyle(fontSize: 18,color: Color(0xff8587fe)),)),
                              onChanged: (value) {
                                setState(() {
                                  Checkedsu = value;
                                  check();
                                });
                              },
                              value: Checkedsu,
                              inactiveIcon: const Center(
                                widthFactor: 20,
                                child: Text("S",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              inactiveBorderColor: Color(0xfff303030),
                              inactiveBgColor: Color(0xfff303030),
                            ),
                            SizedBox(width: 5,),

                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: Alarm_name,
                          style:TextStyle(color: Colors.white,fontSize: 20.0),
                          cursorColor: Color(0xff8587fe),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText:'Alarm name',
                            hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                          ),
                          // decoration: const InputDecoration(
                          //   border: UnderlineInputBorder(),
                          //   hintText:'Alarm name',
                          //   hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                          // ),
                        ),
                      ),
                      Container(
                        child: Card(
                          color: Color(0xfff303030),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Alarm sound", style: TextStyle(fontSize: 20,color: Colors.white),),
                                subtitle: Text(textalarmsound,style: TextStyle(fontSize: 15,color: Color(0xff8587fe)),),
                                trailing:Transform.scale(
                                    scale: 1.3,
                                    child: Switch(
                                      onChanged: soundSwitch,
                                      value: alarmsound,
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
                      Container(
                        child: Card(
                          color: Color(0xfff303030),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Vibration", style: TextStyle(fontSize: 20,color: Colors.white),),
                                subtitle: Text(textvibration,style: TextStyle(fontSize: 15,color: Color(0xff8587fe)),),
                                trailing:Transform.scale(
                                    scale: 1.3,
                                    child: Switch(
                                      onChanged: vibrationSwitch,
                                      value: vibration,
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
                      Container(
                        child: Card(
                          color: Color(0xfff303030),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Snooze", style: TextStyle(fontSize: 20,color: Colors.white),),
                                subtitle: Text(textsnooze,style: TextStyle(fontSize: 15,color: Color(0xff8587fe)),),
                                trailing:Transform.scale(
                                    scale: 1.3,
                                    child: Switch(
                                      onChanged: snoozeSwitch,
                                      value: snooze,
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
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
}
