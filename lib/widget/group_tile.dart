import 'package:flutter/material.dart';
import 'package:sn_watch/pages/gchat.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String userId;
  final String groupId;
  final String groupName;
  final int unreadGMsgs;
  final Function getGRequests;

  GroupTile(
      {this.userName,
      this.userId,
      this.groupId,
      this.groupName,
      this.unreadGMsgs,
      this.getGRequests});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => new GChatPage(
                      groupId: groupId,
                      userName: userName,
                      userId: userId,
                      groupName: groupName,
                    )))
            .then((val) => {(val == null || !val ) ? null : getGRequests()});
      },
      child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.blueAccent[700],
                child: Text(groupName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              title: Text(groupName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Join the conversation as $userName",
                  style: TextStyle(fontSize: 13.0)),
              trailing: (unreadGMsgs == 0 || unreadGMsgs == null)
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.redAccent[400],
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        unreadGMsgs.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          )),
    );
  }
}
