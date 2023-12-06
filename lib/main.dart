import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:tetsapp/screens/background.dart';
import 'package:tetsapp/screens/homepage.dart';
import 'package:tetsapp/screens/voskdemo.dart';

import 'package:vosk_flutter/vosk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BackGround(),
    );
  }
}
