import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_example_by_mladen/screens/start_screen.dart';

void main() {
  runApp(const FlutterExampleByMladen());
}

class FlutterExampleByMladen extends StatelessWidget {
  const FlutterExampleByMladen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'FlutterExampleByMladen',
      theme: ThemeData(),
      home: const StartScreen(),
    );
  }
}
