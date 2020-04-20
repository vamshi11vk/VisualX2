import 'taskhomepage.dart';
import 'User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:io';
import 'dart:async';
import 'package:flutter_app/task.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String _fileName;
  static String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  List<String> contents;
  static FileType _pickingType=FileType.custom;
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    //writeCounter(counter);
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      if (_multiPick) {
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      } else {
        _paths = null;
        _path = await FilePicker.getFilePath(
            type: _pickingType,
            /*allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);*/
    allowedExtensions:['txt','csv','xlsx'],
        );
   /* _FilePickerDemoState.readCounter().then((content) {
    setState(() {
    contents = content;
    print(content);
    });
    });*/
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }
  static Future<String> get _localPath async {
    return _path;
  }
  static Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path');
  }
   Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;
      print(file);
      // Read the file
     contents =file.readAsLinesSync();
      print(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
  static List<String> onContents(contents) {
    return (contents);
  }
  /*Future<File> writeCounter(contents) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(contents);
  }*/

  //String contents = "No Data";
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(debugShowCheckedModeBanner: false,theme: ThemeData(
        //debugShowCheckedModeBanner: false,
        //primarySwatch: Colors.black,
        //backgroundColor: Colors.black,
      ),
        home: Container(
            //decoration: BoxDecoration(
              //  image: DecorationImage(
                //    image: AssetImage("images/two.jpg"), fit: BoxFit.cover, colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.dstATop))),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text('Add data',
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: new Center(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new SingleChildScrollView(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                            child: new RaisedButton(
                              onPressed: (){ _openFileExplorer();

                              },
                              child: new Text("Open data source file",
                                style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ),
                          ),



                      new Builder(
                            builder: (BuildContext context) => _loadingPath
                                ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: const CircularProgressIndicator())
                                : _path != null || _paths != null
                                ? new Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: new Scrollbar(
                                  child: new ListView.separated(
                                    itemCount: _paths != null && _paths.isNotEmpty
                                        ? _paths.length
                                        : 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths.isNotEmpty;
                                      final String name = 'File : ' +
                                          (isMultiPath
                                              ? _paths.keys.toList()[index]
                                              : _fileName ?? '...');
                                      final path = isMultiPath
                                          ? _paths.values.toList()[index].toString()
                                          : _path;

                                      return
                                        new RaisedButton(
                                          child: new Text("Generate graph",
                                            style: TextStyle(
                                              fontFamily: 'Comfortaa',
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          onPressed: (){
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                builder: (context) {
                                                  return new UserHomePage(onContents);
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      //writeCounter(readCounter());
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                    new Divider(),
                                  )),
                            )
                                : new Container(),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
        ),

      );
  }
}
class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _list = ["  ↑ 3 CSE students from CMRTC got placed today in OpenText drive!!!","  ↑ 2 CSE students from CMRIT got placed today in Virtusa drive!!!", ].toList();
  Duration _duration = Duration(milliseconds: 250);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(backgroundColor: Colors.black,
        body: new Container(color: Colors.pink,
        child:
    new Container(color: Colors.black,padding: EdgeInsets.all(5), height: MediaQuery.of(context).size.height, child:
    new ListViewEffect(duration: _duration, children: _list.map((s) => _buildWidgetExample(s)).toList())
    )
    ));
  }

  Widget _buildWidgetExample(String text){
    return new Container(
      //color: Colors.yellow,
        decoration: BoxDecoration(color:Colors.white10, borderRadius: BorderRadius.all(Radius.circular(20))), height: 120, width: double.infinity, margin: EdgeInsets.all(6),
        child: new Center(child: new Text(text, style: TextStyle(color: Colors.blueGrey,fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 15)))
    );
  }
}
class ListBloc {

  static ListBloc _listBloc;

  factory ListBloc(){
    if(_listBloc == null)
      _listBloc = new ListBloc._();

    return _listBloc;
  }

  PublishSubject<int> _positionItem;

  ListBloc._(){
    _positionItem = new PublishSubject<int>();
  }

  Observable<int> get listenAnimation => _positionItem.stream;

  void startAnimation(int limit, Duration duration) async {
    for(var i = -1; i<limit; i++){
      await new Future.delayed(duration, (){
        _updatePosition(i);
      });
    }
  }

  void _updatePosition(int position){
    _positionItem.add(position);
  }

  dispose(){
    _listBloc = null;
    _positionItem.close();
  }

}
class ListViewEffect extends StatefulWidget {
  final Duration duration;
  final List<Widget> children;

  ListViewEffect({Key key, this.duration, this.children}) : super(key:key);
  _ListViewEffect createState() => new _ListViewEffect();
}

class _ListViewEffect extends State<ListViewEffect> {

  ListBloc _listBloc;

  initState(){
    _listBloc = new ListBloc();
    super.initState();
  }

  Widget build(BuildContext context) {

    _listBloc.startAnimation(widget.children.length, widget.duration);

    return new Scaffold(
        body: new Container(
          color: Colors.black,
            child:
    new Container(height: MediaQuery.of(context).size.height, child:
    new ListView.builder(scrollDirection: Axis.vertical, itemCount: widget.children.length, itemBuilder: (context, position){
      return new ItemEffect(child: widget.children[position], duration: widget.duration, position: position);
    })
    )
    ));
  }

  @override
  void dispose() {
    _listBloc.dispose();
    super.dispose();
  }
}
class ItemEffect extends StatefulWidget{
  final int position;
  final Widget child;
  final Duration duration;
  ItemEffect({this.position, this.child, this.duration});
  _ItemEffect createState() => new _ItemEffect();
}

class _ItemEffect extends State<ItemEffect> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _offsetFloat = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context){
    return new StreamBuilder(stream: new ListBloc().listenAnimation, initialData: -1, builder: (context, AsyncSnapshot<int> snapshot){
      if(snapshot.data >= widget.position && snapshot.data > -1) _controller.forward();
      return SlideTransition(position: _offsetFloat, child:
      widget.child
      );
    });
  }

}


  /*@override
  Widget build(BuildContext context) {
    return
      MaterialApp(debugShowCheckedModeBanner: false,theme: ThemeData(
        //debugShowCheckedModeBanner: false,
        //primarySwatch: Colors.black,
        //backgroundColor: Colors.black,
      ),
        home: Container(
          //decoration: BoxDecoration(
          //  image: DecorationImage(
          //    image: AssetImage("images/two.jpg"), fit: BoxFit.cover, colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.dstATop))),
            child: Scaffold(
              backgroundColor: Colors.black12,
            )
        ),
      );
  }*/
class IconsToClick extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(debugShowCheckedModeBanner: false,theme: ThemeData(
        // primarySwatch: Colors.red,
        //backgroundColor: Colors.black,
      ),
        home: Container(
          //decoration: BoxDecoration(
          //  image: DecorationImage(
          //    image: AssetImage("images/one.gif"), fit: BoxFit.cover, colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.44), BlendMode.dstATop))),
          child: Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Saved Charts',
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
             /* automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),*/
            ),
            body: Padding(
              padding: const EdgeInsets.only(left:5.0,top:20.0,right:2.0 ,bottom: 350.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage('images/cmr.jpg'),
                  minRadius: 60,
                  maxRadius: 70,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> HomePage()),
                      );
                    },
                    focusColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}