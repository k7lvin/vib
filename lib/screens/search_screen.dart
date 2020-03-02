import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/user_data.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/screens/profile_screen.dart';
import 'package:sociole/services/database_service.dart';




class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
TextEditingController _searchController = TextEditingController();

String val;


  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      val = null;
    });
  }

var queryResultSet = [];
var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      DatabaseService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }
  Widget buildResultCard(data) {

  return GestureDetector(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            currentUserId: Provider.of<UserData>(context).currentUserId,
            userId: data['id'],
          ),
        ),
      ),
      child: Card(
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center(
          child: Text(data['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
          )
        )
      )
    ),
  );
}



    @override
  Widget build(BuildContext context) {
    return new Scaffold(
        
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              
              onChanged: (val) {
                initiateSearch(val);
              },
                controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: _clearSearch,
            ),
            filled: true,
          ),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element );
              }).toList())
        ]));
  }
}















  /////////////
  // TextEditingController _searchController = TextEditingController();
  // Future<QuerySnapshot> _users;

  // _buildUserTile(User user) {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       radius: 20.0,
  //       backgroundImage: user.profileImageUrl.isEmpty
  //           ? AssetImage('assets/images/user_placeholder.jpg')
  //           : CachedNetworkImageProvider(user.profileImageUrl),
  //     ),
  //     title: Text(user.name),
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => ProfileScreen(
  //           currentUserId: Provider.of<UserData>(context).currentUserId,
  //           userId: user.id,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _clearSearch() {
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => _searchController.clear());
  //   setState(() {
  //     _users = null;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       title: TextField(
  //         controller: _searchController,
  //         decoration: InputDecoration(
  //           contentPadding: EdgeInsets.symmetric(vertical: 15.0),
  //           border: InputBorder.none,
  //           hintText: 'Search',
  //           prefixIcon: Icon(
  //             Icons.search,
  //             size: 30.0,
  //           ),
  //           suffixIcon: IconButton(
  //             icon: Icon(
  //               Icons.clear,
  //             ),
  //             onPressed: _clearSearch,
  //           ),
  //           filled: true,
  //         ),
  //         onSubmitted: (input) {
  //           if (input.isNotEmpty) {
  //             setState(() {
  //               _users = DatabaseService.searchUsers(input);
  //             });
  //           }
  //         },
  //       ),
  //     ),
  //     body: _users == null
  //         ? Center(
  //             child: Text('Search for a user'),
  //           )
  //         : FutureBuilder(
  //             future: _users,
  //             builder: (context, snapshot) {
  //               if (!snapshot.hasData) {
  //                 return Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               }
  //               if (snapshot.data.documents.length == 0) {
  //                 return Center(
  //                   child: Text('No users found! Please try again.'),
  //                 );
  //               }
  //               return ListView.builder(
  //                 itemCount: snapshot.data.documents.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   User user = User.fromDoc(snapshot.data.documents[index]);
  //                   return _buildUserTile(user);
  //                 },
  //               );
  //             },
  //           ),
  //   );
  // }}






