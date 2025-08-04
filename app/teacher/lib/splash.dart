import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view/authentication/screen/mobile_number.dart';
import 'view/home/screen/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 5));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MobileNumber()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //! Body
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset("assets/logo.png", width: 150, height: 150),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/from.png", width: 100, height: 100),
          ),
        ],
      ),
    );
  }
}
