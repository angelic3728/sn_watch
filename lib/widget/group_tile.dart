import 'package:flutter/material.dart';
import 'package:sn_watch/pages/gchat.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String userId;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.userId, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GChatPage(
                      groupId: groupId,
                      userName: userName,
                      userId: userId,
                      groupName: groupName,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blueAccent[700],
            child: Text(groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName",
              style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
