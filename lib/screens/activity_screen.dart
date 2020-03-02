import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sociole/models/post_model.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/screens/edit_profile_screen.dart';
import 'package:sociole/services/auth_service.dart';
import 'package:sociole/utilities/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityScreen extends StatefulWidget {



  // Widget makeImageGrid() {
  //   return GridView.builder(
  //     gridDelegate:
  //         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
  //     itemBuilder: (context, index) {
  //       return ImageGridItem(index);
  //     },
  //   );
  // }

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

String productData = '09828342,192831038';

  
  Widget build(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
        children: <Widget>[
          QrImage(data: productData,
          ),

         
          FlatButton(
                      onPressed: () => AuthService.logout(),
                      child: Text('LOGOUT'),
                    ),
        ],
      ),
      )
      
    );
  }
}

// List<Widget> _buildGridTiles(numberOfTiles) {
//   List<Container> containers =
//       new List<Container>.generate(numberOfTiles, (int index) {
//     //index = 0, 1, 2,...
//     final imageName = index < 9
//         ? 'images/image0${index + 1}.JPG'
//         : 'images/image${index + 1}.JPG';
//     return new Container(
//       child: new Image.asset(imageName, fit: BoxFit.fill),
//     );
//   });
//   return containers;
// }

// class ImageGridItem extends StatefulWidget {

//   @override
//   _ImageGridItemState createState() => _ImageGridItemState();
// }

// class _ImageGridItemState extends State<ImageGridItem> {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
