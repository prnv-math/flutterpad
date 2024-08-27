import 'package:flutter/material.dart';

import 'modules/home.dart';

void main() {
  runApp(const TagPadApp());
}

class TagPadApp extends StatelessWidget {
  const TagPadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TagPad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(title: 'TagPad : Notepad with tags'),
    );
  }
}
