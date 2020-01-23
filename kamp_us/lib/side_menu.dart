import 'package:flutter/material.dart';

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

  void openPageUlubione(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ulubione'),
          ),
          body: const Center(
            child: Text(
              'Tutaj beda ulubione lokacje',
              style: TextStyle(fontSize: 24),
            ),
          ),
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
              child: Text('KampUs'),
              decoration: BoxDecoration(
                color: Colors.red,
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
              title: Text('Ulubione'),
              onTap: () {
                openPageUlubione(context);
              },
            ),

          ],
        ),
      );
  }
}