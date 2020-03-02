import 'package:cloud_firestore/cloud_firestore.dart';

class ItemData {
  final String qrId;
  final String imageUrl;
  final String productName;
  final bool isUsed;
  final int qty;
  final String creatorId;
  final Timestamp timestamp;
  final bool isSelected;

  ItemData({
    this.qrId,
    this.imageUrl,
    this.productName,
    this.isUsed,
    this.qty,
    this.creatorId,
    this.timestamp,
    this.isSelected,
  });

  factory ItemData.fromDoc(DocumentSnapshot doc) {
    return ItemData(
        qrId: doc.documentID,
        imageUrl: doc['imageUrl'],
        productName: doc['productName'],
        isUsed: doc['isUsed'],
        qty: doc['qty'],
        creatorId: doc['creatorId'],
        timestamp: doc['timestamp'],
        isSelected: doc['isSelected']);
  }
}
