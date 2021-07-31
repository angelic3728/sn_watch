import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/services/database.dart';
import 'package:sn_watch/pages/chat.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  var searchResult = [];

  bool isLoading = false;
  bool haveUserSearched = false;
  String _email = '';

  Future<Null> getSharedPrefs() async {
    String myEmail = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {
      _email = myEmail;
    });
  }

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByKeyword(searchEditingController.text, _email)
          .then((snapshot) {
        if (snapshot != null && snapshot.docs.length != 0) {
          searchResult = [];
          snapshot.docs.forEach((doc) async {
            if (doc['userEmail'] != _email) searchResult.add(doc);
          });

          if (searchResult.length != 0)
            setState(() {
              isLoading = false;
              haveUserSearched = true;
            });
          else
            setState(() {
              isLoading = false;
              haveUserSearched = false;
            });
        } else {
          setState(() {
            isLoading = false;
            haveUserSearched = false;
          });
        }
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResult[index].data()["uid"],
                searchResult[index].data()["userName"],
                searchResult[index].data()["userEmail"],
              );
            })
        : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String uid, String uname) async {
    String myUid = Constants.myUID;
    String myName = await HelperFunctions.getUserNameSharedPreference();
    Object users = {myUid: myName, uid: uname};
    List<String> uids = [myUid, uid];

    String chatRoomId = getChatRoomId(Constants.myUID, uid);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
      "uids": uids
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String uid, String userName, String userEmail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(8.0),
        color: Colors.orange[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(uid, userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSharedPrefs();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        title: new Center(
            child: new Text("User Search", style: TextStyle(fontSize: 20))),
        elevation: 0.0,
        centerTitle: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Color(0x54FFFFFF),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchEditingController,
                            style: new TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                labelText: 'Search User',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                enabled: true),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0x77FF5AA0),
                                        const Color(0xFFAA0000)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
