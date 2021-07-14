import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/services/database.dart';
import 'package:sn_watch/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:sn_watch/widget/chatroom_tile.dart';
import 'package:sn_watch/widget/group_tile.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  Stream chatRooms;
  Map<String, int> unreadMsgsObj = {};
  TabController _tabController;
  int _currentIndex = 0;
  Stream _groups;
  String _groupName;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getUserInfogetChats();
    _getJoinedGroups();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getRequests() async {
    getUserInfogetChats();
  }

  getUserInfogetChats() async {
    Constants.myUID = await HelperFunctions.getUIDSharedPreference();
    unreadMsgsObj = await DatabaseMethods().getUnreadChats(Constants.myUID);
    await DatabaseMethods().getUserChats(Constants.myUID).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: new Center(child: new Text("Chat Lists")),
        bottom: new PreferredSize(
            preferredSize:
                new Size(MediaQuery.of(context).size.width * .5, 40.0),
            child: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 3.0, color: Colors.orangeAccent[400]),
              ),
              tabs: [
                new Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Icon(Icons.chat_outlined),
                        Container(
                          padding: EdgeInsets.only(left: 3),
                          child: new Text("Chats",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )),
                new Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Icon(Icons.group_sharp),
                        Container(
                          padding: EdgeInsets.only(left: 3),
                          child: new Text("Groups",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )),
              ],
            )),
        elevation: 0.0,
        centerTitle: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Center(
        child: TabBarView(
            controller: _tabController,
            children: <Widget>[chatRoomsList(), groupsList()]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _currentIndex == 0
            ? Colors.greenAccent[700]
            : Colors.blueAccent[700],
        child: Icon(
          Icons.search,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(
                new MaterialPageRoute(builder: (_) => new Search()),
              )
              .then((val) => val ? _getRequests() : null);
        },
      ),
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String userName = snapshot.data.docs[index].data()['users'][
                      snapshot.data.docs[index]
                          .data()['chatRoomId']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myUID, "")];
                  String chatRoomId =
                      snapshot.data.docs[index].data()["chatRoomId"];
                  return ChatRoomsTile(
                      userName: userName,
                      chatRoomId: chatRoomId,
                      unreadMsgs: unreadMsgsObj[chatRoomId],
                      getRequests: _getRequests);
                })
            : Container();
      },
    );
  }

  // widgets
  Widget noGroupWidget() {
    print("no group");
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
            Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data['userName'],
                        groupId:
                            _destructureId(snapshot.data['groups'][reqIndex]),
                        groupName: _destructureName(
                            snapshot.data['groups'][reqIndex]));
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // functions
  _getJoinedGroups() async {
    await DatabaseMethods().getUserGroups(Constants.myUID).then((snapshots) {
      setState(() {
        _groups = snapshots;
      });
    });
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = TextButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseMethods().createGroup(Constants.myUID, val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
