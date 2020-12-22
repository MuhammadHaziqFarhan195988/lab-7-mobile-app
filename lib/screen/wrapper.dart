import 'package:camera_app/model/user.dart';
import 'package:camera_app/screen/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:camera_app/screen/home/homepage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userWrapper = Provider.of<TheUser>(context);
    print(userWrapper);


   //return either home or authenticate widget
    if(userWrapper == null){
      return Authenticate();
    }
    else {
      return LandingScreen();
    }
  }
}
