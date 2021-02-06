import 'package:camera_app/screen/authenticate/fingerprint.dart';
import 'package:camera_app/screen/authenticate/sign_in.dart';
import 'package:camera_app/screen/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class AuthService{

  //sign in anon
 handleAuth()  {
   return StreamBuilder(
   stream: FirebaseAuth.instance.authStateChanges(),
   builder: (BuildContext context, snapshot) {
     if (snapshot.hasData) {
       print("hello");
       return LandingScreen();
     }
     else {
       return Fingerprint();
     }
   });
}


//sign in PIN
signInPIN(AuthCredential authCreds){
   FirebaseAuth.instance.signInWithCredential(authCreds);
}
//register

//sign out
signOutPIN(){
   FirebaseAuth.instance.signOut();
}
}