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
            clearUserInformation();
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView()));
          },
        ),
        ),
      ),
    );
  }

  void clearUserInformation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', null);
    await prefs.setString('id', null);
  }

  void saveRemainLoggedOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }
}