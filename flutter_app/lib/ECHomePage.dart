import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';


class ECHomePage extends StatefulWidget {
  final Widget child;

  ECHomePage({Key key, this.child}) : super(key: key);

  _ECHomePageState createState() => _ECHomePageState();
}
class _ECHomePageState extends State<ECHomePage> {

  List<charts.Series<ECBranchwise, String>> _seriesECData;
  List<charts.Series<ECBranchwise, String>> _seriesECPieData;
  List<ECBranchwise> myECData;
  _generateData(myECData){
    _seriesECData= List<charts.Series<ECBranchwise,String>>();
    _seriesECData.add(
        charts.Series(
          domainFn: (ECBranchwise ecBranchwise,_) => ecBranchwise.task.toString(),
          measureFn: (ECBranchwise ecBranchwise,_) => ecBranchwise.value,
          colorFn:(ECBranchwise ecBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(ecBranchwise.colorval))) ,
          id: 'placements',
          data: myECData,
          labelAccessorFn: (ECBranchwise row,_)=>'${row.value}',
        )
    );
    _seriesECPieData = List<charts.Series<ECBranchwise, String>>();
    _seriesECPieData.add(
      charts.Series(
          domainFn: (ECBranchwise ecBranchwise,_) => ecBranchwise.task,
          measureFn: (ECBranchwise ecBranchwise,_) => ecBranchwise.value,
          colorFn:(ECBranchwise ecBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(ecBranchwise.colorval))) ,
          id: 'placements pie',
          data: myECData,
          labelAccessorFn: (ECBranchwise row, _) => '${row.value}${'\n'}${row.task}'
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
              title: Text('CMR EC',
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
                _buildECBody(context),
                _piebuildECBody(context),
              ],
            ),
          ),
        ),
      );
  }


  Widget _buildECBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ECBranchwise').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<ECBranchwise> ecBranchwise=snapshot.data.documents
              .map((documentSnapshot) => ECBranchwise.fromMap(documentSnapshot.data))
              .toList();
          print("reyyyyy");
          debugPrint(snapshot.data.documents.toString());
          debugPrint("areyyyy");
          //Firestore.instance.collection("ecBranchwise").document('CMREC').updateData({'ecBranchwisevalue':250});
          /* CollectionReference reference = Firestore.instance.collection('ecBranchwise');
          reference.snapshots().listen((querySnapshot) {
            querySnapshot.documentChanges.forEach((change) {
              print("22");
            });
          });*/
          return _buildECChart(context, ecBranchwise);
        }

      },
    );

  }
  Widget _buildECChart(BuildContext context, List<ECBranchwise> ecBranchwise)
  {
    myECData=ecBranchwise;
    _generateData(myECData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'CMR EC Placements',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height:10.0,),
              Expanded(
                child: charts.BarChart(
                  _seriesECData,
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
  Widget _piebuildECBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ECBranchwise').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ECBranchwise> ecbranchwise = snapshot.data.documents
              .map((documentSnapshot) => ECBranchwise.fromMap(documentSnapshot.data))
              .toList();
          return _piebuildECChart(context, ecbranchwise);
        }
      },
    );
  }
  Widget _piebuildECChart(BuildContext context, List<ECBranchwise> ecbranchwise) {
    myECData=ecbranchwise;
    _generateData(myECData);
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
                child: charts.PieChart(_seriesECPieData,
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