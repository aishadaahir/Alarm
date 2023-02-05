import 'package:database/Alarm.dart';
import 'package:database/extended.dart';
import 'package:database/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    Alarm(),
    Icon(
      Icons.timer,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.redAccent,
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
        backgroundColor: const Color(0xff010101),
        fixedColor: Colors.white,
        unselectedItemColor: Color(0xff010101),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text("Alarm",style: TextStyle(color: Colors.white60,fontSize: 17),),
            label: '-----------',
          ),
          BottomNavigationBarItem(
            icon: Text("clock",style: TextStyle(color: Colors.white60,fontSize: 17),),
            label: '-------------------',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
          body: Center(
            child: _pages.elementAt(_selectedIndex), //New
          ),

    );
  }
}
