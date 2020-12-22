import 'package:camera_app/screen/authenticate/sign_in.dart';
import 'package:camera_app/screen/home/homepage.dart';
import 'package:camera_app/screen/home/imageGallery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class Fingerprint extends StatelessWidget {
  final Function toggleView;
  Fingerprint({this.toggleView});

  final LocalAuthentication localAuth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Login using fingerprint'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.fingerprint),
            label: Text('Phone sign in'),
            onPressed: (){
              Navigator.pop(context);},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () async{
       bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;
       
       if(weCanCheckBiometrics){
          bool authenticated = await localAuth.authenticateWithBiometrics(
              localizedReason: "Authenticate to use photo app");
          if(authenticated){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen())
            );}
       }


        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.fingerprint,
              size: 124.0,
            ),
            Text(
              "Touch to Login",
              style: GoogleFonts.passionOne(
                fontSize: 64.0
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
