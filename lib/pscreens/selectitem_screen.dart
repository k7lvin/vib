import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/user_data.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pmodels/itemdata_model.dart';
import 'package:sociole/pscreens/selectqty_screen.dart';

import 'package:sociole/services/database_service.dart';
import 'package:sociole/widgets/itemlist_view.dart';

class Listitem extends StatefulWidget {
  final String currentUserId;

  Listitem({this.currentUserId});

  @override
  _ListitemState createState() => _ListitemState();
}

class _ListitemState extends State<Listitem> {
  List<ItemData> _itemData = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _setupFeed();
  }

  _clear() {
    setState(() {
      DatabaseService.unselectall(currentUserId: widget.currentUserId);
    });
  }

  _setupFeed() async {
    List<ItemData> itemData =
        await DatabaseService.getItemList(widget.currentUserId);
    if (mounted) {
      return setState(() {
        _itemData = itemData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _setupFeed(),
        child: ListView.builder(
          itemCount: _itemData.length,
          itemBuilder: (BuildContext context, int index) {
            ItemData itemData = _itemData[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(itemData.creatorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }

                return ItemListView(
                  currentUserId: widget.currentUserId,
                  itemData: itemData,
                );
              },
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FlatButton.icon(
                icon: Icon(
                  Icons.clear,
                  size: 15.0,
                  color: Colors.grey[800],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey[600])),
                onPressed: _clear,
                color: Colors.transparent,
                textColor: Colors.black54,
                label: Text(
                  'Clear',
                  style: TextStyle(fontSize: 11.0, color: Colors.grey[800]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
              child: FlatButton.icon(
                icon: Icon(
                  Icons.timelapse,
                  size: 15.0,
                  color: Colors.grey[800],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey[600])),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GenerateQr(currentUserId: widget.currentUserId)),
                  );
                },
                color: Colors.transparent,
                textColor: Colors.black54,
                label: Text(
                  'Generate Qr',
                  style: TextStyle(fontSize: 11.0, color: Colors.grey[800]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
              child: FlatButton(
                child: Text('test'),
                onPressed: () => print(_itemData.length),
              ),
            )
          ],
        ),
      ),
    )

        // FutureBuilder(
        //   future: getPosts(Provider.of<UserData>(context).currentUserId),
        //   builder: (BuildContext context, int index) {
        //      Post post = _posts[index];
        //     if (!snapshot.hasData) {
        //       // print(Provider.of<UserData>(context).currentUserId);
        //       return Center(child: CircularProgressIndicator());
        //     } else {
        //       return ListView.builder(
        //         itemCount: snapshot.data.length,
        //         itemBuilder: (_, index) {
        //           // print(snapshot.data.toString());

        //           return Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: ListTile(
        //               leading: Image(
        //                   image: CachedNetworkImageProvider(
        //                       snapshot.data[index].data["imageUrl"]),
        //                   fit: BoxFit.contain),
        //               title: Text(
        //                 snapshot.data[index].data["productName"],
        //                 style: TextStyle(fontWeight: FontWeight.bold),
        //               ),
        //               subtitle: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   Text(snapshot.data[index].data["qty"].toString()),
        //                 ],
        //               ),
        //               dense: true,
        //               trailing: GestureDetector(
        //                   onTap: () {
        //                     print(snapshot.data[index].data);
        //                     setState(
        //                       () {
        //                         ItemData itemData = ItemData(
        //                           isSelected:
        //                               !snapshot.data[index].data["isSelected"],
        //                         );
        //                         DatabaseService.updateIsClicked(
        //                           snapshot.data[index].documentID,
        //                           itemData,
        //                           Provider.of<UserData>(context).currentUserId,
        //                         );
        //                       },
        //                     );
        //                   },
        //                   child: snapshot.data[index].data["isSelected"]
        //                       ? Icon(
        //                           Icons.check_box,
        //                           color: Colors.red,
        //                         )
        //                       : Icon(
        //                           Icons.check_box,
        //                           color: Colors.grey,
        //                         ))
        //             ),
        //           );
        //         },
        //       );
        //     }
        //   },
        // )

        );
  }
}
