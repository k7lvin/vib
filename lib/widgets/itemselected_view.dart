import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sociole/models/post_model.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pmodels/itemdata_model.dart';
import 'package:sociole/screens/comments_screen.dart';
import 'package:sociole/screens/profile_screen.dart';
import 'package:sociole/services/database_service.dart';

class ItemSelectedView extends StatefulWidget {
  final String currentUserId;
  final ItemData itemData;
  final User author;
  
  

  ItemSelectedView({this.currentUserId, this.itemData, this.author,});

  @override
  _ItemSelectedViewState createState() => _ItemSelectedViewState();
}

class _ItemSelectedViewState extends State<ItemSelectedView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  bool isSelected ;
  bool iisSelected = false;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    isSelected = widget.itemData.isSelected;
    
    _setupIsSelected();
    
   
  }

  @override
  void didUpdateWidget(ItemSelectedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemData.isSelected != widget.itemData.isSelected) {
      iisSelected = widget.itemData.isSelected;
    }
  }

  
  
  

  _setupIsSelected() async {
    bool itisSelected = await DatabaseService.isSelectedItem(
        itemData: widget.itemData, userId: widget.currentUserId);
    setState(() {
      if (!mounted) return;
      isSelected = itisSelected;
    });
  }




  _selectOrUnselect() {
    if (isSelected) {
      _unselect();
    } else {
      _select();
    }
  }

  _unselect() {
    DatabaseService.unselect(
        currentUserId: widget.currentUserId, itemData: widget.itemData);
    setState(() {
      isSelected = false;
    });
  }

  _select() {
    DatabaseService.select(
        currentUserId: widget.currentUserId, itemData: widget.itemData);
    setState(() {
      isSelected = true;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _likeCount = widget.itemData.likeCount;
  //   _initPostLiked();
  // }

  // @override
  // void didUpdateWidget(ItemSelectedView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.itemData.likeCount != widget.itemData.likeCount) {
  //     _likeCount = widget.itemData.likeCount;
  //   }
  // }

  // _initPostLiked() async {
  //   bool isLiked = await DatabaseService.didLikePost(
  //     currentUserId: widget.currentUserId,
  //     itemData: widget.itemData,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _isLiked = isLiked;
  //     });
  //   }
  // }

  // _likePost() {
  //   if (_isLiked) {
  //     // Unlike ItemData
  //     DatabaseService.unlikePost(
  //         currentUserId: widget.currentUserId, itemData: widget.itemData);
  //     setState(() {
  //       _isLiked = false;
  //       _likeCount = _likeCount - 1;
  //     });
  //   } else {
  //     // Like ItemData
  //     DatabaseService.likePost(
  //         currentUserId: widget.currentUserId, itemData: widget.itemData);
  //     setState(() {
  //       _heartAnim = true;
  //       _isLiked = true;
  //       _likeCount = _likeCount + 1;
  //     });
  //     Timer(Duration(milliseconds: 350), () {
  //       setState(() {
  //         _heartAnim = false;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        
          
          title: QrImage(data: widget.itemData.qrId,)

            // FlatButton(
            //   onPressed: _selectOrUnselect,
            //   color: isSelected ? Colors.grey[200] : Colors.blue,
            //   textColor: isSelected ? Colors.black : Colors.white,
            //   child: Text(
            //     isSelected ? 'Unselect' : 'select',
            //     style: TextStyle(fontSize: 18.0),
            //   ),
            // ),
          ),


    );
  }
}
