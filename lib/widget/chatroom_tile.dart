import 'package:flutter/material.dart';
import 'package:sn_watch/helper/theme.dart';
import 'package:sn_watch/pages/chat.dart';

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final int unreadMsgs;
  final Function getRequests;

  ChatRoomsTile(
      {@required this.userName,
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
                  builder: (_) =>
                      new Chat(chatRoomId: chatRoomId, userName: userName)),
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
                  color: CustomTheme.colorAccent1,
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
            (unreadMsgs == 0 || unreadMsgs == null)
                ? Container()
                : Expanded(
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
          ],
        ),
      ),
    );
  }
}
