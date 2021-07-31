import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/services/database.dart';

import 'gchat.dart';

class GSearchPage extends StatefulWidget {
  @override
  _GSearchPageState createState() => _GSearchPageState();
}

class _GSearchPageState extends State<GSearchPage> {
  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserName();
  }

  // functions
  _getCurrentUserName() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
  }

  _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseMethods()
          .searchByGName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  _joinValueInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseMethods()
        .isUserJoined(Constants.myUID, groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                _userName,
                Constants.myUID,
                searchResultSnapshot.docs[index].data()["groupId"],
                searchResultSnapshot.docs[index].data()["groupName"],
                searchResultSnapshot.docs[index].data()["admin"],
              );
            })
        : Container();
  }

  Widget groupTile(String userName, String userId, String groupId,
      String groupName, String admin) {
    _joinValueInGroup(userName, groupId, groupName, admin);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: new BoxDecoration(color: Colors.orange[100], borderRadius: new BorderRadius.circular(5.0)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blueAccent,
              child: Text(groupName.substring(0, 1).toUpperCase(),
                  style: TextStyle(color: Colors.white))),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Admin: $admin"),
          trailing: InkWell(
            onTap: () async {
              await DatabaseMethods().togglingGroupJoin(
                  Constants.myUID, groupId, groupName, userName);
              if (_isJoined) {
                setState(() {
                  _isJoined = !_isJoined;
                });
                // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
                snackbar(context, 'Successfully joined the group "$groupName"',
                    _scaffoldKey);
                Future.delayed(Duration(milliseconds: 2000), () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GChatPage(
                          groupId: groupId,
                          userId: userId,
                          userName: userName,
                          groupName: groupName)));
                });
              } else {
                setState(() {
                  _isJoined = !_isJoined;
                });
                snackbar(context, 'Left the group "$groupName"', _scaffoldKey);
              }
            },
            child: _isJoined
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.white, width: 1.0)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child:
                        Text('Joined', style: TextStyle(color: Colors.white)),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text('Join', style: TextStyle(color: Colors.white)),
                  ),
          ),
        ));
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent[200],
        title: Text('Group Search',
            style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: // isLoading ? Container(
          //   child: Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // )
          // :
          Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          hintText:
                              "Search groups with Group Name and Administrator's Name.",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(Icons.search, color: Colors.white)))
                ],
              ),
            ),
            isLoading
                ? Container(padding: EdgeInsets.all(20.0), child: Center(child: CircularProgressIndicator()))
                : groupList()
          ],
        ),
      ),
    );
  }
}

snackbar(
    BuildContext context, String text, GlobalKey<ScaffoldState> _scaffoldKey) {
  final snackBar = SnackBar(
    backgroundColor: Colors.cyanAccent,
    content: Text(
      '$text ',
      style: TextStyle(fontSize: 18, color: Colors.black87),
    ),
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
