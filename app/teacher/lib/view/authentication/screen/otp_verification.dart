import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:model/utils/loader.dart';
import 'package:model/utils/snackbar.dart';
import 'package:teacher/view/home/screen/home.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  const OtpVerification({super.key, required this.verificationId});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

//! verifyOTP

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpController.text,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );

//! SnackBar
      Snackbar.showSuccess(context, 'Successfully Login');

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Snackbar.showError(context, 'Please Enter A Valid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,



//! body

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            //! MM
            width: screenWidth*0.92,
            child: Column(
              children: [
                // Animation
                //  Container(margin: EdgeInsets.all(20)),

                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Lottie.asset(
                    'assets/Animation/otp.json',
                    repeat: true,
                    height: 250,
                    width: 250,
                    animate: true,
                  ),
                ),


                //! Welcome Text

                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 35),
                    //!MM
                    width: screenWidth * 0.85,
                    child: FittedBox(
                      child: Center(
                        child: Text(
                          'Verify your identity with the OTP 🔐',
                          style: TextStyle(fontSize: 20, color: Color(0xFF6A5799)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,

                        ),
                      ),
                    ),
                  ),
                ),

                //! Mobile Number Input

                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: screenWidth ,
                  child: Center(
                    child: TextField(
                      controller: otpController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter OTP",
                      ),
                    ),
                  ),
                ),

                //! Send OTP Button

                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: screenWidth ,
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
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Loader(),
                        ),
                      ),
                    ),
                  )
                      : OutlinedButton(
                    onPressed: () {
                      if (otpController.text.length == 6) {
                        verifyOTP();
                      } else {

                        Snackbar.showError(context, 'Please Enter A Valid OTP');

                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),

                //! Image

                Container(
                  margin: EdgeInsets.only(top: 80,bottom: 40),
                  child: Image.asset(
                    'assets/from.png',
                    width: screenWidth ,
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
