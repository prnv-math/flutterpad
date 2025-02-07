import 'package:flutter/material.dart';
import 'package:flutterpad/services/databaseservice.dart';
import 'package:flutterpad/services/userdataprovider.dart';
import 'package:flutterpad/utils/dictionary.dart';
import 'package:provider/provider.dart';

import 'UI/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseService.instance.initDB();
  runApp(const TagPadApp());
}

class TagPadApp extends StatelessWidget {
  const TagPadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (context) => UserDataProvider(),
        )
      ],
      child: MaterialApp(
        title: 'TagPad',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.highContrastLight(
            background: ColorDict.noteCardColor,
          ),
          // colorScheme: ColorScheme.fromSeed(seedColor: ColorDict.bgColor),
          useMaterial3: true,
        ),
        home: Home(),
      ),
    );
  }
}
