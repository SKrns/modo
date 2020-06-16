import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modo/services/authentication.dart';
import 'package:modo/ui/addSeries_page.dart';
import 'package:modo/ui/addWork_page.dart';
import 'package:modo/ui/subscribe_page.dart';
import 'package:provider/provider.dart';
import 'package:modo/models/works.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class MyPage extends StatefulWidget {
  MyPage({Key key, this.auth, this.logoutCallback,this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with ChangeNotifier {
  List<Widget> worksWidgetStack =[Container()];
  Widget myWorks;
//  @override
//  void initState() {
//    _loadMyWorks(widget.userId);
//    super.initState();
//  }


  Widget _buildSectionTitle(String name) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(name),
            ),
          ),
        ),
      ],
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }




  Widget _buildProfileBody(String userId) {

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Testing',style: TextStyle(fontSize: 20.0),),
                    Text(userId),
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: Container(
//                color: Colors.blueAccent,
                child: InkWell(
                  child: Text(
                    '로그아웃',
                  ),
                  onTap: signOut,
                ),
              ),
            ),
          ],
        )

      ],
    );

  }

  _add(BuildContext context, Works record, String documentId) async {
    final add = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSeriesPage(
        documentId: documentId,
        userId: userId,
        record: record,
      )),
    ).then((value){

    });
  }

  Widget _workWidget(String documentId) {
    return StreamBuilder(
      stream: Firestore.instance.collection('works').document(documentId).get().asStream(),
      builder: (context, s) {
        if (!s.hasData) return LinearProgressIndicator();
        DocumentSnapshot item = s.data;

        final record = Works.fromSnapshot(item);
        print(record.title);
        if (record==null) return LinearProgressIndicator();

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                _add(context,record,documentId);
              },
              child: Container(
                color: Colors.black12,
                width: 75,
                height: 100,
                child: Image.network(record.image,fit: BoxFit.cover),
              ),
            ),
            Text(record.title)
          ],
        );
      },
    );
  }

  void refreshScreen() async{
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {myWorks = _buildMyWorks(context,userId);});
  }

  Widget _emptyWorkWidget(String userId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
//                onTap: () => Navigator.pushNamed(context, '/addwork'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddWorkPage(
                  userID:userId,

              )),
            ).then((value) => refreshScreen());
          },
          child: Container(
              color: Colors.black12,
              width: 75,
              height: 100,
              child: Icon(Icons.add)
          ),
        ),
        Text('추가')
      ],
    );
  }



  Widget _loadMyWorks(String userId) {
    List<Widget> worksWidgetStack =[];

    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(userId).get().asStream(),
      builder: (context, s) {
        if (!s.hasData) return Center(child: CircularProgressIndicator());
        DocumentSnapshot item = s.data;

        List subScribeList = item["myWork"]??[];

        for(var i=0;i<3;i++) {
          if(worksWidgetStack.length>2) {
            break;
          }
          if(i<subScribeList.length) {
            worksWidgetStack.add(_workWidget(subScribeList[i]));
          } else {
            worksWidgetStack.add(_emptyWorkWidget(userId));
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: worksWidgetStack
        );


      },
    );
    
    List myWork;
    Firestore.instance.collection('users').document(userId).get().then((DocumentSnapshot document){
      myWork =document['myWork']??[];
    }).then((document){

    }).then((e){

      notifyListeners();


    });

//    return worksWidgetStack;
  }

  Widget _buildMyWorks (BuildContext context,String userId) {


    return Container(
      height: 150,
      child: _loadMyWorks(userId)
    );


  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    refreshScreen();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshScreen();
    if(mounted)
      setState(() {
      });
    _refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<String>(context);
    myWorks = _buildMyWorks(context,userId);
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Column(
            children: <Widget>[
              _buildSectionTitle('My'),
              _buildProfileBody(userId),
              Padding(padding: EdgeInsets.all(10.0)),
              _buildSectionTitle('내 작품'),
              myWorks,


            ],
          ),
        ),
      ),
    );
  }
}
