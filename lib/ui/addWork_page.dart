import 'package:flutter/material.dart';

class AddWorkPage extends StatefulWidget {
  @override
  _AddWorkPageState createState() => _AddWorkPageState();
}
final wantGenreList = ['영화', '웹툰', '애니메이션'];
final wantTypeList = ["ALL", "판타지", "로멘스", "일상", "개그", "스포츠", "게임", "공포"];
final drawList = ['기괴', "따스한"];

// Todo : Expended
class _AddWorkPageState extends State<AddWorkPage> {
  String _wantGenreValue;
  Widget _wantGenre(List list) {
    return Row(
      children: list.map((data){
        return ChoiceChip(
          label: Text(data),
          selected: _wantGenreValue == data,
          onSelected: (bool selected) {
            setState(() {
              _wantGenreValue = selected ? data : null;
            });
        } ,);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO : 제목, 지향장르(웹툰, 영화..), 연재장르(코미디,액션..), 그림체, 희망하는 작가
      appBar: AppBar(
        title: Text('시리즈 추가'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(icon: Icon(Icons.save), onPressed: () => {}),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
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
          ),
          _wantGenre(wantTypeList),
        ],
      ),

    );
  }
}
