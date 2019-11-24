import 'package:Qpon/NavBar.dart';
import 'package:Qpon/Login/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _errorMessage;
  bool _remainLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            showAlert(),
            Padding(
                padding: EdgeInsets.only(top: 32, bottom: 16),
                child: Center(
                  child: Text(
                    'QPON',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'You must enter an email.';
                      }
                      return null;
                    },
                    onSaved: (input) => _email = input.trim(),
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.length < 6) {
                        return 'Your password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: _remainLoggedIn,
                          onChanged: (bool value) {
                            setState(() {
                              _remainLoggedIn = value;
                            });
                          },
                        ),
                        Text('Remember me.'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: ButtonTheme(
                      child: RaisedButton(
                      onPressed: login,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      ),
                    ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => RegisterPage(),
                              fullscreenDialog: true));
                    },
                    child: Text('Don\'t have an account? Register here.'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_errorMessage != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(child: Text(_errorMessage)),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  void _onLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Padding(
            padding: EdgeInsets.all(15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: new CircularProgressIndicator(),
                ),
                new Text("Loading"),
              ],
            ),
          ));
        });
  }

  void saveRemainLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', _remainLoggedIn);
  }

  Future<void> login() async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      _onLoading();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;

        saveRemainLoggedIn();

        Navigator.pop(context); //pop loading dialog
        //Navigator.push(context, MaterialPageRoute<void>(builder: (context) => NavBar()));
        Navigator.pushReplacement(
            context, MaterialPageRoute<void>(builder: (context) => NavBar()));
      } catch (e) {
        setState(() {
          _errorMessage = e.message;
        });

        Navigator.pop(context); //pop loading dialog
        print(e.message);
      }
    }
  }
}
