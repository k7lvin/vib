import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String role;
  final String key;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.role,
    this.key
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      role: doc['role'],
      key: doc['key']
    );
  }
}
