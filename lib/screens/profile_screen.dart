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

class _ProfileScreenState extends State<ProfileScreen> {
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
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 00.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 150.0,
                width: 150.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.0),
                  child: Image(
                    image: user.profileImageUrl.isEmpty
                        ? AssetImage('assets/images/user_placeholder.jpg')
                        : CachedNetworkImageProvider(user.profileImageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.grid_on),
            iconSize: 30.0,
            color: _displayPosts == 0 ? Colors.redAccent : Colors.grey[300],
            onPressed: () => setState(() {
              _displayPosts = 0;
            }),
          ),
          IconButton(
            icon: Icon(Icons.list),
            iconSize: 30.0,
            color: _displayPosts == 1 ? Colors.redAccent : Colors.grey[300],
            onPressed: () => setState(() {
              _displayPosts = 1;
            }),
          ),
        ],
      ),
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
        padding: EdgeInsets.zero,
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

          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  child: Stack(
                    
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        height: width,
                        width: width,
                        child: Image(
                          image: user.profileImageUrl.isEmpty
                              ? AssetImage('assets/images/user_placeholder.jpg')
                              : CachedNetworkImageProvider(user.profileImageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[_buildToggleButtons()],
                            ),
                            height: height * 0.05,
                            margin: EdgeInsets.only(top: height * 0.425),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, -1.0), //(x,y)
                                  blurRadius: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                      margin: EdgeInsets.symmetric(
                          vertical: height * 0.225, horizontal: width * 0.05),
                      color: Colors.yellow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Text(
                              'Danny Douglas',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  fontFamily: 'Public',
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              '@dDoug',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  fontFamily: 'Public',
                                  fontSize: 20.0,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Container(
                              child: Text(
                                'Product designer, Entrepreneur & Founder of Verve.co - 2019 ',
                                style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Colors.black,
                                      ),
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                    fontFamily: 'Public',
                                    fontSize: 15.0,
                                    color: Colors.grey[300],
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    _posts.length.toString(),
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    '32',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    _followingCount.toString(),
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    _followerCount.toString(),
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    'Posts',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    'Badges',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    'Following',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    'Followers',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontFamily: 'Public',
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                      
                    ],
                  ),
                ),
                _buildDisplayPosts()
              ],
            ),
          );

          Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: width,
                    height: width * 1.1,
                    color: Colors.white,
                    child: Image(
                      image: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.25, horizontal: width * 0.05),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                          child: Text(
                            'Danny Douglas',
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                ],
                                fontFamily: 'Public',
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            '@dDoug',
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                  ),
                                ],
                                fontFamily: 'Public',
                                fontSize: 20.0,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Container(
                            child: Text(
                              'Product designer, Entrepreneur & Founder of Verve.co - 2019 ',
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  fontFamily: 'Public',
                                  fontSize: 15.0,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  _posts.length.toString(),
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  '32',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  _followingCount.toString(),
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  _followerCount.toString(),
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  'Posts',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  'Badges',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  'Following',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  'Followers',
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                        Shadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontFamily: 'Public',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: width,
                          margin: EdgeInsets.only(top: height * 0.45),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 400.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
