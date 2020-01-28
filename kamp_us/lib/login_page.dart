import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kamp_us/home_page.dart';
import 'package:kamp_us/models.dart';
import 'package:kamp_us/regiser_page.dart';
import 'package:kamp_us/api.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;
  _MyLoginPage createState() => _MyLoginPage();
}

class _MyLoginPage extends State<MyLoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loginButtonActive = false;
  bool registerButtonActive = false;

  void wrongLoginData(String string) {
    showDialog(context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        content: new Text(string),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );

      }
    );
  }
  
  void forgotPassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Zamoniałeś hasła'),
          ),
          body: Container (
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right:20.0),
            child: Column (
              children: <Widget>[
                TextField(
                    controller: _emailController,
                    decoration:InputDecoration(
                      labelText: 'EMAIL',

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
                    child: InkWell(
                        onTap: () {
                          //Kod do sprawdzania czy udało się zalogować
                          wrongLoginData("Dziękujemy za zgłoszenie, instrukcje będą wysłane na adres email");

                        },
                        child: Center(
                          child: Text('Wyślij na ten adres email',
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
            )
          )
        );
      },
    ));
  }


  void cleanField() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Color registerColor = Color.fromARGB(255, 27, 28, 32);
  Color loginColor = Color.fromARGB(255, 139, 0, 2);

  Widget build (BuildContext context) {
    return Scaffold (
      resizeToAvoidBottomInset: false,
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
            SizedBox(height: 5.0),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 15.0, left: 20.0),
              child: Material(
                child: GestureDetector(
                  onTap: () {
                    forgotPassword(context);
                  },
                    child: Text('ZAPOMNIAŁES HASŁA?',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline,
                      ),

                    )
                ),

              )

            ),
            SizedBox(height: 30.0),
            Container (
              height: 40.0,
              alignment: Alignment.center,
                child: Material(
                    borderRadius: BorderRadius.horizontal(),
                    color: loginColor,
                    elevation: 10.0,
                    child: InkWell(
                        onTap: () {

                          var account = AccountModel(
                            email: _emailController.text,
                            passwd: _passwordController.text,
                          );
                          API.logIn(
                              account,
                                  () => Navigator.push(context, MaterialPageRoute(builder: (context) =>MyHomePage(title: 'KampUS'))),
                              wrongLoginData
                          );
                        },
                        child: Center(
                          child: Text('Zaloguj',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        )
                    ),

                )

              ),
            SizedBox(height: 20.0),
            Container(
              height: 30.0,
              child: Material(
                borderRadius: BorderRadius.horizontal(),
                color: registerColor,
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    //Kod
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>MyRegisterPage(title: 'KampUS')));
                  },
                    child: Center(
                      child: Text('Zarejestruj',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                )

              )
            )
          ],

        ),

      ),
    );
  }
}
