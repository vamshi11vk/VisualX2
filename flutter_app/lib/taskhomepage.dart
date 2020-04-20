import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app/task.dart';
import 'CETHomePage.dart';
import 'TCHomePage.dart';
import 'ITHomePage.dart';
import 'ECHomePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
//import 'package:firebase_messaging/firebase_messaging.dart';


class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  List<charts.Series<Task, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<Task> myData;
  _generateData(myData){
    _seriesData= List<charts.Series<Task,String>>();
    _seriesData.add(
        charts.Series(
          domainFn: (Task task,_) => task.task.toString(),
          measureFn: (Task task,_) => task.taskvalue,
          colorFn:(Task task,_)=>
              charts.ColorUtil.fromDartColor(Color(int.parse(task.colorval))) ,
          id: 'placements',
          data: myData,
          labelAccessorFn: (Task row,_)=>'${row.taskvalue}',
        )
    );
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData.add(
      charts.Series(
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(Color(int.parse(task.colorval))),
          id: 'placements pie',
          data: myData,
          labelAccessorFn: (Task row, _) => '${row.taskvalue}${'\n'}${row.task}'
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
              //),
              //body: _buildBody(context),
              // );
              //  );
              // }
              //backgroundColor: Color(0xff308e1c),
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
              title: Text('Saved Charts',
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
                _buildBody(context),
                _piebuildBody(context),
              ],
            ),
          ),
        ),
      );
  }


  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('task').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<Task> task=snapshot.data.documents
              .map((documentSnapshot) => Task.fromMap(documentSnapshot.data))
              .toList();
          
          //Firestore.instance.collection("task").document('CMRTC').updateData({'taskvalue':250});
          /* CollectionReference reference = Firestore.instance.collection('task');
          reference.snapshots().listen((querySnapshot) {
            querySnapshot.documentChanges.forEach((change) {
              print("22");
            });
          });*/
          return _buildChart(context, task);
        }

      },
    );

  }
  Widget _buildChart(BuildContext context, List<Task> task)
  {
    myData=task;
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Placements Summary',style: TextStyle(fontFamily: 'Comfortaa',color:Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
              SizedBox(height:10.0,),
              Expanded(
                child: charts.BarChart(
                  _seriesData,
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
  Widget _piebuildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('task').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Task> task = snapshot.data.documents
              .map((documentSnapshot) => Task.fromMap(documentSnapshot.data))
              .toList();
          return _piebuildChart(context, task);
        }
      },
    );
  }
  Widget _piebuildChart(BuildContext context, List<Task> taskdata) {
    myData=taskdata;
    _generateData(myData);
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
              Padding(
                padding: const EdgeInsets.only(left:0.0,top:20.0,right:2.0 ,bottom: 10.0),
             //   child: (
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> CETHomePage()),
                      );},

                      child: Text("CET"),
                    ),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> TCHomePage()),
                      );},
                      child: Text("TC"),
                    ),
                    FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ITHomePage()),
                      );},
                      child: Text("IT"),
                    ),
                    FloatingActionButton(
                      heroTag: "btn4",
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ECHomePage()),
                      );},
                      child: Text("EC"),
                    ),
                  ],
                ),
                  //),
                //),
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 3),
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