import 'package:flutter/material.dart';
import 'update_page.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  List _pages = [
    UpdatePage(),
    Text('구독작품'),
    Text('준비 중 입니다.'),
    Text('My'),
  ];
  @override
  Widget build(BuildContext context) {
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
