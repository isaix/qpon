import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ref = Firestore.instance;
  String _email, _password, _errorMessage, _currentEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            showAlert(),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'You must enter an email.';
                }
                _currentEmail = input.trim();
                return null;
              },
              onSaved: (input) => _email = input.trim(),
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'You must enter an email';
                } else if (!(input == _currentEmail)) {
                  return 'Emails must match!';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Confirm Email'),
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
              child: RaisedButton(
                onPressed: register,
                child: Text('Register'),
              ),
            ),
                ],
              ),
            ),
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

  void saveUser(String id, String role) async{
    await ref.collection('users').document(id).setData({'role': role});
  }

  Future<void> register() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      _onLoading();
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        //user.sendEmailVerification();

        //save users to firestore as well, with user role
        saveUser(user.uid, 'User');

        Navigator.pop(context); //pop loading dialog

        Navigator.of(context).pop();
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
