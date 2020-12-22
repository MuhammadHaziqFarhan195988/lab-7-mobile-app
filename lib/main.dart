import 'package:camera_app/blocs/theme.dart';
import 'package:camera_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera_app/screen/wrapper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
@override
class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
      theme: theme.getTheme(),
    );
  }
}
