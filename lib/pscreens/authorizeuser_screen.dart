import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/user_data.dart';
import 'package:sociole/models/user_model.dart';
import 'package:sociole/pscreens/authorizeitem_screen.dart';
import 'package:sociole/screens/profile_screen.dart';
import 'package:sociole/services/database_service.dart';
import 'package:sociole/utilities/constant.dart';

class PSearchScreen extends StatefulWidget {
  @override
  _PSearchScreenState createState() => _PSearchScreenState();
}

class _PSearchScreenState extends State<PSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;
  String _role;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _submit(userid) {
    DatabaseService.authorizeUser(userid);

    Navigator.push(context, MaterialPageRoute(builder: (_) => AuthorizeItem()));
  }

  _buildUserTile(User user) {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: user.profileImageUrl.isEmpty
              ? AssetImage('assets/images/user_placeholder.jpg')
              : CachedNetworkImageProvider(user.profileImageUrl),
        ),
        title: Text(user.name),
        onTap: () => _submit(user.id)
        // onTap: usersRef.document(user.id).updateData({'role' = ''}) ,

        );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
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
          onSubmitted: (input) {
            if (input.isNotEmpty) {
              setState(() {
                _users = DatabaseService.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Text('Select user as an admin'),
            )
          : FutureBuilder(
              future: _users,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Text('No users found! Please try again.'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = User.fromDoc(snapshot.data.documents[index]);
                    return _buildUserTile(user);
                  },
                );
              },
            ),
    );
  }
}

//   var queryResultSet = [];
// var tempSearchStore = [];

// initiateSearch(value) {
//   if (value.length == 0) {
//     setState(() {
//       queryResultSet = [];
//       tempSearchStore = [];
//     });
//   }

//   var capitalizedValue =
//       value.substring(0, 1).toUpperCase() + value.substring(1);

//   if (queryResultSet.length == 0 && value.length == 1) {
//     DatabaseService().searchByName(value).then((QuerySnapshot docs) {
//       for (int i = 0; i < docs.documents.length; ++i) {
//         queryResultSet.add(docs.documents[i].data);
//       }
//     });
//   } else {
//     tempSearchStore = [];
//     queryResultSet.forEach((element) {
//       if (element['name'].startsWith(capitalizedValue)) {
//         setState(() {
//           tempSearchStore.add(element);
//         });
//       }
//     });
//   }
// }

/*

  ////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('Firestore search'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
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
                return buildResultCard(element);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
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
  );

*/
