import 'package:flutter/material.dart';
import 'package:modo/services/authentication.dart';



class MyPage extends StatefulWidget {
  MyPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

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




  Widget _buildProfileBody() {

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
                    Text('권순호',style: TextStyle(fontSize: 20.0),),
                    Text(widget.userId),
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

  Widget _buildMyWorks(BuildContext context) {
    return Container(
//    color: Colors.orangeAccent,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/addwork'),
                child: Container(
                    color: Colors.black12,
                    width: 75,
                    height: 100,
                    child: Icon(Icons.add)
                ),
              ),
              Text('추가')
            ],
          ),
//        Padding(padding: EdgeInsets.all(6.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  color: Colors.black12,
                  width: 75,
                  height: 100,
                  child: Icon(Icons.add)
              ),
              Text('추가')
            ],
          ),
//        Padding(padding: EdgeInsets.all(6.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  color: Colors.black12,
                  width: 75,
                  height: 100,
                  child: Icon(Icons.add)
              ),
              Text('추가')
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: <Widget>[
              _buildSectionTitle('My'),
              _buildProfileBody(),
              Padding(padding: EdgeInsets.all(10.0)),
              _buildSectionTitle('내 작품'),
              _buildMyWorks(context),
            ],
        ),
      ),
    );
  }
}
