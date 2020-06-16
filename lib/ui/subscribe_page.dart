import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:modo/widgets/subscribe.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modo/models/works.dart';


String userId;
//bool _isEdit = false;
Widget body;

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






class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  bool _isEdit = false;
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
    return Column(
      children: subScribeList.map((data) => _buildSubscribeListCard(context, data)
      ).toList(),
//    onReorder: _onReorder,
    );
  }

  void change(String workId,String userId ) async{
    await removeSubscribe(workId, userId, context);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {body = _buildSubscribeBody(context); });
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
                      _isEdit ? null : Navigator.pushNamed(context, '/detail',arguments: record);
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
                            ),
                            _isEdit?  Expanded(child: Container(alignment:Alignment.centerRight,child: FlatButton.icon(onPressed:() {

                              change(workId,userId);
                            }, icon: Icon(Icons.clear), label: Text('')))) : Container()
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

  @override
  Widget build(BuildContext context) {

    userId = Provider.of<String>(context);
    body = _buildSubscribeBody(context);
    return MultiProvider(
      providers: [
        Provider<String>.value(value: userId),
      ],
      child: Scaffold(
        appBar: AppBar(
          title : Text('구독 작품'),
          actions: <Widget>[
            MaterialButton(onPressed: () {
              setState(() { _isEdit = _isEdit? false : true; });
            }, child: _isEdit?Text('편집 완료'):Text('편집'),),
          ],
          backgroundColor: Colors.white,),
        body: body,
      ),
    );
  }
}

