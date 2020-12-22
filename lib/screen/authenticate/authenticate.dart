import 'package:camera_app/screen/authenticate/fingerprint.dart';
import 'package:camera_app/screen/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showState= true;
  void toggleView(){
    setState(() => showState = !showState);
  }
  @override
  Widget build(BuildContext context) {
    if(showState){
      return SignIn(toggleView: toggleView);
    }
    else {
      return Fingerprint(toggleView: toggleView);
    }
  }
}
