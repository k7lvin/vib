import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/post_model.dart';
import 'package:sociole/models/user_data.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/screens/edit_profile_screen.dart';
import 'package:sociole/services/auth_service.dart';
import 'package:sociole/services/database_service.dart';
import 'package:sociole/utilities/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sociole/screens/2profile_screen.dart';
import 'package:sociole/widgets/post_view.dart';

import 'comments_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

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
  _ProfileScreenState createState() => _ProfileScreenState();
}

List<String> images = [
  "assets/images/image_04.jpg",
  "assets/images/image_03.jpg",
  "assets/images/image_02.jpg",
];

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _ProfileScreenState extends State<ProfileScreen> {
  var currentPage = images.length - 1.0;

  bool _isFollowing = false;
  int _followingCount = 0;
  int _followerCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0;
  User _profileUser;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _setupFollowers();
    _setupFollowing();
    _setupIsFollowing();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      if (!mounted) return;
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      if (!mounted) return;
      _followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      if (!mounted) return;

      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      if (!mounted) return;

      _posts = posts;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 200.0,
            child: FlatButton.icon(
              icon: Icon(
                Icons.edit,
                size: 15.0,
                color: Colors.grey[800],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.grey[600])),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    user: user,
                  ),
                ),
              ),
              color: Colors.transparent,
              textColor: Colors.black54,
              label: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 11.0, color: Colors.grey[800]),
              ),
            ),
          )
        : Container(
            width: 200.0,
            child: FlatButton(
              onPressed: _followOrUnfollow,
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: _isFollowing ? Colors.black : Colors.white,
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 00.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(user.profileImageUrl),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              _posts.length.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'posts',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _followerCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'followers',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _followingCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'following',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _displayButton(user),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                height: 40.0,
                child: Wrap(
                  children: <Widget>[
                    Text(
                      user.bio,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        ),
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommentsScreen(
              post: post,
              likeCount: post.likeCount,
            ),
          ),
        ),
        child: Image(
          image: CachedNetworkImageProvider(post.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach(
        (post) => tiles.add(_buildTilePost(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser,
          ),
        );
      });
      return Column(children: postViews);
    }
  }

  Widget build(BuildContext context) {
    // PageController controller = PageController(initialPage: images.length - 1);
    // controller.addListener(() {
    //   setState(() {
    //     currentPage = controller.page;
    //   });
    // });
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              _buildToggleButtons(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
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

// Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: Size.fromHeight(50.0),
//           child: AppBar(
//             backgroundColor: Colors.white,
//             title: Text(
//               'INSOCIO',
//               style: TextStyle(
//                   fontFamily: 'Lato', fontSize: 30.0, color: Colors.black),
//             ),
//             centerTitle: true,
//           )),
//       backgroundColor: Colors.white,
//       body: FutureBuilder(
//         future: usersRef.document(widget.userId).get(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           User user = User.fromDoc(snapshot.data);

//           return ListView(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
//                 child: Row(
//                   children: <Widget>[
//                     CircleAvatar(
//                       radius: 50.0,
//                       backgroundColor: Colors.grey,
//                       backgroundImage: user.profileImageUrl.isEmpty
//                           ? AssetImage('assets/images/user_placeholder.jpg')
//                           : CachedNetworkImageProvider(user.profileImageUrl),
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     '12',
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   Text(
//                                     'posts',
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     _followerCount.toString(),
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   Text(
//                                     'followers',
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: <Widget>[
//                                   Text(
//                                     _followingCount.toString(),
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   Text(
//                                     'following',
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           _displayButton(user),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       user.name,
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 5.0),
//                     Container(
//                       height: 80.0,
//                       child: Text(
//                         user.bio,
//                         style: TextStyle(fontSize: 15.0),
//                       ),
//                     ),
//                     Divider(),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

class CardScrollWidget extends StatelessWidget {
  final currentPage;
  final padding = 10.0;
  final verticalInset = 10.0;
  final String userId;

  CardScrollWidget({this.currentPage, this.userId});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder(
        future: usersRef.document(userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          List<String> imageFromFirebase = [user.profileImageUrl];

          return Container(
            width: width * 0.8,
            child: AspectRatio(
              aspectRatio: widgetAspectRatio,
              child: LayoutBuilder(builder: (context, contraints) {
                var width = contraints.maxWidth;
                var height = contraints.maxHeight;

                var safeWidth = width - 2 * padding;
                var safeHeight = height - 2 * padding;

                var heightOfPrimaryCard = safeHeight;
                var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

                var primaryCardLeft = safeWidth - widthOfPrimaryCard;
                var horizontalInset = primaryCardLeft / 2;

                List<Widget> cardList = new List();

                for (var i = 0; i < imageFromFirebase.length; i++) {
                  var delta = i - currentPage;
                  bool isOnRight = delta > 0;

                  var start = padding +
                      max(
                          primaryCardLeft -
                              horizontalInset * -delta * (isOnRight ? 10 : 1),
                          0.0);

                  var cardItem = Positioned.directional(
                    top: padding + verticalInset * max(-delta, 0.0),
                    bottom: padding + verticalInset * max(-delta, 0.0),
                    start: start,
                    textDirection: TextDirection.rtl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: AspectRatio(
                          aspectRatio: cardAspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              user.profileImageUrl.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'You don\'t have a profile picture yet!',
                                        ),
                                      ],
                                    )
                                  : Image.network(
                                      imageFromFirebase[0],
                                      fit: BoxFit.cover,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  cardList.add(cardItem);
                }
                return Stack(
                  children: cardList,
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
