import 'package:flutter/material.dart';
import 'package:kamp_us/home_page.dart';

class MyRegisterPage extends StatefulWidget {
  MyRegisterPage({Key key, this.title}) : super(key: key);

  final String title;
  _MyRegisterPage createState() => _MyRegisterPage();
}

class _MyRegisterPage extends State<MyRegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void cleanField() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void alertDialogPopUp(String string) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(string),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Idź do głównego ekranu'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>MyHomePage(title: 'KampUS')));

                },
              )
            ],
          );

        }
    );
  }

  Widget build (BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),

      body: Container (
        padding: EdgeInsets.only(top: 35.0, left: 20.0, right:20.0),
        child: Column(
          children: <Widget>[
            TextField(
                controller: _emailController,
                decoration:InputDecoration(
                  labelText: 'EMAIL',

                )
            ),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:InputDecoration(
                  labelText: 'HASŁO',
                )
            ),
            SizedBox(height: 30.0),
            Container (
              height: 40.0,
              alignment: Alignment.centerRight,
              child: Material(
                borderRadius: BorderRadius.horizontal(),
                color: Color.fromARGB(255, 139, 0, 2),
                elevation: 10.0,
                child: GestureDetector(
                    onTap: () {
                      //Kod do sprawdzania czy udało się zalogować
                      //_emailController.text == ''
                      alertDialogPopUp('Dziękujemy za rejestrację, link do aktywacji został wysłany na podany adres email');

                    },
                    child: Center(
                      child: Text('Zarejestruj',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                ),

              ),
            ),

          ],

        ),

      ),
    );
  }
}