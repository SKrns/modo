import 'package:flutter/material.dart';
import 'package:modo/ui/editor_page.dart';
import 'package:provider/provider.dart';
import 'update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modo/models/series.dart';
import 'package:modo/models/works.dart';

//final List<String> entries = <String>['1화 코로나 2020.04.01', 'B', 'C'];
//final List<int> colorCodes = <int>[600, 500, 100];

Widget _buildSeriesBody(BuildContext context,String id ) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('works').document(id).collection('series').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
      return _buildSeriesList(context, snapshot.data.documents,id);
    },
  );
}

Widget _buildSeriesList(BuildContext context, List<DocumentSnapshot> snapshot, String documentId) {
  if(snapshot.isEmpty) {
    return Center(child: Text('+ 를 눌러 작품을 추가해주세요.'),);
  }
  return ListView(
    children: snapshot.map((data) => _buildSeriesListCard(context, data, documentId)).toList(),
  );
}

Widget _buildSeriesListCard(BuildContext context, DocumentSnapshot data, String documentId) {
  final Series record = Series.fromSnapshot(data);
  print(record.id+"");
  return Container(
    padding: EdgeInsets.all(4.0),
    child: InkWell(
      onTap: (){

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditorPage(
            documentId: documentId,
            documentdocumentID:record.id,
            userId:"?",
            src:record.src,

        ))
        );

      },
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(6.0)),
          Text(record.title + " " +record.date.toDate().toString()),
          Divider(),
        ],
      ),
    ),
  );

}

class AddSeriesPage extends StatefulWidget {
  AddSeriesPage({Key key, this.documentId, this.userId, this.record})
      : super(key: key);

  final String documentId;
  final String userId;
  final Works record;

  @override
  _AddSeriesPageState createState() => _AddSeriesPageState();
}

class _AddSeriesPageState extends State<AddSeriesPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.record.title),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditorPage(
                      documentId:widget.documentId,
                      userId:widget.userId,
                      src:""

                  )),
                );
              },
            ),
          )
        ],
      ),
      body: _buildSeriesBody(context, widget.documentId),
    );

  }
}
