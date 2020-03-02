import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sociole/models/avatar_model.dart';
import 'package:sociole/models/post_model.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pmodels/itemdata_model.dart';
import 'package:sociole/utilities/constant.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static void selectItem(ItemData itemData) {
    itemRef
        .document(itemData.creatorId)
        .collection('itemdata')
        .document(itemData.qrId)
        .updateData({'isSelected': true});
  }

  static void unselectItem(ItemData itemData) {
    itemRef
        .document(itemData.creatorId)
        .collection('itemdata')
        .document(itemData.qrId)
        .updateData({'isSelected': false});
  }

  static authorizeUser(String userid) {
    usersRef.document(userid).updateData({'role': 'supplier'});
  }

  static void updateIsClicked(
      String itemDataId, ItemData itemData, String userId) {
    itemRef
        .document(userId)
        .collection('itemdata')
        .document(itemDataId)
        .updateData(
      {'isSelected': itemData.isSelected},
    );
  }

  static void insertItem(ItemData itemData) {
    itemRef.document(itemData.creatorId).collection('itemdata').add({
      'imageUrl': itemData.imageUrl,
      'productName': itemData.productName,
      'isUsed': itemData.isUsed,
      'qty': itemData.qty,
      'creatorId': itemData.creatorId,
      'timestamp': itemData.timestamp,
      'isSelected': itemData.isSelected,
    });
  }

  static Future<List<ItemData>> getItemData(String partneruserId) async {
    QuerySnapshot partneruserPostsSnapshot = await itemRef
        .document(partneruserId)
        .collection('itemdata')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<ItemData> posts = partneruserPostsSnapshot.documents
        .map((doc) => ItemData.fromDoc(doc))
        .toList();
    return posts;
  }

  // static Future<QuerySnapshot> getItemData2(String productName) {
  //   Future<QuerySnapshot> itemData =
  //       itemRef.orderBy('timestamp', descending: true).getDocuments();
  //   return itemData;
  // }

  // static Future<QuerySnapshot> searchUsers(String name) {
  //   Future<QuerySnapshot> users =
  //       usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
  //   return users;
  // }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection('users')
        .where('key', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

/////////////
  static void createAvatar(Avatar avatar) {
    avatarRef.document(avatar.id).collection('userAvatar').add({
      'userId': avatar.userId,
      'hair': avatar.hair,
      'eyes': avatar.eyes,
      'gender': avatar.gender,
      'hat': avatar.hat,
      'head': avatar.glasses,
      'body': avatar.body,
      'hands': avatar.hands,
      'pants': avatar.pants,
      'shoes': avatar.shoes,
      'bg': avatar.bg,
    });
  }
  ///////////////

  static void createPost(Post post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likeCount': post.likeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void select({String currentUserId, ItemData itemData}) {
    // Add user to current user's following collection
    itemRef
        .document(currentUserId)
        .collection('itemSelected')
        .document(itemData.qrId)
        .setData({});
  }

  static void select2({String currentUserId, ItemData itemData}) {
    // Add user to current user's following collection
    itemRef.document(currentUserId).collection('itemSelected').add({
      'imageUrl': itemData.imageUrl,
      'productName': itemData.productName,
      'isUsed': itemData.isUsed,
      'qty': itemData.qty,
      'creatorId': itemData.creatorId,
      'timestamp': itemData.timestamp,
      'isSelected': itemData.isSelected,
    });
  }

  static void unselect({String currentUserId, ItemData itemData}) {
    // Remove user from current user's following collection
    itemRef
        .document(currentUserId)
        .collection('itemSelected')
        .document(itemData.qrId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});
    // Add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user from current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void unselectall({String currentUserId}) {
    // Remove user from current user's following collection
    itemRef
        .document(currentUserId)
        .collection('itemSelected')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  // static void likePost({String currentUserId, Post post}) {
  //   DocumentReference postRef = postsRef
  //       .document(post.authorId)
  //       .collection('userPosts')
  //       .document(post.id);
  //   postRef.get().then((doc) {
  //     int likeCount = doc.data['likeCount'];
  //     postRef.updateData({'likeCount': likeCount + 1});
  //     likesRef
  //         .document(post.id)
  //         .collection('postLikes')
  //         .document(currentUserId)
  //         .setData({});

  //   });
  // }

  // static void unlikePost({String currentUserId, Post post}) {
  //   DocumentReference postRef = postsRef
  //       .document(post.authorId)
  //       .collection('userPosts')
  //       .document(post.id);
  //   postRef.get().then((doc) {
  //     int likeCount = doc.data['likeCount'];
  //     postRef.updateData({'likeCount': likeCount - 1});
  //     likesRef
  //         .document(post.id)
  //         .collection('postLikes')
  //         .document(currentUserId)
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) {
  //         doc.reference.delete();
  //       }
  //     });
  //   });
  // }

  static Future<bool> isSelectedItem({ItemData itemData, String userId}) async {
    DocumentSnapshot selectedDoc = await itemRef
        .document(userId)
        .collection('itemSelected')
        .document(itemData.qrId)
        .get();
    return selectedDoc.exists;
  }
  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<List<ItemData>> getPosts2({String userId}) async {
    QuerySnapshot item = await itemRef
        .document(userId)
        .collection('itemdata')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<ItemData> itemData =
        item.documents.map((doc) => ItemData.fromDoc(doc)).toList();
    return itemData;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersSnapshot.documents.length;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<ItemData>> getItemList(String userId) async {
    QuerySnapshot itemSnapshot = await itemRef
        .document(userId)
        .collection('itemdata')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<ItemData> itemData =
        itemSnapshot.documents.map((doc) => ItemData.fromDoc(doc)).toList();
    return itemData;
  }

  static Future<List<ItemData>> getItemSelected(String userId) async {
    QuerySnapshot itemSnapshot = await itemRef
        .document(userId)
        .collection('itemSelected')
        .getDocuments();
    List<ItemData> itemData =
        itemSnapshot.documents.map((doc) => ItemData.fromDoc(doc)).toList();
    return itemData;
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        userPostsSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

  static void likePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount + 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .setData({});
    });
  }

  static void unlikePost({String currentUserId, Post post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount - 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }

  static void commentOnPost({String currentUserId, Post post, String comment}) {
    commentsRef.document(post.id).collection('postComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .document(postId)
        .get();
    return Post.fromDoc(postDocSnapshot);
  }
}
//distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.2-all.zip, 1.2.71(kotlin android/gradle)
