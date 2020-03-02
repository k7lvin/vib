import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociole/models/user_data.dart';

import 'package:sociole/pscreens/selectitem_screen.dart';

import 'package:sociole/services/database_service.dart';



import 'additem_screen.dart';


class P3HomeScreen extends StatefulWidget {
  @override
  _P3HomeScreenState createState() => _P3HomeScreenState();
}

class _P3HomeScreenState extends State<P3HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
  
  final String currentUserId = Provider.of<UserData>(context).currentUserId;

    return WillPopScope(
      onWillPop: () async => false,
          child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
         
            Listitem(currentUserId: currentUserId,),
        
            // FeedScreen(
            //   currentUserId: currentUserId,
            // ),
            // SearchScreen(),
            // CreatePostScreen(),
            // ActivityScreen(
             
            // ),
            // ProfileScreen(
            //   currentUserId: currentUserId,
            //   userId: currentUserId,
            // ),
          ],
          onPageChanged: (int index) {
            setState(() {
              _currentTab = index;
            });
          },
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          },
          activeColor: Colors.black,
          items: [ 
            
             BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                size: 32.0,
              ),
            ),
             BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                size: 32.0,
              ),
            ),
           
            
          ],
        ),
      ),
    );
  }
}

/* appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                'INSOCIO',
                style: TextStyle(
                    fontFamily: 'Lato', fontSize: 30.0, color: Colors.black),
              ),
            ),
          )),*/
