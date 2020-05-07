// TODO : connected to userDB
// TODO : Abble

//import 'package:flutter/material.dart';
//
//class SubscribePage extends StatefulWidget {
//  @override
//  _SubscribePageState createState() => _SubscribePageState();
//}
//
//class _SubscribePageState extends State<SubscribePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//      title : const Text('구독작품'),
//      actions: <Widget>[
//        IconButton(
//            icon: const Icon(Icons.search),
//            tooltip: 'Search',
//            onPressed: null
//        )
//      ],
//      backgroundColor: Colors.white,),);
//  }
//}

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

enum DialogOptionsAction {
  cancel,
  ok
}

class SubscribePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/newpage': (BuildContext context) => new NewPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseClient _db = new DatabaseClient();
  List listCategory = [];
  List<Widget> tiles;

  List colors = [
    const Color(0xFFFFA500),
    const Color(0xFF279605),
    const Color(0xFF005959)
  ];

  createdb() async {
    await _db.create().then(
            (data){
          _db.getAllCategory().then((list){
            setState(() {
              this.listCategory = list;
            });
          });
        }
    );
  }

  @override
  void initState() {
    super.initState();
    createdb();
  }

  void showCategoryDelete<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
        .then<Null>((T value) {
      if (value != null) {
        setState(() { print(value); });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildTile(List list) {
      this.tiles = [];
      for(var dict in list) {
        this.tiles.add(
            new ItemCategory(
              key: new Key(dict), //new
              id: dict['id'],
              category: dict['name'],
              color: this.colors[dict['color']],
              onPressed: () async {
                showCategoryDelete<DialogOptionsAction>(
                    context: context,
                    child: new AlertDialog(
                        title: const Text('Delete Category'),
                        content: new Text(
                            'Do you want to delete this category?',
                            style: new TextStyle(
                              color: Colors.black26,
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            )
                        ),
                        actions: <Widget>[
                          new FlatButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(context);
                              }
                          ),
                          new FlatButton(
                              child: const Text('OK'),
                              onPressed: () {
                                _db.deleteCategory(dict['id']).then(
                                        (list) {
                                      setState(() {
                                        this.listCategory = list;
                                      });
                                    }
                                );
                                Navigator.pop(context);
                              }
                          )
                        ]
                    )
                );
              },
            )
        );
      }
      return this.tiles;
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Categories'),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.add),
                color: new Color(0xFFFFFFFF),
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/newpage').then(
                          (data){
                        _db.getAllCategory().then((list){
                          setState(() {
                            this.listCategory = list;
                          });
                        });
                      }
                  );
                }
            )
          ],
        ),
        body: new ListView(
            padding: new EdgeInsets.only(top: 8.0, right: 0.0, left: 0.0),
            children: buildTile(this.listCategory)
        )
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Page'),
      ),
    );
  }
}

//Creating Database with some data and two queries
class DatabaseClient {
  Database db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
      CREATE TABLE category (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      )""");
    await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo1', 0)");
    await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo2', 1)");
    await db.rawInsert("INSERT INTO category (name, color) VALUES ('foo3', 2)");
  }

  Future getAllCategory() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List list = await db.rawQuery('SELECT * FROM category');
    await db.close();

    return list;
  }

  Future deleteCategory(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    await db.delete('category', where: "id = ?", whereArgs: [id]);
    List list = await db.rawQuery('SELECT * FROM category');

    await db.close();

    return list;
  }
}

//Creating ListViews items
class ItemCategory extends StatefulWidget {
  ItemCategory({ Key key, this.id, this.category, this.color, this.onPressed}) : super(key: key);

  final int id;
  final String category;
  final Color color;
  final VoidCallback onPressed;

  @override
  ItemCategoryState createState() => new ItemCategoryState();
}

class ItemCategoryState extends State<ItemCategory> with TickerProviderStateMixin {
  ItemCategoryState();

  DatabaseClient db = new DatabaseClient();
  AnimationController _controller;
  Animation<double> _animation;
  double flingOpening;
  bool startFling = true;

  void initState() {
    super.initState();
    _controller = new AnimationController(duration:
    const Duration(milliseconds: 246), vsync: this);

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void _move(DragUpdateDetails details) {
    final double delta = details.primaryDelta / 304;
    _controller.value -= delta;
  }

  void _settle(DragEndDetails details) {
    if(this.startFling) {
      _controller.fling(velocity: 1.0);
      this.startFling = false;
    } else if(!this.startFling){
      _controller.fling(velocity: -1.0);
      this.startFling = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    this.flingOpening = -(48.0/_width);

    return new GestureDetector(
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      decoration: new BoxDecoration(
                        color: new Color(0xFFE57373),
                      ),
                      child: new IconButton(
                          icon: new Icon(Icons.delete),
                          color: new Color(0xFFFFFFFF),
                          onPressed: widget.onPressed
                      )
                  ),
                ],
              ),
            ),
            new SlideTransition(
                position: new Tween<Offset>(
                  begin:  Offset.zero,
                  end: new Offset(this.flingOpening, 0.0),
                ).animate(_animation),
                child: new Container(
                  decoration: new BoxDecoration(
                    border: new Border(
                      top: new BorderSide(style: BorderStyle.solid, color: Colors.black26),
                    ),
                    color: new Color(0xFFFFFFFF),
                  ),
                  margin: new EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                margin: new EdgeInsets.only(left: 16.0),
                                padding: new EdgeInsets.only(right: 40.0, top: 4.5, bottom: 4.5),
                                child: new Row(
                                  children: <Widget>[
                                    new Container(
                                      margin: new EdgeInsets.only(right: 16.0),
                                      child: new Icon(
                                        Icons.brightness_1,
                                        color: widget.color,
                                        size: 35.0,
                                      ),
                                    ),
                                    new Text(
                                      widget.category,
                                      style: new TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }
}