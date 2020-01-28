import 'package:flutter/material.dart';

import 'api.dart';

class SideMenu extends StatelessWidget {

  void openPageUstawienia(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ustawienia'),
          ),
          body: const Center(
            child: Text(
              'Tutaj beda ustawienia',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    ));
  }

  void openPageCredits(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Twórcy'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Jakub Guzek", style: TextStyle(fontSize: 26), textAlign: TextAlign.center,),
              Text("Filip Mazurek", style: TextStyle(fontSize: 26), textAlign: TextAlign.center,),
              Text("Andrzej Miszczak", style: TextStyle(fontSize: 26), textAlign: TextAlign.center,)
            ],
          )
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('KampUs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                    )
                  ),
                  Text(API.currentUserNoPass?.nickname ?? "Not logged in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
                title: Text('Ustawienia'),
                onTap:() {
                  //tutaj otwarcie nowego okna
                  openPageUstawienia(context);
                }
            ),
            ListTile(
              title: Text('Twórcy'),
              onTap: () {
                openPageCredits(context);
              }
            ),
            ListTile(
              title: Text('Wyloguj'),
              onTap: () async {
                await API.logOut();
                print(API.currentUserNoPass?.nickname ?? "logged out");
                //TODO nie wraca
                Navigator.pop(context);
              },
            )

          ],
        ),
      );
  }
}