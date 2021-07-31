import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/services/database.dart';
import 'package:sn_watch/widget/message_tile.dart';

class GChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String userId;
  final String groupName;

  GChatPage({this.groupId, this.userName, this.userId, this.groupName});

  @override
  _GChatPageState createState() => _GChatPageState();
}

class _GChatPageState extends State<GChatPage> {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getGChats(widget.groupId).then((val) {
      setState(() {
        _chats = val;
      });
    });
  }

  Widget _chatMessages() {
    var lastTime = 0;
    var newDateList = [];
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_scrollController.hasClients)
              _scrollController.animateTo(
                  (_scrollController.position.maxScrollExtent),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut);
          });
          if (snapshot.data.docs[snapshot.data.docs.length - 1]
                  .data()['senderId'] !=
              Constants.myUID)
            DatabaseMethods().checkGMessages(widget.groupId, Constants.myUID);
          return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                bool showDate = false;
                if (index == 0 ||
                    DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.docs[index].data()["time"])
                            .toString()
                            .split(" ")[0] !=
                        DateTime.fromMillisecondsSinceEpoch(lastTime)
                            .toString()
                            .split(" ")[0]) {
                  showDate = true;
                  if (newDateList.length != snapshot.data.docs.length &&
                      newDateList.length == index) {
                    newDateList.add(true);
                  }
                } else {
                  if (newDateList.length != snapshot.data.docs.length &&
                      newDateList.length == index) {
                    newDateList.add(false);
                  }
                }
                lastTime = snapshot.data.docs[index].data()["time"];
                return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sender: snapshot.data.docs[index].data()["sender"],
                    sentByMe: widget.userId ==
                        snapshot.data.docs[index].data()["senderId"],
                    time: snapshot.data.docs[index].data()["time"],
                    showDate: (newDateList.length == snapshot.data.docs.length)
                        ? newDateList[index]
                        : showDate);
              });
        } else {
          return Container();
        }
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        "senderId": widget.userId,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().sendGMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
