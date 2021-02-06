import 'package:camera_app/screen/authenticate/fingerprint.dart';
import 'package:camera_app/screen/home/homepage.dart';
import 'package:camera_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override

  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
final formKey = new GlobalKey<FormState>();
  final AuthService _auth = AuthService();

String phoneNo,verificationID;
  @override
  void initState() {
    super.initState();

    _SignInState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Log in using phone number'),
        actions: <Widget>[

        ],
      ),
     body: Form(
      key: formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(hintText: 'Enter phone number'),
          onChanged: (val) {
            setState(() {
              this.phoneNo = val;
            });
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 25.0,right: 25.0),
        child: RaisedButton(
          child: Center(child: Text('Login'),),
          onPressed: (){
            verifyPhone(phoneNo);
          },
        ),
      ),
    ],
  ),
),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult){
AuthService().signInPIN(authResult);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException  authException){
    print('${authException.message}');
    };

    final PhoneCodeSent smsSent= (String id,[int forceResend]){
      this.verificationID = id;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String id){
      this.verificationID = id;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
