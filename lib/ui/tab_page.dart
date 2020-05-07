import 'package:flutter/material.dart';
import 'update_page.dart';
import 'subscribe_page.dart';
import 'my_page.dart';
import 'package:modo/services/authentication.dart';

class TabPage extends StatefulWidget {
  TabPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

//    final Map<String,Object> arguments = ModalRoute.of(context).settings.arguments as Map;
//    auth = arguments['auth'];
//    logoutCallback = arguments['logoutCallback'];
//    userId = arguments['userId'];

    List _pages = [
      UpdatePage(),
      Text('hi'),
      Text('준비 중 입니다.'),
      MyPage(userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,),
    ];
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
//        fixedColor: Colors.white,
//        backgroundColor: Colors.orange,
//        unselectedItemColor: Colors.black,
          onTap: _onItemTaped,
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('업데이트')),
            BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('구독작품')),
            BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('메신저')),
            BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('My')),
          ]),
    );
  }

  void _onItemTaped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
