import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'package:flutter_app/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';


class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => new _UserHomePageState();
  final Function onContents;
  UserHomePage(this.onContents);
 // List<String>contents=widget.onContents();
}
class _UserHomePageState extends State<UserHomePage> {
  //List<charts.Series<User, String>> _userData;
  List<charts.Series<User, String>> _seriesData;
  //String _fileName;
  static String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
 // List<String> contents;

  static FileType _pickingType=FileType.custom;
  _generateData() {
    List<String> contentslist=widget.onContents();
    List<User> contentslist1=contentslist.cast();
    List<charts.Series<User, String>> _seriesData;
    print("hey");
    var data1 = [
      new User(contentslist1.cast()[0], int.parse(contentslist1.cast()[1])),
      new User(contentslist1.cast()[2], int.parse(contentslist1.cast()[3])),
      new User(contentslist1.cast()[4], int.parse(contentslist1.cast()[5])),
      new User(contentslist1.cast()[6], int.parse(contentslist1.cast()[7])),
    ];
   // return [
    _seriesData.add(
      charts.Series(
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (User sales, _) => sales.xaxis,
        measureFn: (User sales, _) => sales.yaxis,
        data: data1,
      ),
      );
    //];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<User, String>>();
    _generateData();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
          appBar: AppBar(
          backgroundColor: Color(0xff1976d2),
      //backgroundColor: Color(0xff308e1c),
      bottom: TabBar(
        indicatorColor: Color(0xff9962D0),
        tabs: [
          Tab(
            icon: Icon(FontAwesomeIcons.solidChartBar),
          ),
        ],
      ),
      title: Text('Flutter Charts'),
    ),
    body: TabBarView(
    children: [
    Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
    child: Center(
    child: Column(
    children: <Widget>[
    Text(
    'User statistics',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
    Expanded(
    child: charts.BarChart(
    _seriesData,
    animate: true,
    barGroupingType: charts.BarGroupingType.grouped,
    //behaviors: [new charts.SeriesLegend()],
    animationDuration: Duration(seconds: 5),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
        ],
    ),
    ),
    ),
    );
}



}