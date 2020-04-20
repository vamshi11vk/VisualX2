import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';


class CETHomePage extends StatefulWidget {
  final Widget child;

  CETHomePage({Key key, this.child}) : super(key: key);

  _CETHomePageState createState() => _CETHomePageState();
}
class _CETHomePageState extends State<CETHomePage> {

  List<charts.Series<Branchwise, String>> _seriesCETData;
  List<charts.Series<Branchwise, String>> _seriesCETPieData;
  List<Branchwise> myCETData;
  _generateData(myCETData){
    _seriesCETData= List<charts.Series<Branchwise,String>>();
    _seriesCETData.add(
        charts.Series(
          domainFn: (Branchwise branchwise,_) => branchwise.task.toString(),
          measureFn: (Branchwise branchwise,_) => branchwise.value,
          colorFn:(Branchwise branchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(branchwise.colorval))) ,
          id: 'placements',
          data: myCETData,
          labelAccessorFn: (Branchwise row,_)=>'${row.value}',
        )
    );
    _seriesCETPieData = List<charts.Series<Branchwise, String>>();
    _seriesCETPieData.add(
      charts.Series(
          domainFn: (Branchwise branchwise,_) => branchwise.task,
          measureFn: (Branchwise branchwise,_) => branchwise.value,
          colorFn:(Branchwise branchwise,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(branchwise.colorval))) ,
          id: 'placements pie',
          data: myCETData,
          labelAccessorFn: (Branchwise row, _) => '${row.value}${'\n'}${row.task}'
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
              title: Text('CMR CET',
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
      stream: Firestore.instance.collection('branchwise').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<Branchwise> branchwise=snapshot.data.documents
              .map((documentSnapshot) => Branchwise.fromMap(documentSnapshot.data))
              .toList();
          print("reyyyyy");
          debugPrint(snapshot.data.documents.toString());
          debugPrint("areyyyy");
          //Firestore.instance.collection("branchwise").document('CMRTC').updateData({'branchwisevalue':250});
          /* CollectionReference reference = Firestore.instance.collection('branchwise');
          reference.snapshots().listen((querySnapshot) {
            querySnapshot.documentChanges.forEach((change) {
              print("22");
            });
          });*/
          return _buildCETChart(context, branchwise);
        }

      },
    );

  }
  Widget _buildCETChart(BuildContext context, List<Branchwise> branchwise)
  {
    myCETData=branchwise;
    _generateData(myCETData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'CMR CET Placements',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height:10.0,),
              Expanded(
                child: charts.BarChart(
                  _seriesCETData,
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
      stream: Firestore.instance.collection('branchwise').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Branchwise> branchwise = snapshot.data.documents
              .map((documentSnapshot) => Branchwise.fromMap(documentSnapshot.data))
              .toList();
          return _piebuildCETChart(context, branchwise);
        }
      },
    );
  }
  Widget _piebuildCETChart(BuildContext context, List<Branchwise> branchwise) {
    myCETData=branchwise;
    _generateData(myCETData);
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
                child: charts.PieChart(_seriesCETPieData,
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