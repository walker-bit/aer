import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/screens/detailScreen.dart';

enum MobileVerificationState{
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FROM_STATE,
}
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth =FirebaseAuth.instance;
  String verificationId;
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
    PhoneAuthCredential phoneAuthCredential) async {
      setState(() {
        showLoading = true;
      });
      try {
        final authCredential =await _auth.signInWithCredential(phoneAuthCredential);
        setState(() {
          showLoading = false;
        });
        if(authCredential?.user != null){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Detailscreen()));
        }
      }on FirebaseAuthException catch (e) {
        print(e.message);
        setState(() {
          showLoading = false;
        });
      }
    }

    getMobileForWidget(context){
      return Column(
        children: [
          Spacer(),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              hintText: "Phone Number",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          FlatButton(
            onPressed: () async{
              setState(() {
                showLoading = true;
              });
              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text, 
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                } ,
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                }, 
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FROM_STATE;
                    this.verificationId = verificationId;
                  });
                }, 
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("SEND"),
            color: Colors.blue,
            textColor: Colors.white,
          ),
          Spacer(),
        ],
      );
 }
 getOtpFormWidget(context) {
   return Column(
     children: [
       Spacer(),
       TextField(
         controller: otpController,
         decoration: InputDecoration(
           hintText: "Enter Otp",
         ),
       ),
       SizedBox(height: 16,),
       FlatButton(
        onPressed: () async {
          PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpController.text);
          signInWithPhoneAuthCredential(phoneAuthCredential);
        }, 
        child: Text("VERIFY"),
        color: Colors.blue,
        textColor: Colors.white,
      ),
      Spacer(),
     ],
   );
 }
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: showLoading?
        Center(
          child: CircularProgressIndicator(),
        ):
        currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE ?
         getMobileForWidget(context):
         getOtpFormWidget(context),
        padding: const EdgeInsets.all(16),
      )
    );
  }

  
}