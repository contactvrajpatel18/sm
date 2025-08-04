import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/view/authentication/screen/mobile_number.dart';
import 'package:student/view/delet/01populate_data.dart';
import 'package:student/view/profile/screen/profile.dart';

class Drawerr extends StatelessWidget {
  const Drawerr({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.all(30),
                child: Image.asset('assets/logo.png', width: 100, height: 100),
              ),

              ListTile(leading: Icon(Icons.home), title: Text('Home'),
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>PopulateDataPage(),
                    ),
                  );
                },),

              ListTile(leading: Icon(Icons.person), title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },),

              // ListTile(leading: Icon(Icons.event), title: Text('Attendance'),
              //   onTap: () {
              //
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AttendenceScreen(),
              //       ),
              //     );
              //   },),


              ListTile(leading: Icon(Icons.phone), title: Text('Contact Us')),
              if (FirebaseAuth.instance.currentUser != null)
                ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text('Logout'),
                  onTap: () async {

                    // final studentProfileProvider = Provider.of<StudentDataProvider>(context, listen: false);
                    // studentProfileProvider.clearData();

                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text('Logged out successfully')),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>MobileNumber()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
