import 'package:flutter/material.dart';
import 'package:kamp_us/home_page.dart';
import 'package:kamp_us/regiser_page.dart';


class MyLoggingPage extends StatefulWidget {
  MyLoggingPage({Key key, this.title}) : super(key: key);

  final String title;
  _MyLoggingPage createState() => _MyLoggingPage();
}



class _MyLoggingPage extends State<MyLoggingPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  void cleanField() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              decoration:InputDecoration(
                labelText: 'PASSWORD',
              )
            ),
            SizedBox(height: 5.0),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 15.0, left: 20.0),
              child: InkWell(
                child: Text('Forgot Password',
                style: TextStyle(
                  color: Colors.deepOrange,
                  decoration: TextDecoration.underline,
                  ),

                )
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
                    if (_emailController.text == 'email' && _passwordController.text == 'haslo')
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>MyHomePage(title: 'KampUS')));
                    else if(_emailController.text != 'email') {
                      wrongLoginData('No such email, try again');
                    }
                    else if (_passwordController != 'haslo') {
                      wrongLoginData('Wrong password, try again');
                    }
                    else {
                      wrongLoginData('You missed it, uh oh');
                    }

                  },
                  child: Center(
                    child: Text('Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                        ),
                      ),
                    )
                  ),

                ),
              ),
            SizedBox(height: 20.0),
            Container(
              height: 30.0,
              child: Material(
                borderRadius: BorderRadius.horizontal(),
                color: Color.fromARGB(255, 27, 28, 32),
                elevation: 10.0,
                child: GestureDetector(
                  onTap: () {
                    //Kod
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>MyRegisterPage(title: 'KampUS')));
                  },
                    child: Center(
                      child: Text('Register',
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