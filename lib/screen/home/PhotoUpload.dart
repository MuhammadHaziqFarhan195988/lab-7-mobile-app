import 'package:camera_app/screen/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {

  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();
  String _locationMessage;

  void _getCurrentLocation() async {

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage="${position.latitude}, ${position.longitude}";
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: Text("Select image location"),
          content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[

                  GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      }

                  ),
                  Padding(padding: EdgeInsets.all(8.0),),
                  GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      }
                  )
                ],
              )
          )
      );
    });
  }

  _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);

    this.setState(() {
      if (pickedFile != null) {
        sampleImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    this.setState(() {
      if (pickedFile != null) {
        sampleImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.camera);

    this.setState(() {
      if (tempImage != null) {
        sampleImage = File(tempImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
}

void uploadStatusImage () async{
    if(validateAndSave()){
      final Reference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();
      _getCurrentLocation();
      final UploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      var Imageurl = await (await uploadTask).ref.getDownloadURL();

      url = Imageurl.toString();

      print("Image Url = " + url);

      goToHomePage();

      saveToDatabase(url);
    }
  }

void saveToDatabase(url) async {
  var dbtimeKey = new DateTime.now();
  var formatDate = new DateFormat('MMM d,yyyy');
  var formatTime = new DateFormat('EEEE, hh:mm aaa');
  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  String locationCoordinate = "${position.latitude}, ${position.longitude}";

  String date = formatDate.format(dbtimeKey);
  String time = formatTime.format(dbtimeKey);

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data = {
    "image": url,
    "description": _myValue,
    "date":date,
    "time": time,
    "location": locationCoordinate
  };

  ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(context, MaterialPageRoute(builder: (context)
    {
      return new LandingScreen();
    })
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(
        title: new Text("Upload Image"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null? Text("Submit an image"): enableUpload(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_showChoiceDialog(context),
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),



    );
  }



Widget enableUpload(){
return Container(

  child: Form(
    key: formKey,
    child: Column(
      children: <Widget>[
        Image.file(sampleImage,height: 330.0,width: 660.0,),

        SizedBox(height: 15.0,)

        ,TextFormField(
          decoration: InputDecoration(labelText: 'Description'),

          validator: (value){
            return value.isEmpty ? 'Description required' : null;
          },

          onSaved: (value){
            return _myValue=value;
          },
        ),

        SizedBox(height: 15.0,),
        RaisedButton(
          elevation: 10.0,
          child: Text("upload image"),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: uploadStatusImage,
        )

      ],

    ),),

);
}


}
