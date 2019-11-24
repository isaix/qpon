import 'package:Qpon/Views/LoginPage.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Container(
        child: Center(
          child: RaisedButton(
          child: Text('Log out'),
          onPressed:(){
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView()));
          },
        ),
        ),
      ),
    );
  }
}