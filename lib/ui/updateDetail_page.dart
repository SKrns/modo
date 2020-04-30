import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> entries = <String>['1화 코로나 2020.04.01', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

Widget _buildWorksBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('works').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildWorksList(context, snapshot.data.documents);
    },
  );
}

Widget _buildWorksList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return Column(
    children: snapshot.map((data) => _buildWorksListCard(context, data)).toList(),
  );
}

Widget _buildWorksListCard(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  print(record.id);
  return Row(
    children: <Widget>[
      Expanded(
        child: Card(
          key: ValueKey(record.title),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: record);
            },
            child: Column(

              children: <Widget>[
                Row(

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                        Text(record.series,
                          style: TextStyle(color: Colors.black54),),
                      ],
                    )
                  ],
                ),
                Divider(),
                Text(record.tag, style: TextStyle(color: Colors.black54),),
                Padding(padding: EdgeInsets.all(1.5)),
              ],
            ),
          ),

        ),

      ),

    ],
  );
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    final record = ModalRoute.of(context).settings.arguments;
    print(record);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 192.0,
                elevation: 0.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.green,
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
                                  child: Image.network('http://image.yes24.com/Goods/89826582/L')
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('제목 : ' + 'title'),
                                Padding(padding: EdgeInsets.all(4.0)),
                                Text('작가 : ' + 'writer'),
                                Padding(padding: EdgeInsets.all(4.0)),
                                Text('series',style: TextStyle(color: Colors.black54),),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Text('tag',style: TextStyle(color: Colors.black54),),
                        Padding(padding: EdgeInsets.all(1.5)),
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
          body: ListView.separated(itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                     Padding(padding: EdgeInsets.all(8.0)),
                      Text('${entries[index]}',style: TextStyle(fontSize: 20.0),),
                    ],
                  ),
                ],
              ),
            );
          }, itemCount: entries.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),)
      ),
    );

  }
}
