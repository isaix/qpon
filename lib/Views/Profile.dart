import 'package:Qpon/Views/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({Key key, this.currentUserEmail}) : super(key: key);
  final String currentUserEmail;

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                'Current user:',
                style: TextStyle(
                  fontSize: 16,
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Center(
              child: Text(
                widget.currentUserEmail,
                style: TextStyle(
                  fontSize: 24,
                )
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                saveRemainLoggedOut();
                clearUserInformation();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
              color: Colors.deepOrange,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, bottom: 12, left: 6, right: 6),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Center(
              child: Text(
                'Isaac Irani - s175187',
                style: TextStyle(
                  fontSize: 16,
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Center(
              child: Text(
                'Tobias Hagemann - s175212',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    /*Container(
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
    );*/
  }

  void clearUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', null);
    await prefs.setString('id', null);
    await prefs.setString('email', null);
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }
}
