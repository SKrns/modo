import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modo/assets.dart';
import 'package:modo/ui/login_page.dart';
import 'package:modo/ui/tab_page.dart';
import 'package:provider/provider.dart';
import 'package:modo/services/authentication.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthPage extends StatefulWidget {

  AuthPage({this.auth});

  final BaseAuth auth;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool formVisible;
  int _formsIndex;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    super.initState();
    formVisible = false;
    _formsIndex = 1;
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget authMainPage() {
    var record = Provider.of<int>(context);
    print(record);
    return MaterialApp(
      title: 'Welcome to flutter',
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageAssets.authBackImg),
              fit: BoxFit.cover
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.black54,
            child: Column(
              children: <Widget>[
                const SizedBox(height: kToolbarHeight + 100),
                Expanded(child: Column(
                  children: <Widget>[
                    Text(
                      'MoDo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 80.0,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Text(
                      "글작가들을 위한 소통과 창조의 공간",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),),
                const SizedBox(height: 10.0),
                Row(
                    children: <Widget>[
                      const SizedBox(width: 30.0),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("로그인",style: TextStyle(fontSize: 15.0,),),
                          ),
                          onPressed: () {
//                            Navigator.pushReplacementNamed(context, '/home');
//                            Navigator.pushNamed(context, '/login',arguments: <String, Object>{});
//                              new LoginPage(
//                                auth: widget.auth,
//                                loginCallback: loginCallback,
//                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage(
                                  auth: widget.auth,
                                  loginCallback: loginCallback,
                                )),
                              );

//                          setState(() {
//                            formVisible = true;
//                            _formsIndex = 1;
//                          });
                          },
                        ),
                      ),
                      const SizedBox(width: 30.0),
                    ]
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 30.0),
                    Expanded(
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.red, width: 3.0),
                        color: Colors.red,
                        textColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("회원가입",style: TextStyle(fontSize: 15.0,),),
                        ),
                        onPressed: () {
                          setState(() {
                            formVisible = true;
                            _formsIndex = 2;
                          });
                        },

                      ),
                    ),
                    const SizedBox(width: 30.0),
                  ],
                ),
                const SizedBox(height: 100.0),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return authMainPage();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new TabPage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }


  }
}

