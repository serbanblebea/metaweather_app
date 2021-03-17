import 'package:flutter/material.dart';
import 'package:weather_app/src/presentation/loading_screen.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.grey.shade700),
      home: LoadingScreen(),
    );
  }
}
