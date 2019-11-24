import 'package:Qpon/Views/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            saveRemainLoggedOut();
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView()));
          },
        ),
        ),
      ),
    );
  }

  void saveRemainLoggedOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }
}