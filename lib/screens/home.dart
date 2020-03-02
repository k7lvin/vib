import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sociole/pscreens/p2home_screen.dart';
import 'package:sociole/pscreens/p3home_screen.dart';
import 'package:sociole/pscreens/phome_screen.dart';
import 'package:sociole/screens/home_screen.dart';
import 'package:sociole/utilities/constant.dart';


class Home extends StatelessWidget {
  final String userId;
  
  // final FirebaseUser user;
  Home({this.userId});
  

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: 
        usersRef.document(userId).snapshots(),
        
        // Firestore.instance
        //     .collection('users')
        //     .document(idparam)
        //     .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // print(snapshot.data.documentID);
            // print(snapshot.data);
            return checkRole(snapshot.data);
            
            
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'partner') {
      // print('a' + snapshot.data['role']);
      // print('b' + snapshot['role']);
      return PHomeScreen();
    } else if (snapshot.data['role'] == '') { 
      // print('c' + snapshot.data['role']);
      // print('d' + snapshot['role']);
      return HomeScreen();
    } else if ( snapshot.data['role'] == 'supplier') {
      return P2HomeScreen();
    } else if ( snapshot.data['role'] == 'supplierbranch') {
      return P3HomeScreen();
    }
  } 

}