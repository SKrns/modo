import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modo/models/works.dart';


String userId;


void addSubscribe(String id) async{
  List mySubscribe;
  Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
    mySubscribe =document['mySubscribe']??[];
    if(!mySubscribe.contains(id)) {
      mySubscribe.add(id);
    }
  }).then((e){
    Firestore.instance.collection('users').document(userId).updateData(
        {'mySubscribe': mySubscribe});
  });

}

Widget _buildSubscribeBody(BuildContext context) {
  return StreamBuilder(
    stream: Firestore.instance.collection('users').document(userId).get().asStream(),
    builder: (context, stream) {
      if (!stream.hasData) return LinearProgressIndicator();
      DocumentSnapshot item = stream.data;
      List subScribeList = item["mySubscribe"];
      return _buildSubscribeList(context, subScribeList);
    },
  );
}

void _onReorder(int oldIndex, int newIndex) {
//    setState(() {
//      if (newIndex > oldIndex) {
//        newIndex -= 1;
//      }
//      final TaskModel item = taskList.removeAt(oldIndex);
//      taskList.insert(newIndex, item);
//    });
}

Widget _buildSubscribeList(BuildContext context, List subScribeList) {
  return ReorderableListView(
    children: subScribeList.map((data) => _buildSubscribeListCard(context, data)
    ).toList(),
    onReorder: _onReorder,
  );
}

Widget _buildSubscribeListCard(BuildContext context,String workId){
  return StreamBuilder(
    key: Key(workId),
    stream: Firestore.instance.collection('works').document(workId).get().asStream(),
    builder: (context, stream){
      if (!stream.hasData) return Column();
      DocumentSnapshot s = stream.data;
      final record = Works.fromSnapshot(s);
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Card(
                key: ValueKey(record.title),
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/detail',arguments: record);
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

            ),

          ],
        ),
      );
    },
  );

}


class SubscribeEditPage extends StatefulWidget {
  @override
  _SubscribeEditPageState createState() => _SubscribeEditPageState();
}

class _SubscribeEditPageState extends State<SubscribeEditPage> {

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<String>(context);
    return MultiProvider(
      providers: [
        Provider<int>.value(value: 10),
      ],
      child: Scaffold(
        appBar: AppBar(
          title : Text('구독 작품'),
          actions: <Widget>[
            MaterialButton(onPressed: () => Navigator.pushNamed(context, '/subedit'), child: Text('편집'),)
          ],
          backgroundColor: Colors.white,),
        body: _buildSubscribeBody(context),
      ),
    );
  }
}

