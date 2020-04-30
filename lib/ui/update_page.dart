import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var _cur_genre = "ALL";

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
  print(record.genre);
  if(_cur_genre!="ALL" && record.genre !=_cur_genre) {
    return Row();
  }
  return Row(
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

class Record {
  String image;
  final String title;
  final String writer;
  final String series;
  final String genre;
  final String tag;
  final String id;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['userId'] ?? 'no',
        image = map['image'] ?? 'http://image.yes24.com/goods/89729709/800x0',
        title = map['title'] ?? '',
        writer = map['writer'] ?? '',
        genre = map['genre'] ?? '',
        series = map['series'] ?? '',
        tag = map['tag'] ?? '';
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Record<$id:$image:$title:$writer:$series:$tag>";
}



class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}
List _listGenre = ["ALL", "판타지", "로멘스", "일상", "개그", "스포츠", "게임", "공포"];
class _UpdatePageState extends State<UpdatePage> {
  var _value = "ALL";

  DropdownButtonHideUnderline _appbarDropdownButton() => DropdownButtonHideUnderline(
    child: DropdownButton(
      items: _listGenre.map((value) {
        return DropdownMenuItem(
          child: Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _value = value;
          _cur_genre = value;
        });
      },
      value: _value,
    ),
  );



  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<int>.value(value: 10),
      ],
      child: Scaffold(
        appBar: AppBar(title : _appbarDropdownButton(),actions: <Widget>[], backgroundColor: Colors.white,),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildWorksBody(context),
//            _mainListView('http://image.yes24.com/Goods/89826582/L','이 시국','코로나','1화. 일본 망했다','#기괴 #부드러운 그림'),
//            _mainListView('http://image.yes24.com/goods/89729709/800x0','이정도면 거의 내 사업','흔한 말단직원','3화. 그냥 내가 먹을까','#판타지 #기묘한 느낌의 그림'),
//            _mainListView('http://image.yes24.com/Goods/89826582/L', '디자이너를 안 구했다', '나만 안다', '0화. 망했다', '#공포 #차가운 흑백 체 그림'),
//            _mainListView('http://image.yes24.com/Goods/89826582/L','이 시국','코로나','1화. 일본 망했다','#기괴 #부드러운 그림'),
//            _mainListView('http://image.yes24.com/goods/89729709/800x0','이정도면 거의 내 사업','흔한 말단직원','3화. 그냥 내가 먹을까','#판타지 #기묘한 느낌의 그림'),
//            _mainListView('http://image.yes24.com/Goods/89826582/L', '디자이너를 안 구했다', '나만 안다', '0화. 망했다', '#공포 #차가운 흑백 체 그림'),
            ],
          ),
        ),
      ),
    );
  }
}
