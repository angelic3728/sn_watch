import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sn_watch/helper/helperfunctions.dart';

class DatabaseMethods {
  Future<void> addUserInfo(uid, userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  checkGoogleUser(email) async {
    bool isEmpty = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where('userEmail', isEqualTo: email)
          .get()
          .then((data) => {
                if (data.docs.length != 0)
                  {
                    isEmpty = false,
                    HelperFunctions.saveUIDSharedPreference(
                        data.docs[0].data()["uid"]),
                    HelperFunctions.saveUserNameSharedPreference(
                        data.docs[0].data()["userName"]),
                    HelperFunctions.saveUserEmailSharedPreference(
                        data.docs[0].data()["userEmail"]),
                  }
              });
      return isEmpty;
    } catch (e) {
      return isEmpty;
    }
  }

  isTriedUser(email, uid) async {
    bool isEmpty = true;
    try {
      FirebaseFirestore.instance
          .collection("users")
          .where('userEmail', isEqualTo: email)
          .where('authors', arrayContains: uid)
          .get()
          .then((data) => {if (data.docs.length != 0) isEmpty = false});
      return isEmpty;
    } catch (e) {
      return isEmpty;
    }
  }

  addGoogleUser(email, uid) async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .then((data) => {
              data.docs.forEach((doc) async {
                var authors = doc.data()["authors"];
                if (authors.length == 1) {
                  authors.add(uid);
                  doc.reference.update({"authors": authors});
                }
              })
            });
  }

  getUserInfo(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByKeyword(String searchField, String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('searchKeywords', arrayContains: searchField)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyUID) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('uids', arrayContains: itIsMyUID)
        .snapshots();
  }

  getUnreadMsgs(String myUID) async {
    List<Stream<QuerySnapshot>> allSnapshots = [];
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .where('uids', arrayContains: myUID)
          .get()
          .then((data) => {
                data.docs.forEach((doc) {
                  Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
                      .collection("chatRoom")
                      .doc(doc.id)
                      .collection('chats')
                      .where('sendBy', isNotEqualTo: myUID)
                      .snapshots();
                  allSnapshots.add(snapshot);
                })
              });
      return Rx.merge(allSnapshots);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getUnreadChats(String myUID) async {
    Map<String, int> allSnapshots = {};
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .where('uids', arrayContains: myUID)
          .get()
          .then((data) => {
                data.docs.forEach((doc) {
                  String key;
                  int value;
                  FirebaseFirestore.instance
                      .collection("chatRoom")
                      .doc(doc.id)
                      .collection('chats')
                      .where('sendBy', isNotEqualTo: myUID)
                      .get()
                      .then((data2) => {
                            key = doc.id,
                            value = data2.docs
                                .where((doc2) => doc2.data()['isread'] == false)
                                .length,
                            allSnapshots[key] = value
                          });
                })
              });
      return allSnapshots;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  checkMessages(String roomID, String myUID) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(roomID)
        .collection('chats')
        .where('isread', isEqualTo: false)
        .get()
        .then((data) => {
              data.docs.forEach((doc) async {
                FirebaseFirestore.instance
                    .collection("chatRoom")
                    .doc(roomID)
                    .collection('chats')
                    .doc(doc.id)
                    .update({'isread': true});
              })
            });
  }
}
