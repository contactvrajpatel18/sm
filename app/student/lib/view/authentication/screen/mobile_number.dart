import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:model/utils/loader.dart';
import 'package:model/utils/snackbar.dart';
import 'package:student/view/authentication/screen/otp_verification.dart';

class MobileNumber extends StatefulWidget {
  const MobileNumber({super.key});

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {


  //! Mobile Number verifymobilenumber
  final TextEditingController phoneController = TextEditingController();
  String verificationId = '';
  bool isLoading = false;
  String completePhoneNumber = '';

  Future<void> verifymobilenumber() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completePhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });

        //! Snackbar
        Snackbar.showError(context, 'error');

      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          isLoading = false;
          verificationId = verId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerification(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //  double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      //! Body
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            //! MM
            width: screenWidth * 0.92,
            //  margin: EdgeInsets.only(left: 20,right: 20),
            child: Column(
              children: [

                //! Animation
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Lottie.asset(
                    'assets/Animation/welcome.json',
                    repeat: true,
                    height: 250,
                    width: 250,
                    animate: true,

                  ),
                ),

                //! Welcome Text
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    //!MM
                    width: screenWidth * 0.9,
                    child: FittedBox(
                      child: Center(
                        child: Text(
                          'Welcome ! Log in to continue. 🔐',
                          style: TextStyle(fontSize: 20, color: Color(0xFF6A5799)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,

                        ),
                      ),

                    ),


                  ),
                ),


                //! Enter Mobile Number
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: screenWidth,

                  child: IntlPhoneField(
                    controller: phoneController,
                    initialCountryCode: 'IN',
                    decoration: InputDecoration(
                      labelText: 'Enter Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (phone) {
                      completePhoneNumber = phone.completeNumber;
                    },
                    onCountryChanged: (country) {},
                  ),
                ),

                //! Send OTP Button or Loader
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: screenWidth,
                  height: 50,
                  child:
                  isLoading
                      ? Center(
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Loader(
                          ),
                        ),
                      ),
                    ),
                  )
                      : OutlinedButton(
                    onPressed: () {
                      if (phoneController.text.length == 10) {
                        verifymobilenumber();
                      } else {
                        Snackbar.showError(context, 'Please Enter A Valid 10-Digit Number');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('Send OTP', style: TextStyle(fontSize: 17)),
                  ),
                ),

                //! Image
                Container(
                  margin: EdgeInsets.only(top: 70,bottom: 40),
                  child: Image.asset(
                    'assets/from.png',
                    width: screenWidth,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
