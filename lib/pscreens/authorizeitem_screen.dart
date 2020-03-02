import 'package:flutter/material.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/services/database_service.dart';

class AuthorizeItem extends StatefulWidget {
  final User user;
  

  AuthorizeItem({this.user});


  @override
  _AuthorizeItemState createState() => _AuthorizeItemState();
}

class _AuthorizeItemState extends State<AuthorizeItem> {
  String _role;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'TEST',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Text('a')
    );
  }
}