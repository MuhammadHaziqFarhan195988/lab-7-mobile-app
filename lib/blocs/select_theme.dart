import 'package:flutter/material.dart';
import 'package:camera_app/blocs/theme.dart';
import 'package:provider/provider.dart';

class selectTheme extends StatefulWidget {
  @override
  _selectThemeState createState() => _selectThemeState();
}

class _selectThemeState extends State<selectTheme> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Theme"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                color: Colors.lightBlueAccent,
                child: IconButton(
                icon: new Icon(Icons.nightlight_round),
                iconSize: 50,
                color: Colors.white,
                onPressed:() => themeChanger.setTheme(ThemeData.dark()) ,
              ),
              ),
              Container(
                color: Colors.amberAccent,
                child: IconButton(
                  icon: new Icon(Icons.wb_sunny),
                  iconSize: 50,

                  color: Colors.white,
                  onPressed:() => themeChanger.setTheme(ThemeData.light()) ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
