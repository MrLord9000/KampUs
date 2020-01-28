import 'dart:async';
import 'package:kamp_us/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreenNew extends StatefulWidget {
  @override
  _SplashScreenStateNew createState() => _SplashScreenStateNew();
}
  
class _SplashScreenStateNew extends State<SplashScreenNew> {
  
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.push(_context, MaterialPageRoute(builder: (_context) => MyLoginPage(title: 'KampUS'))));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          // ---- Background -------------------------------------
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: SafeArea(
              child: Image.asset(
              "images/Home_screen.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.fitHeight,
              filterQuality: FilterQuality.high,
              ),)
          ),

          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 5,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text("Ładowanie", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18))
              ],
            )
          )
        ],
      )
    );

  }

}