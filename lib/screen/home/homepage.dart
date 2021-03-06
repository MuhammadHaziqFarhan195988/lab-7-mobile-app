import 'package:camera_app/blocs/select_theme.dart';
import 'package:camera_app/screen/home/PhotoUpload.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera_app/services/Posts.dart';
import 'package:firebase_database/firebase_database.dart';


import 'multi_picker.dart';


class LandingScreen extends StatefulWidget{

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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
          FlatButton.icon(
             icon:  Icon(Icons.person),
            label: Text("Exit"),
          onPressed: () => exit(0),
    ),

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

        child:
       postsList.length == 0? new Text("No images in this app") : new ListView.builder(
            itemCount: postsList.length+1,
            itemBuilder: (_, index)
              {

                return index == 0? _searchBar(): PostsUI(postsList[index-1].image,postsList[index-1].description,postsList[index-1].date,postsList[index-1].time,postsList[index-1].location);

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
                icon: Icon(Icons.photo),
                iconSize: 50,
                color: Colors.white,

                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return MultiPicker();
                      }
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _searchBar(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...'
        ),
        onChanged: (text){
          text = text.toLowerCase();
          setState(() {
            postsList = postsList.where((Posts){
              var PostDesc = Posts.description.toLowerCase();
              return PostDesc.contains(text);
            }).toList();
          });
        },
      ),
    );
  }


  Widget PostsUI(String image, String description,String date, String time,String location){
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
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  "($location)",
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),

              ],
            ),
            SizedBox(height: 10.0,),

            new Image.network(image, fit:BoxFit.cover),

            SizedBox(height: 10.0,),

            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],

        ),

      ),

    );


  }
}

