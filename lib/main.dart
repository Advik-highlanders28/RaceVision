import 'package:flutter/material.dart';
import 'features/race/race_screen.dart';

void main() {
  runApp(const RaceVisionApp());
}

class RaceVisionApp extends StatelessWidget {
  const RaceVisionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaceVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: RaceScreen(),
    );
  }
}
