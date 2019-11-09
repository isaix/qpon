import 'package:Qpon/NavBar.dart';
import 'package:Qpon/Login/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
          child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return 'You must enter an email.';
                }
                return null;
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextFormField(
              validator: (input){
                if(input.length < 8){
                  return 'Your password must be at least 8 characters long.';
                }
                return null;
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(
                labelText: 'Password'),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: login,
              child: Text('Login'),
              ),
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute<void>(builder: (context) => RegisterPage()));
              },
              child: Text('Register'),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> login() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        Navigator.push(context, MaterialPageRoute<void>(builder: (context) => NavBar()));
      }catch(e){
        print(e.message);
      }
    }
  }
}