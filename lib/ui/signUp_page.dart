//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:modo/assets.dart';
import 'package:modo/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {

  SignUp({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading ;
  var _email;
  var _password;
  var _phone;
  var _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  // Check if form is valid before perform login or SignUp
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or SignUp
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {

        userId = await widget.auth.signUp(_email, _password);
        //widget.auth.sendEmailVerification();
        //_showVerifyEmailSentDialog();
        print('Signed up user: $userId');

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      _isLoading = false;
    }
  }




  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showTerm(),
              showEmailInput(),
              showPasswordInput(),
              showPhoneInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showTerm() {
    return new Text(
     "약관 \n1.개인정보이용동의 \n2.서약서 불건전 만남, 혹은 주선하거나 이에 준하는 행위 적발시 1회.경고(사전문자) 2회. 과태료 천만원(법과는별개)\n\n수집할데이터\n1.이름 2.성별 3.휴대폰인증 4.아이디 5.패스워드 6.주소지"
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }
  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: new TextFormField(
              readOnly: true,
              maxLines: 1,
              autofocus: false,
              initialValue: "+821012345678",
              decoration: new InputDecoration(
                  hintText: 'Phone',
                  icon: new Icon(
                    Icons.phone,
                    color: Colors.grey,
                  )),
              validator: (value) => value.isEmpty ? 'Phone can\'t be empty' : null,
              onSaved: (value) => _phone = value.trim(),
            ),
          ),
          Expanded(flex: 2,child: showPhoneAuthButton())
        ],
      ),
    );
  }

  Widget showPhoneAuthButton() {
    return MaterialButton(child: Text('인증'), onPressed: null);
  }

//  void phoneAuth() async{
//    var firebaseAuth = FirebaseAuth.instance;
//
//    firebaseAuth.verifyPhoneNumber(
//        phoneNumber: _phone,
//        timeout: Duration(seconds: 60),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: verificationFailed,
//        codeSent: codeSent,
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//  }
//
//  final PhoneCodeSent codeSent =
//      (String verificationId, [int forceResendingToken]) async {
//    this.actualCode = verificationId;
//    setState(() {
//      print('Code sent to $phone');
//      status = "\nEnter the code sent to " + phone;
//    });
//  };

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('동의 및 회원가입',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            '로그인',
            style: new TextStyle(fontWeight: FontWeight.w300)),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }


  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }
  void toggleFormMode() {
    resetForm();
//    setState(() {
//      _isLoginForm = !_isLoginForm;
//    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Stack(
        children: <Widget>[
          _showForm(),
          showCircularProgress(),
        ],
      ),
    );
  }
}
