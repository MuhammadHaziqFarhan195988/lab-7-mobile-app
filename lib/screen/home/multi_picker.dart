import 'dart:io';

import 'package:camera_app/blocs/select_theme.dart';
import 'package:camera_app/screen/home/PhotoUpload.dart';
import 'package:camera_app/services/Posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'homepage.dart';


class MultiPicker extends StatefulWidget {
  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> {
  File imageFile;

  List<Posts> postsList = [];


  void initState(){
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS){
        Posts posts = new Posts(
            DATA[individualKey]['image'],
            DATA[individualKey]['description'],
            DATA[individualKey]['date'],
            DATA[individualKey]['time'],
            DATA[individualKey]['location']);


        postsList.add(posts);
      }

      setState(() {
        print('Length: $postsList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Home Screen"),
        elevation: 0.0,
        actions: <Widget>[

        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children:<Widget> [
            new UserAccountsDrawerHeader(
              accountName: new Text('User'),
              accountEmail: new Text('195988@email.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
              ),

            ),
            new ListTile(
              title: new Text('Change Theme'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => selectTheme()));
              },
            )
          ],
        ),
      ),
      body: Container(
        child: postsList.length == 0? new Text("No images in this app") : new GridView.builder(
            itemCount: postsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (_, index)
            {
              return Container(
              margin: EdgeInsets.all(3),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: postsList[index].image,
              ),
              );

            }
        ),
      ),

      bottomNavigationBar: new BottomAppBar(
        color: Colors.blue,

        child: Container(
          margin: const EdgeInsets.only(left: 70.0, right: 70.0),

          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 50,
                color: Colors.white,

                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return UploadPhotoPage();
                      }
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.list),
                iconSize: 50,
                color: Colors.white,

                onPressed: () => Navigator.of(context).pop()

              )
            ],
          ),
        ),
      ),
    );
  }
  Widget PostsUI(String image){
    return Card(
      elevation: 10.0,
      margin:EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,


          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              ],
            ),
            SizedBox(height: 10.0,),

            new Image.network(image, fit:BoxFit.cover),

            SizedBox(height: 10.0,),


          ],

        ),

      ),

    );


  }
  }

