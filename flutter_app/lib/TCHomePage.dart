import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';


class TCHomePage extends StatefulWidget {
  final Widget child;

  TCHomePage({Key key, this.child}) : super(key: key);

  _TCHomePageState createState() => _TCHomePageState();
}
class _TCHomePageState extends State<TCHomePage> {

  List<charts.Series<TCBranchwise, String>> _seriesTCData;
  List<charts.Series<TCBranchwise, String>> _seriesTCPieData;
  List<TCBranchwise> myTCData;
  _generateData(myTCData){
    _seriesTCData= List<charts.Series<TCBranchwise,String>>();
    _seriesTCData.add(
        charts.Series(
          domainFn: (TCBranchwise tcBranchwise,_) => tcBranchwise.task.toString(),
          measureFn: (TCBranchwise tcBranchwise,_) => tcBranchwise.value,
          colorFn:(TCBranchwise tcBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(tcBranchwise.colorval))) ,
          id: 'placements',
          data: myTCData,
          labelAccessorFn: (TCBranchwise row,_)=>'${row.value}',
        )
    );
    _seriesTCPieData = List<charts.Series<TCBranchwise, String>>();
    _seriesTCPieData.add(
      charts.Series(
          domainFn: (TCBranchwise tcBranchwise,_) => tcBranchwise.task,
          measureFn: (TCBranchwise tcBranchwise,_) => tcBranchwise.value,
          colorFn:(TCBranchwise tcBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(tcBranchwise.colorval))) ,
          id: 'placements pie',
          data: myTCData,
          labelAccessorFn: (TCBranchwise row, _) => '${row.value}${'\n'}${row.task}'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(debugShowCheckedModeBanner: false,theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.black,
      ),
        home:DefaultTabController(
          length: 2,
          child:
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: TabBar(
                indicatorColor: Color(0xff9962D0),
                tabs: [
                  Tab(
                    icon: Icon(FontAwesomeIcons.solidChartBar),
                  ),
                  Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                  //  Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                ],
              ),
              title: Text('CMR TC',
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),

            body: TabBarView(
              children: [
                _buildTCBody(context),
                _piebuildTCBody(context),
              ],
            ),
          ),
        ),
      );
  }


  Widget _buildTCBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('TCBranchwise').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<TCBranchwise> tcBranchwise=snapshot.data.documents
              .map((documentSnapshot) => TCBranchwise.fromMap(documentSnapshot.data))
              .toList();
          print("reyyyyy");
          debugPrint(snapshot.data.documents.toString());
          debugPrint("areyyyy");
          //Firestore.instance.collection("tcBranchwise").document('CMRTC').updateData({'tcBranchwisevalue':250});
          /* CollectionReference reference = Firestore.instance.collection('tcBranchwise');
          reference.snapshots().listen((querySnapshot) {
            querySnapshot.documentChanges.forEach((change) {
              print("22");
            });
          });*/
          return _buildTCChart(context, tcBranchwise);
        }

      },
    );

  }
  Widget _buildTCChart(BuildContext context, List<TCBranchwise> tcBranchwise)
  {
    myTCData=tcBranchwise;
    _generateData(myTCData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'CMR TC Placements',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height:10.0,),
              Expanded(
                child: charts.BarChart(
                  _seriesTCData,
                  animate: true,
                  animationDuration: Duration(seconds: 3),
                  defaultInteractions: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _piebuildTCBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('TCBranchwise').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<TCBranchwise> tcbranchwise = snapshot.data.documents
              .map((documentSnapshot) => TCBranchwise.fromMap(documentSnapshot.data))
              .toList();
          return _piebuildTCChart(context, tcbranchwise);
        }
      },
    );
  }
  Widget _piebuildTCChart(BuildContext context, List<TCBranchwise> tcbranchwise) {
    myTCData=tcbranchwise;
    _generateData(myTCData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Placements Summary',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesTCPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 3),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                        new EdgeInsets.only(right: 4.0, bottom: 4.0, top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}