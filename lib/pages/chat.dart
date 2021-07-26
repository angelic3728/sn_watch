import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/services/database.dart';
import 'package:sn_watch/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  Chat({this.chatRoomId, this.userName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  Widget chatMessages() {
    var lastTime = 0;
    var newDateList = [];
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _scrollController.animateTo(
                (_scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut);
          });
          if (snapshot.data.docs[snapshot.data.docs.length - 1]
                  .data()['sendBy'] !=
              Constants.myUID)
            DatabaseMethods().checkMessages(widget.chatRoomId, Constants.myUID);
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
                  if (newDateList.length != snapshot.data.docs.length && newDateList.length == index) {
                    newDateList.add(true);
                  }
                } else {
                  if (newDateList.length != snapshot.data.docs.length && newDateList.length == index) {
                    newDateList.add(false);
                  }
                }
                lastTime = snapshot.data.docs[index].data()["time"];
                return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sendByMe: Constants.myUID ==
                        snapshot.data.docs[index].data()["sendBy"],
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

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myUID,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'isread': false
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: new Text(widget.userName, style: TextStyle(fontSize: 20))),
        elevation: 0.0,
        centerTitle: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: chatMessages(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.black54,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.greenAccent[400],
                            size: 25,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;
  final bool showDate;

  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      @required this.time,
      @required this.showDate});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        child: Column(
          children: [
            showDate
                ? Container(
                    margin: sendByMe
                        ? EdgeInsets.only(left: 24)
                        : EdgeInsets.only(right: 24),
                    padding: EdgeInsets.all(5.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.greenAccent[100]),
                    child: Text(
                      DateTime.fromMillisecondsSinceEpoch(time)
                          .toString()
                          .split(" ")[0],
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ))
                : Container(),
            Container(
              alignment:
                  sendByMe ? Alignment.centerRight : Alignment.centerLeft,
              margin: sendByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              padding: sendByMe
                  ? EdgeInsets.only(bottom: 5, right: 10)
                  : EdgeInsets.only(bottom: 5, left: 10),
              child: Text(getSentTime(time)),
            ),
            Container(
                alignment:
                    sendByMe ? Alignment.centerRight : Alignment.centerLeft,
                margin: sendByMe
                    ? EdgeInsets.only(left: 30)
                    : EdgeInsets.only(right: 30),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: sendByMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomLeft: Radius.circular(23))
                          : BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomRight: Radius.circular(23)),
                      gradient: LinearGradient(
                        colors: sendByMe
                            ? [Colors.blueAccent[400], Colors.blueAccent[700]]
                            : [Colors.orangeAccent[700], Colors.orange[800]],
                      )),
                  child: Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500)),
                ))
          ],
        ));
  }

  getSentTime(int time) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time).toString();
    var sTime = dateTime.split(" ")[1];
    var result = sTime.substring(0, 5);
    return result;
  }
}
