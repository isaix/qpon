import 'package:Qpon/NavBar.dart';
import 'package:Qpon/Store/StoreHome.dart';
import 'package:Qpon/Views/Register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ref = Firestore.instance;

  String _email, _password, _errorMessage, _userRole;
  bool _remainLoggedIn = true;
  FirebaseUser _firebaseUser;

  //Auto-completed login credentials
  var emailTextController =
      new TextEditingController(text: "userdemo@qpon.com");
  var passwordTextController = new TextEditingController(text: "12345678");

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
                    controller: emailTextController,
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
                    controller: passwordTextController,
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
                  
                  /* Remain logged in
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
                  */
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 4),
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
                              builder: (context) => RegisterView(),
                              fullscreenDialog: true));
                    },
                    child: Text('Don\'t have an account? Register here.'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text('Autofill user information for testing:'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            emailTextController.text = 'userdemo@qpon.com';
                            passwordTextController.text = '12345678';
                          });
                        },
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Test as User',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            emailTextController.text = 'storedemo@qpon.com';
                            passwordTextController.text = '12345678';
                          });
                        },
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Test as Store',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void setEmailStore() {
    setState(() {});
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

  void saveUserInformation(String role, String id, String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    await prefs.setString('id', id);
    await prefs.setString('email', email);
  }

  void _confirmLogin() {
    if (_userRole != null) {

      saveUserInformation(_userRole, _firebaseUser.uid, _email);
      print('EMAIL HERE!!!!!!!!!!!!!!! ' + _email);

      if (_userRole == 'User') {
        Navigator.pop(context); //pop loading dialog
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (context) => NavBar(
                    currentUserID: _firebaseUser.uid, currentUserEmail: _email,)));
      } else if (_userRole == 'Store') {
        Navigator.pop(context); //pop loading dialog
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (context) => StoreHome(
                    currentUserID: _firebaseUser.uid)));
      } else {
        print('THE USER\'S ROLE: ' + _userRole);
      }
    } else {
      print('FAILED - USER ROLE IS NULL');
    }
  }

  Future<void> login() async {
    final formState = _formKey.currentState;


    if (formState.validate()) {
      formState.save();
      _onLoading();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        _firebaseUser = result.user;

        saveRemainLoggedIn();

        print('data herefter');

        ref.collection("users").getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            print('DATA: ${f.data}}');
            if (f.documentID == _firebaseUser.uid) {
              _userRole = f.data['role'];
            }
          });
        });

        Future.delayed(Duration(seconds: 2), () => _confirmLogin());

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
