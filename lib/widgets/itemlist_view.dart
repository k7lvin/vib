import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sociole/models/post_model.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pmodels/itemdata_model.dart';
import 'package:sociole/screens/comments_screen.dart';
import 'package:sociole/screens/profile_screen.dart';
import 'package:sociole/services/database_service.dart';

class ItemListView extends StatefulWidget {
  final String currentUserId;
  final ItemData itemData;
  final User author;

  ItemListView({
    this.currentUserId,
    this.itemData,
    this.author,
  });

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  bool isSelected;
  bool iisSelected = false;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    isSelected = widget.itemData.isSelected;

    _setupIsSelected();
  }

  @override
  void didUpdateWidget(ItemListView oldWidget) {
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
    DatabaseService.unselectItem(widget.itemData);
    DatabaseService.unselect(
        currentUserId: widget.currentUserId, itemData: widget.itemData);
    setState(() {
      isSelected = false;
    });
    print('a');
  }

  _select() {
    DatabaseService.selectItem(widget.itemData);
    DatabaseService.select(
        currentUserId: widget.currentUserId, itemData: widget.itemData);
    setState(() {
      isSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: Image(
              image: CachedNetworkImageProvider(widget.itemData.imageUrl),
              fit: BoxFit.contain),
          title: Text(
            widget.itemData.productName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.itemData.qty.toString()),
            ],
          ),
          dense: false,
          trailing: Container(
            child: IconButton(
              icon: isSelected
                  ? Icon(
                      Icons.check_box,
                    )
                  : Icon(Icons.check_box_outline_blank),
              iconSize: 30.0,
              onPressed: _selectOrUnselect,
            ),

            // FlatButton(
            //   onPressed: _selectOrUnselect,
            //   color: isSelected ? Colors.grey[200] : Colors.blue,
            //   textColor: isSelected ? Colors.black : Colors.white,
            //   child: Text(
            //     isSelected ? 'Unselect' : 'select',
            //     style: TextStyle(fontSize: 18.0),
            //   ),
            // ),
          )),
    );
  }
}
