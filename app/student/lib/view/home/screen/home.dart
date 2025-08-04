import 'package:flutter/material.dart';
import 'package:student/view/common/appbar_home.dart';
import 'package:student/view/common/drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawerr(),
      appBar: AppbarHome(),

      body: Center(
        child: Text('Home Screen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
