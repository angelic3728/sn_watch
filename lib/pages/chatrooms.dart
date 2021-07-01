import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/helper/theme.dart';
import 'package:sn_watch/services/database.dart';
import 'package:sn_watch/pages/chat.dart';
import 'package:sn_watch/pages/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  Map<String, int> unreadMsgsObj = {};

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

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: new Text("Chat Rooms", style: TextStyle(fontSize: 20))),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: null,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
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
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final int unreadMsgs;
  final Function getRequests;

  ChatRoomsTile(
      {this.userName,
      @required this.chatRoomId,
      this.unreadMsgs,
      this.getRequests});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              new MaterialPageRoute(
                  builder: (_) => new Chat(chatRoomId: chatRoomId)),
            )
            .then((val) => val ? getRequests() : null);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(8.0),
          color: Colors.orange[100],
          boxShadow: [
            BoxShadow(
              color: Colors.grey[100],
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(userName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
            (unreadMsgs != 0)
                ? Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.redAccent[400],
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            unreadMsgs.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )))
                : Container()
          ],
        ),
      ),
    );
  }
}
