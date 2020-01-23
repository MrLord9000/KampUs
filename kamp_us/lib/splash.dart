import 'dart:async';
import 'package:kamp_us/loggin_page.dart';

import 'home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
  
class _SplashScreenState extends State<SplashScreen> {
  
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.push(_context, MaterialPageRoute(builder: (_context) => MyLoggingPage(title: 'KampUS'))));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          // ---- Background -------------------------------------
          Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor)),

          // ---- Foreground elements ----------------------------
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Expanded(
                flex: 1,
                child: Container(
                  child: Container(
                    // ---- Image asset --------------------------
                    child: Image.asset("images/logo_PL.png"),

                    // ---- Shadow decoration --------------------
                    decoration: BoxDecoration(
                    boxShadow: <BoxShadow> [
                      BoxShadow(
                        color: Theme.of(context).primaryColorDark,
                        blurRadius: 5,
                        offset: Offset(3, 3)
                        )
                      ],
                    ),

                  ),
                  alignment: Alignment(-0.75, 0),
                  ),
              ),

              Expanded(
                flex: 2,
                child: Container(
                  //decoration: BoxDecoration(color: Colors.yellow),
                  child: Column(
                    children: <Widget>[
                      
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Divider(
                        color: Theme.of(context).accentColor,
                        indent: 20,
                        endIndent: 20,
                        thickness: 2,
                        ),
                      ),

                      Expanded(
                        child: Stack(
                        children: <Widget>[ Container(
                          alignment: Alignment(-0.3, -0.5),
                          child: Text(
                            "Kamp", 
                            style: TextStyle(fontSize: 78, color: Theme.of(context).accentColor)
                            )
                          ),
                          Container(
                            alignment: Alignment(0.4, 0.2),
                            child: Text(
                            "US",
                            style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)
                            )
                          )
                        ]
                      ))

                    ],
                  )
                  ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      )
    );

  }

}