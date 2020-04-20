import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';


class ITHomePage extends StatefulWidget {
  final Widget child;

  ITHomePage({Key key, this.child}) : super(key: key);

  _ITHomePageState createState() => _ITHomePageState();
}
class _ITHomePageState extends State<ITHomePage> {

  List<charts.Series<CETBranchwise, String>> _seriesITData;
  List<charts.Series<CETBranchwise, String>> _seriesITPieData;
  List<CETBranchwise> myITData;
  _generateData(myITData){
    _seriesITData= List<charts.Series<CETBranchwise,String>>();
    _seriesITData.add(
        charts.Series(
          domainFn: (CETBranchwise cetBranchwise,_) => cetBranchwise.task.toString(),
          measureFn: (CETBranchwise cetBranchwise,_) => cetBranchwise.value,
          colorFn:(CETBranchwise cetBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(cetBranchwise.colorval))) ,
          id: 'placements',
          data: myITData,
          labelAccessorFn: (CETBranchwise row,_)=>'${row.value}',
        )
    );
    _seriesITPieData = List<charts.Series<CETBranchwise, String>>();
    _seriesITPieData.add(
      charts.Series(
          domainFn: (CETBranchwise cetBranchwise,_) => cetBranchwise.task,
          measureFn: (CETBranchwise cetBranchwise,_) => cetBranchwise.value,
          colorFn:(CETBranchwise cetBranchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(cetBranchwise.colorval))) ,
          id: 'placements pie',
          data: myITData,
          labelAccessorFn: (CETBranchwise row, _) => '${row.value}${'\n'}${row.task}'
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
              title: Text('CMR IT',
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
                _buildCETBody(context),
                _piebuildCETBody(context),
              ],
            ),
          ),
        ),
      );
  }


  Widget _buildCETBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('CETBranchwise').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<CETBranchwise> cetBranchwise=snapshot.data.documents
              .map((documentSnapshot) => CETBranchwise.fromMap(documentSnapshot.data))
              .toList();
          print("reyyyyy");
          debugPrint(snapshot.data.documents.toString());
          debugPrint("areyyyy");
          //Firestore.instance.collection("cetBranchwise").document('CMRTC').updateData({'cetBranchwisevalue':250});
          /* CollectionReference reference = Firestore.instance.collection('cetBranchwise');
          reference.snapshots().listen((querySnapshot) {
            querySnapshot.documentChanges.forEach((change) {
              print("22");
            });
          });*/
          return _buildCETChart(context, cetBranchwise);
        }

      },
    );

  }
  Widget _buildCETChart(BuildContext context, List<CETBranchwise> cetBranchwise)
  {
    myITData=cetBranchwise;
    _generateData(myITData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'CMR IT Placements',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height:10.0,),
              Expanded(
                child: charts.BarChart(
                  _seriesITData,
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
  Widget _piebuildCETBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('CETBranchwise').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<CETBranchwise> cetbranchwise = snapshot.data.documents
              .map((documentSnapshot) => CETBranchwise.fromMap(documentSnapshot.data))
              .toList();
          return _piebuildCETChart(context, cetbranchwise);
        }
      },
    );
  }
  Widget _piebuildCETChart(BuildContext context, List<CETBranchwise> cetbranchwise) {
    myITData=cetbranchwise;
    _generateData(myITData);
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
                child: charts.PieChart(_seriesITPieData,
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