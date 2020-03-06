import 'package:dodo_musique/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const MaterialColor matBlack = const MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: const Color.fromRGBO(0, 0, 0, 1.0),
    100: const Color.fromRGBO(0, 0, 0, 1.0),
    200: const Color.fromRGBO(0, 0, 0, 1.0),
    300: const Color.fromRGBO(0, 0, 0, 1.0),
    400: const Color.fromRGBO(0, 0, 0, 1.0),
    500: const Color.fromRGBO(0, 0, 0, 1.0),
    600: const Color.fromRGBO(0, 0, 0, 1.0),
    700: const Color.fromRGBO(0, 0, 0, 1.0),
    800: const Color.fromRGBO(0, 0, 0, 1.0),
    900: const Color.fromRGBO(0, 0, 0, 1.0),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dodo Musique',
      theme: ThemeData(
        primarySwatch: matBlack
      ),
      home: MyHomePage(title: 'Dodo Musique'),
    );
  }
}