import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int time;
  final bool showDate;

  MessageTile(
      {this.message, this.sender, this.sentByMe, this.time, this.showDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: sentByMe ? 0 : 24, right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          showDate
              ? Container(
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
            alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            margin: sentByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: sentByMe
                ? EdgeInsets.only(bottom: 5, right: 10)
                : EdgeInsets.only(bottom: 5, left: 10),
            child: sentByMe
                ? Text(getSentTime(time), style: TextStyle(fontWeight: FontWeight.bold))
                : Text(sender+", "+getSentTime(time), style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
              alignment:
                  sentByMe ? Alignment.centerRight : Alignment.centerLeft,
              margin: sentByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              child: Container(
                padding:
                    EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: sentByMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                            bottomLeft: Radius.circular(23))
                        : BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                            bottomRight: Radius.circular(23)),
                    gradient: LinearGradient(
                      colors: sentByMe
                          ? [Colors.blueAccent[400], Colors.blueAccent[700]]
                          : [Colors.orangeAccent[700], Colors.orange[800]],
                    )),
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ))
        ],
      ),
    );
  }

  getSentTime(int time) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time).toString();
    var sTime = dateTime.split(" ")[1];
    var result = sTime.substring(0, 5);
    return result;
  }
}
