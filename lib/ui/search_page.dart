import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modo/models/works.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> {
  String _searchQuery = "";

  Widget _buildSearchBody(BuildContext context) {
    Stream<QuerySnapshot> query;

    query =  Firestore.instance.collection('works').where('title',isGreaterThanOrEqualTo: _searchQuery ).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildSearchList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildSearchList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: snapshot.map((data) => _buildSearchListCard(context, data)).toList(),
    );
  }

  Widget _buildSearchListCard(BuildContext context, DocumentSnapshot data) {
    final record = Works.fromSnapshot(data);
    if(record.title.indexOf(_searchQuery) == -1) {
      return Column();
    }
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/detail',arguments: record);
      },
      child: Column(
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              Expanded(flex: 5, child: Text(record.title,style: TextStyle(fontSize: 15.0),)),
              Expanded(flex: 5, child: Text(record.tag)),
            ],
          ),
          Divider()
        ],
      ),
    );

  }


  void doSearch(String value) {
    print(value);
    setState(() {
      _searchQuery = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onSubmitted: (value) => doSearch(value),
          decoration: InputDecoration(
            hintText: "검색",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSearchBody(context),
        ),
      ),
    );
  }
}
