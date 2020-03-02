import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sociole/models/user_data.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pmodels/itemdata_model.dart';
import 'package:sociole/pscreens/selectqty_screen.dart';

import 'package:sociole/services/database_service.dart';
import 'package:sociole/widgets/itemlist_view.dart';
import 'package:sociole/widgets/itemselected_view.dart';

class GenerateQr extends StatefulWidget {
  final String currentUserId;

  GenerateQr({this.currentUserId});

  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  List<ItemData> _itemData = [];
  List<String> _qrDataList = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _setupFeed();
  }

  _convert() {
    for (int i = 0; i < _itemData.length; i++) {
      if (!_qrDataList.contains(_itemData[i].qrId)) {
        _qrDataList.add(_itemData[i].qrId);
      }

    }
    return(_qrDataList.join());
  }

  _setupFeed() async {
    List<ItemData> itemData =
        await DatabaseService.getItemSelected(widget.currentUserId);
    if (mounted) {
      return setState(() {
        _itemData = itemData;
      });
    }
  }

  Future getPosts(String partnerUserId) async {
    var firestore = Firestore.instance;

    QuerySnapshot item = await firestore
        .collection("item")
        .document(Provider.of<UserData>(context).currentUserId)
        .collection('itemSelected')
        .getDocuments();
    print(item.documents);
    return item.documents;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _setupFeed(),
        child: Scaffold(
          bottomSheet: Text('a'),
          appBar: AppBar(
            title: Text('Select Quantity'),
            backgroundColor: Colors.grey,
          ),
          body: QrImage(data: _convert(),),

          //         body: ListView.builder(
          //   itemCount: _itemData.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     ItemData itemData = _itemData[index];
          //     return FutureBuilder(
          //       future: getPosts(widget.currentUserId),
          //       builder: (BuildContext context, AsyncSnapshot snapshot) {
          //         if (!snapshot.hasData) {
          //           return SizedBox.shrink();
          //         }

          //         return ItemSelectedView(
          //           currentUserId: widget.currentUserId,
          //           itemData: itemData,
          //         );
          //       },
          //     );
          //   },
          // ),
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
