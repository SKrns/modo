import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:modo/ui/auth_page.dart';
import 'package:modo/ui/tab_page.dart';
import 'package:modo/ui/updateDetail_page.dart';
import 'package:modo/ui/update_page.dart';
import 'package:modo/ui/editor_page.dart';

final routes = {
  '/': (BuildContext context) => TabPage(),
  '/detail': (BuildContext context) => DetailPage(),
  '/edit': (BuildContext context) => EditorPage(),
};