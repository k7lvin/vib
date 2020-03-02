import 'package:cloud_firestore/cloud_firestore.dart';

class Avatar {
  final String id;
  final String userId;
  final String gender;
  final String hair;
  final String eyes;
  final String hat;
  final String glasses;
  final String body;
  final String hands;
  final String pants;
  final String shoes;
  final String bg;

  Avatar({
    this.id,
    this.userId,
    this.gender,
    this.hair,
    this.eyes,
    this.hat,
    this.glasses,
    this.body,
    this.hands,
    this.pants,
    this.shoes,
    this.bg,
  });

  factory Avatar.fromDoc(DocumentSnapshot doc) {
    return Avatar(
      id: doc.documentID,
      userId: doc['userId'],
      gender: doc['gender'],
      hair: doc['hair'],
      eyes: doc['eyes'],
      hat: doc['hat'],
      glasses: doc['glasses'],
      body: doc['body'],
      hands: doc['hands'],
      pants: doc['pants'],
      shoes: doc['shoes'],
      bg: doc['bg'],
    );
  }
}