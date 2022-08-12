import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:matrix/provider/todos.dart';
import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'Todo Matrix';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: const Color(0xFFf6f5ee),
            appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
          ),
          home: const MyHomePage(),
        ));
  }
}
