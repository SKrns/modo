import 'package:flutter/material.dart';
import 'package:modo/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        Provider<int>.value(value: 50),
      ],
      child: MaterialApp(
        title: 'MoDo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.orange,
          accentColor: Colors.orangeAccent,
        ),
        initialRoute: '/',
        routes: routes,
//          home: new AuthPage(auth: new Auth())
      ),
    );
  }
}