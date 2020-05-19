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

Widget _buildWorksBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('works').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return StreamBuilder(
        stream: Firestore.instance.collection('users').document(userId).get().asStream(),
        builder: (context, s) {
          if (!s.hasData) return LinearProgressIndicator();
          DocumentSnapshot item = s.data;

          List subScribeList = item["mySubscribe"];

          return _buildWorksList(context, snapshot.data.documents,subScribeList);
        },
      );


    },
  );
}

Widget _buildWorksList(BuildContext context, List<DocumentSnapshot> snapshot, List subScribeList) {

  return Column(
    children: snapshot.map((data) => _buildWorksListCard(context, data, subScribeList)).toList(),
  );
}

Widget _buildSlidable(String userId, String recordId) {
  //Todo: 구독 해제 & 구독 추가
}

Widget _buildWorksListCard(BuildContext context, DocumentSnapshot data, List subScribeList) {
  final record = Works.fromSnapshot(data);
  print(subScribeList);

  if(!subScribeList.contains(record.id)) {
    return Row();
  }
  
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: '구독',
        color: Colors.orange,
        icon: Icons.add,
        onTap: () => addSubscribe(record.id),
      ),
    ],
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

  return Padding(
    key: ValueKey(record.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      child: ListTile(
        title: Text(record.title),
        onTap: () => print(record),
      ),
    ),
  );
}




class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {

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
            MaterialButton(onPressed: null, child: Text('편집'),)
          ],
          backgroundColor: Colors.white,),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(),
              _buildWorksBody(context),
            ],
          ),
        ),
      ),
    );
  }
}

