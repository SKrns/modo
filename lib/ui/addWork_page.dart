import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class AddWorkPage extends StatefulWidget {
  AddWorkPage({Key key, this.userID})
      : super(key: key);
//  AddWorkPage({this.userID});

  final String userID;

  @override
  _AddWorkPageState createState() => _AddWorkPageState();
}
final wantGenreList = ['영화', '웹툰', '애니메이션'];
//final wantTypeList = ["판타지", "로멘스", "일상", "개그", "스포츠", "게임", "공포"];
final wantTypeList = ["판타지", "로멘스", "일상", "개그", "스포츠", "공포"];

final wantDrawList = ['기괴', "따스한"];

// Todo : Expended
class _AddWorkPageState extends State<AddWorkPage> {
  File _image;
  final _formKey = new GlobalKey<FormState>();

  String generateTag(List value) {
      String output = "";
      value.forEach((i) =>output+="#"+i+" " );
      return output;
  }

  void sendAddWorkData(String userId) async {
    try {
      print(_title);
      final collRef = Firestore.instance.collection('works');
      DocumentReference docRef = collRef.document();

      docRef.setData(
          { 'genre': _wantGenreValue,
            'type': _wantTypeValue ,
            'draw': _wantDrawValue,
            'want':_wantWriter,
            'title':_title,
            'user' : userId,
            'writer':'test',
            'tag':generateTag([_wantGenreValue,_wantTypeValue,_wantDrawValue]),
            'series':'아직 없어요 ㅠㅠ'
          }
          );

//      Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
//        myWork = List.from(document['myWork']??[]);
//        myWork.add(docRef.documentID);
//      });
//
//      Firestore.instance.collection('users').document(userId).updateData(
//          {'myWork': myWork});


      List myWork;
      Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
        myWork =document['myWork']??[];
        myWork.add(docRef.documentID);
      }).then((e){
        Firestore.instance.collection('users').document(userId).updateData(
            {'myWork': myWork});

      }).then((e){
        Navigator.pop(context);
      });



    } catch(e) {
      print('Error sendAddwork $e');
    }
  }

  void addWorkSummit(String userId) async{
    final form = _formKey.currentState;
      setState(() {

      });
      if(form.validate() && validateChip()) {
          sendAddWorkData(userId);
      }
  }

  bool validateChip() {
    final String message = "항목을 선택해주세요.";

    print("asdasdsa");
    _wantGenreMessage = _wantTypeMessage = _wantTypeMessage = "";
    if (_wantGenreValue == null || _wantTypeValue == null || _wantDrawValue == null) {

        setState(() {
          if(_wantGenreValue == null) {
            _wantGenreMessage = message;
          }
          if(_wantTypeValue == null) {
            _wantTypeMessage = message;
          }
          if(_wantDrawValue == null) {
            _wantDrawMessage = message;
          }
        });
        return false;
    }
    return true;
  }

  String _wantGenreValue;
  String _wantGenreMessage = "";
  Widget _wantGenre(List list) {
    return Row(
      children: list.map((data){
        return ChoiceChip(
          label: Text(data),
          selected: _wantGenreValue == data,
          onSelected: (bool selected) {
            setState(() {
              if(selected) {
                _wantGenreValue = data;
              }
            });
        } ,);
      }).toList(),
    );
  }

  String _wantTypeValue;
  String _wantTypeMessage = "";
  Widget _wantType(List list) {
    return Row(
      children: list.map((data){
        return ChoiceChip(
          label: Text(data),
          selected: _wantTypeValue == data,
          onSelected: (bool selected) {
            setState(() {
              _wantTypeValue = selected ? data : null;
            });
          } ,);
      }).toList(),
    );
  }

  String _wantDrawValue;
  String _wantDrawMessage = "";
  Widget _wantDraw(List list) {
    return Row(
      children: list.map((data){
        return ChoiceChip(
          label: Text(data),
          selected: _wantDrawValue == data,
          onSelected: (bool selected) {
            setState(() {
              _wantDrawValue = selected ? data : null;
            });
          } ,);
      }).toList(),
    );
  }

  void _uploadImageToStorage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    if (image == null) return;
    setState(() {
      _image = image;
    });
  }


  String _title;
  String _wantWriter;

  @override
  Widget build(BuildContext context) {
//    final String userId = Provider.of<String>(context);
    print(widget.userID);
    return Scaffold(
      //TODO : 제목, 지향장르(웹툰, 영화..), 연재장르(코미디,액션..), 그림체, 희망하는 작가
      appBar: AppBar(
        title: Text('시리즈 추가'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(icon: Icon(Icons.save), onPressed: () => addWorkSummit(widget.userID)),
          )
        ],
      ),
      body: new Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                  (_image != null) ? FileImage(_image) : NetworkImage(""),
                  radius: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("갤러리"),
                      onPressed: () {
                        _uploadImageToStorage(ImageSource.gallery);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    RaisedButton(
                      child: Text("카메라"),
                      onPressed: () {
                        _uploadImageToStorage(ImageSource.camera);
                      },
                    )
                  ],
                )
              ],
            ),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: '시리즈 제목',
                  icon: new Icon(
                    Icons.book,
                    color: Colors.grey,
                  )),
              validator: (value) => value.isEmpty ? '제목이 비어 있습니다.' : null,
              onChanged: (value) => _title = value.trim(),
            ),
            TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: '희망 작가',
                  icon: new Icon(
                    Icons.palette,
                    color: Colors.grey,
                  )),
              validator: (value) => value.isEmpty ? ' 비어 있습니다.' : null,
              onChanged: (value) => _wantWriter = value.trim(),
            ),
            Divider(),
            _wantGenre(wantGenreList),
            Text(_wantGenreMessage),
            Divider(),
            _wantType(wantTypeList),
            Text(_wantTypeMessage),
            Divider(),
            _wantDraw(wantDrawList),
            Text(_wantDrawMessage),

          ],
        ),
      ),

    );
  }
}
