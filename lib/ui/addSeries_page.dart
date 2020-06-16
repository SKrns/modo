import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    child: Container(
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(10, 25, 10, 25)),
          Expanded(child: Text(record.title,overflow: TextOverflow.fade,),flex: 4,),
          Expanded(child: Text(new DateFormat("yy-MM-dd").format(record.date.toDate()).toString()),flex: 2,),
          Expanded(child: Center(child: Text("조회 : "+record.view.toString(), style: TextStyle(color: Colors.black54),)),flex: 2,),
          Expanded(child: Center(child: OutlineButton(child: Text('수정'),onPressed: (){
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
          )),flex: 2,),
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
            builder: (context) => MaterialButton(
              child: Text("작품 올리기"),
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
