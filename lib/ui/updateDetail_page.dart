import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modo/ui/viewer_page.dart';
import 'package:provider/provider.dart';
import 'update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modo/models/series.dart';
import 'dart:core';
import 'package:modo/models/works.dart';

//final List<String> entries = <String>['1화 코로나 2020.04.01', 'B', 'C'];
//final List<int> colorCodes = <int>[600, 500, 100];

Widget _buildSeriesBody(BuildContext context,Works record) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('works').document(record.id).collection('series').orderBy('date',descending: false).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
      return _buildSeriesList(context, snapshot.data.documents, record);
    },
  );
}
int _c = 0;

Widget _buildSeriesList(BuildContext context, List<DocumentSnapshot> snapshot, Works works) {
  if(snapshot.isEmpty) {
    return Center(child: Text('아직 작품이 없어요 ㅠ'),);
  }
  _c=0;
  return ListView(
    children: snapshot.map((data) => _buildSeriesListCard(context, data, works)).toList(),
  );
}

void updateViewCount2(String documentId, String documentdocumentID) async {
  int view;
  Firestore.instance.collection('works').document(documentId).collection('series').document(documentdocumentID).get().then((DocumentSnapshot document){
    view =document['view']??0;
    view+=1;
  }).then((e){
    Firestore.instance.collection('works').document(documentId).collection('series').document(documentdocumentID).updateData(
        {'view': view});
  });
}

Widget _buildSeriesListCard(BuildContext context, DocumentSnapshot data, Works works) {

  final Series record = Series.fromSnapshot(data,cnt: ++_c);
  print(record.id);
  return Container(
    padding: EdgeInsets.all(8.0),
//    height: 70,
    child: InkWell(
      onTap: (){
//        updateViewCount(record.documentId, );
        updateViewCount2(works.id, record.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewerPage(
            record: record
          )),
        );
      },
      child: Column(
        children: <Widget>[
          Row(
        children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0)),
              Expanded(child: Text(record.cnt.toString()+"화"), flex: 1,),
              Expanded(child: Text(record.title),flex: 7,),
              Expanded(child: Text(new DateFormat("yy-MM-dd").format(record.date.toDate()).toString()),flex: 2,),
            ],
          ),
//          Text( +" " + record.title + " " +record.date.toDate().toString()),
          Divider(),
        ],
      ),
    ),
  );
//    ListView.separated(itemBuilder: (BuildContext context, int index) {
//    return Container(
//      height: 50,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Padding(padding: EdgeInsets.all(8.0)),
//              Text('${entries[index]}',style: TextStyle(fontSize: 20.0),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }, itemCount: entries.length,
//    separatorBuilder: (BuildContext context, int index) => const Divider(),
//  );
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {



  void updateViewCount(String documentId, String documentdocumentID) async {
    try {
      final collRef = Firestore.instance.collection('works').document(documentId).collection('series');
      DocumentReference docRef = collRef.document(documentdocumentID);
      docRef.updateData(
          { 'view': 0,
          }
      );
    } catch(e) {
      print('Error sendAddSeriesData $e');
    }
  }
  

  void addSubscribe(String id) async{
    List mySubscribe;
    Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
      mySubscribe =document['mySubscribe']??[];
      mySubscribe.add(id);
    }).then((e){
      Firestore.instance.collection('users').document(userId).updateData(
          {'mySubscribe': mySubscribe});
    });

  }

  @override
  Widget build(BuildContext context) {
    final Works record = ModalRoute.of(context).settings.arguments;
    print(record.id);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 192.0,
                elevation: 0.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.orange,
                actions: <Widget>[
                  Builder(
                    builder: (context) => MaterialButton(
                        onPressed: () => addSubscribe(record.id),
                        child: Text('구독'),
                    ),


//                        IconButton(
//                      icon: Icon(Icons.add),
//                      onPressed: () => addSubscribe(record.id),
//                    ),
                  )
                ],

                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 70.0
                    ),
                    child: Column(

                      children: <Widget>[
                        Row(

                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                  width: 80.0,
                                  height: 80.0,
                                  child: Image.network(record.image)
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('제목 : ' + record.title),
                                Padding(padding: EdgeInsets.all(4.0)),
                                Text('작가 : ' + record.writer),
                                Padding(padding: EdgeInsets.all(4.0)),
                                Text(record.series,style: TextStyle(color: Colors.black54),),
                                Padding(padding: EdgeInsets.all(6.0)),
                                Text(record.story,style: TextStyle(color: Colors.black54),),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Text(record.tag,style: TextStyle(color: Colors.black54),),
                        Padding(padding: EdgeInsets.all(1.5)),
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
          body: _buildSeriesBody(context, record),
      ),
    );

  }
}
