import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/user_data.dart';

import 'package:sociole/screens/feed_screen.dart';
import 'package:sociole/screens/home.dart';
import 'package:sociole/screens/home_screen.dart';
import 'package:sociole/screens/intro_screen.dart';
import 'package:sociole/screens/login_screen.dart';

import 'package:sociole/screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return Home(userId: snapshot.data.uid);
        } else {
          return IntroScreen();
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Verve',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryIconTheme: Theme.of(context)
                .primaryIconTheme
                .copyWith(color: Colors.black)),
        home: _getScreenId(),
        routes: {
          IntroScreen.id: (context) => IntroScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          FeedScreen.id: (context) => FeedScreen(),
        },
      ),
    );
  }
}
