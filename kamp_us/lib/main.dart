import 'package:flutter/material.dart';
import 'package:kamp_us/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'KampUs',
      theme: ThemeData(

        primaryColor: Color.fromARGB(255, 139, 0, 2),
        accentColor: Color.fromARGB(255, 174, 175, 179),
        primaryColorDark: Color.fromARGB(255, 27, 28, 32),

        fontFamily: 'ZapfHumnst',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'CastleT'),
        ),

      ),
      home: SplashScreen()//MyHomePage(title: 'KampUs'),
    );
  }
}

