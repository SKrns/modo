import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modo/assets.dart';
import 'package:provider/provider.dart';
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool formVisible;
  int _formsIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formVisible = false;
    _formsIndex = 1;
  }
  @override
  Widget build(BuildContext context) {
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
                            Navigator.pushReplacementNamed(context, '/home');
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
}

