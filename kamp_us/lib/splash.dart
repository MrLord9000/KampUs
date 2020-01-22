import 'dart:async';
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
    Timer(Duration(seconds: 3), () => Navigator.push(_context, MaterialPageRoute(builder: (_context) => MyHomePage(title: "KampUs",))));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor),),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment(-0.8, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow> [
                              BoxShadow(
                                offset: Offset(3.0, 3.0),
                                blurRadius: 5.0,
                                color: Theme.of(context).primaryColorDark
                                )
                              ]
                            ),
                          child: Image.asset("images/logo_PL.png", fit: BoxFit.fitHeight, height: 192)
                          )
                        ),
                      Padding(padding: EdgeInsets.only(top: 10)),

                      Container(
                        child: Divider(
                          color: Theme.of(context).accentColor,
                          indent: 20,
                          endIndent: 20,
                          thickness: 2,
                          ),
                        ),
                      
                    ],
                  ),
                )
              ),

              Expanded(
                child: Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    alignment: Alignment(-0.5, -3.2),
                    child: Text(
                    "Kamp", 
                    style: TextStyle(fontSize: 78, color: Theme.of(context).accentColor)
                  )),
                  
                  Container(
                    alignment: Alignment(0.5, 1.0),
                    child: Text(
                    "US",
                    style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)
                  ))
                ],
              )),

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