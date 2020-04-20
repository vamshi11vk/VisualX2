import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_app/nationwide.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import './widgets.dart';
import './taskhomepage.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*
class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),

                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

}*/

void main(){
  runApp(new MyApp());
}

/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {*/
class MyApp extends StatefulWidget {
@override
State<StatefulWidget> createState() {
  return FirstRoute();
}
}
class FirstRoute extends State<MyApp>{
  int _selectedTab = 0;
  final _pageOptions = [
   // FirstRoute(),
    Home(),
    IconsToClick(),
    FilePickerDemo(),
  ];
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(debugShowCheckedModeBanner: false,
        theme: ThemeData(

        // primarySwatch: Colors.red,
         //backgroundColor: Colors.black,
      ),
        home:Scaffold(
              backgroundColor: Colors.black12,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text('visualX',
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          //body:
          body:_pageOptions[_selectedTab],
          bottomNavigationBar: CurvedNavigationBar(
            //currentIndex: _selectedTab,
            height: 55,
            color: Colors.white,
            backgroundColor: Colors.black,
            buttonBackgroundColor: Colors.white,

            items: <Widget>[
              Icon(Icons.home, size: 26,color: Colors.black),
              Icon(Icons.save, size: 26,color: Colors.black),
              Icon(Icons.add_to_photos, size: 26, color: Colors.black),
            ],
            onTap: (index) {
                  setState(() {
                _selectedTab = index;
             });
            },
          ),

          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: Container(
              // color:Colors.white ,
              color:Color.fromRGBO(0, 0, 0,0.9),
              //color: Colors.n,
              child: ListView(
                // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text(''),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/bg.jpg"), fit: BoxFit.cover, colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.30), BlendMode.dstATop)
                        ),
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      trailing:Icon(Icons.save),
                      title: Text('Saved Charts',
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> IconsToClick()),
                        );
                        // Update the state of the app
                        // ...
                        // Then close the drawer

                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        //Navigator.pop(context);
                      },

                    ),
                    ListTile(
                      trailing:Icon(Icons.add_to_photos),
                      title: Text('Add new data',
                        style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> IconsToClick()),
                        );

                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        // Navigator.pop(context);
                      },
                    ),
                  ]
              ),
            ),
          ),


            ),
        //),
      );
  }
}
/*
  body: _pageOptions[_selectedTab],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedTab,
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
            items: [

               BottomNavigationBarItem(
               icon: Icon(Icons.home),
                 title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                title: Text('Saved'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_to_photos),
                title: Text('Add'),
              ),
            ],
          ),

 */

/*class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

 */
/*
class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

 */
/*@override
  Widget build(BuildContext context) {
    return
      MaterialApp(theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.black,
      ),
        home: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/two.jpg"), fit: BoxFit.cover, colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.dstATop))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('Saved',
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left:5.0,top:600.0,right: 90.0,bottom: 0.0 ),
                //child: Center(
                  child: FloatingActionButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                      backgroundColor: Colors.black45,
                    child:
                    Icon(Icons.arrow_back_ios)
                  ),
                //),
            ),
              )
        ),
      );
    }
  */

