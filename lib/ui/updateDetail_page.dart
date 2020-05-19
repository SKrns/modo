import 'package:flutter/material.dart';
import 'package:modo/ui/viewer_page.dart';
import 'package:provider/provider.dart';
import 'update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modo/models/series.dart';
import 'package:modo/models/works.dart';

//final List<String> entries = <String>['1화 코로나 2020.04.01', 'B', 'C'];
//final List<int> colorCodes = <int>[600, 500, 100];

Widget _buildSeriesBody(BuildContext context,Works record) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('works').document(record.id).collection('series').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
      return _buildSeriesList(context, snapshot.data.documents);
    },
  );
}

Widget _buildSeriesList(BuildContext context, List<DocumentSnapshot> snapshot) {
  if(snapshot.isEmpty) {
    return Center(child: Text('아직 작품이 없어요 ㅠ'),);
  }
  return ListView(
    children: snapshot.map((data) => _buildSeriesListCard(context, data)).toList(),
  );
}

Widget _buildSeriesListCard(BuildContext context, DocumentSnapshot data) {
  final Series record = Series.fromSnapshot(data);
  print(record.id);
  return Container(
    padding: EdgeInsets.all(8.0),
    height: 50,
    child: InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewerPage(
            record: record
          )),
        );
      },
      child: Column(
        children: <Widget>[
          Text(record.title + " " +record.date.toDate().toString()),
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
                    builder: (context) => IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => addSubscribe(record.id),
                    ),
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
