import 'package:database/login.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();
  bool isLoading=false;
  String message="";
  register()async{
    try{
      isLoading=true;
      setState(() {});
      var response=await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print("SUCCESS");
      message="go to back to login";

    }catch(e){
      log(e.toString());
      message=e.toString();
    }
    isLoading=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => user()));
            },
          ),
          title: Text("register"),

        ),
        body:SafeArea(
          child: Column(
            children: [

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child:TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "username",
                      hintText: "enter your email"),
                  style:TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child:TextField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "password",
                      hintText: "enter your password"),
                  style:TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent// background
                  ),
                  onPressed: () => register(),
                  child: isLoading?CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ) :Text("register",style: TextStyle(fontSize: 25),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Text(message,style: TextStyle(fontSize: 20,color: Colors.red),),
              ),
            ],
          ),
        )

    );
  }
}
