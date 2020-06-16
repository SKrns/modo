import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:modo/ui/auth_page.dart';
import 'package:modo/ui/search_page.dart';
import 'package:modo/ui/subscribeEdit_page.dart';
import 'package:modo/ui/tab_page.dart';
import 'package:modo/ui/test.dart';
import 'package:modo/ui/updateDetail_page.dart';
import 'package:modo/ui/update_page.dart';
import 'package:modo/ui/editor_page.dart';
import 'package:modo/ui/login_page.dart';
import 'package:modo/ui/addWork_page.dart';

import 'package:modo/services/authentication.dart';

final routes = {
  '/': (BuildContext context) => AuthPage(auth: new Auth()),
  '/login': (BuildContext context) => LoginPage(),
  '/tab': (BuildContext context) => TabPage(),
  '/detail': (BuildContext context) => DetailPage(),
  '/edit': (BuildContext context) => EditorPage(),
  '/addwork': (BuildContext context) => AddWorkPage(),
  '/search':(BuildContext context) => SearchPage(),
  '/subedit':(BuildContext context) => SubscribeEditPage(),

  '/test':(BuildContext context) => TodoListView(),
};