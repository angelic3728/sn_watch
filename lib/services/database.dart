import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sn_watch/helper/helperfunctions.dart';

class DatabaseMethods {
// Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection('chatRoom');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future<void> addUserInfo(uid, userData) async {
    userCollection.doc(uid).set(userData).catchError((e) {
      print(e.toString());
    });
  }

  checkGoogleUser(email) async {
    bool isEmpty = true;
    try {
      await userCollection
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
      userCollection
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
    userCollection.where("userEmail", isEqualTo: email).get().then((data) => {
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
    return userCollection.doc(uid).get().catchError((e) {
      print(e.toString());
    });
  }

  searchByKeyword(String searchField, String email) async {
    return userCollection
        .where('searchKeywords', arrayContains: searchField)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatRoom(chatRoom, chatRoomId) {
    chatRoomCollection.doc(chatRoomId).set(chatRoom).catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return chatRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    chatRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyUID) async {
    return chatRoomCollection
        .where('uids', arrayContains: itIsMyUID)
        .snapshots();
  }

  getUnreadMsgs(String myUID) async {
    List<Stream<QuerySnapshot>> allSnapshots = [];
    try {
      await chatRoomCollection
          .where('uids', arrayContains: myUID)
          .get()
          .then((data) => {
                data.docs.forEach((doc) {
                  Stream<QuerySnapshot> snapshot = chatRoomCollection
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

  getUnreadGMsgs(String myUID, String userName) async {
    String memberStr = myUID + "_" + userName;
    List<Stream<QuerySnapshot>> allSnapshots = [];
    try {
      await groupCollection
          .where('members', arrayContains: memberStr)
          .get()
          .then((data) => {
                data.docs.forEach((doc) async {
                  Stream<QuerySnapshot> snapshot = groupCollection
                      .doc(doc.id)
                      .collection('messages')
                      .where('senderId', isNotEqualTo: myUID)
                      .snapshots();
                  allSnapshots.add(snapshot);
                })
              });
      return Rx.zipList(allSnapshots);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getUnreadChats(String myUID) async {
    Map<String, int> allSnapshots = {};
    try {
      await chatRoomCollection
          .where('uids', arrayContains: myUID)
          .get()
          .then((data) => {
                data.docs.forEach((doc) {
                  String key;
                  int value;
                  chatRoomCollection
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
    chatRoomCollection
        .doc(roomID)
        .collection('chats')
        .where('isread', isEqualTo: false)
        .get()
        .then((data) => {
              data.docs.forEach((doc) async {
                chatRoomCollection
                    .doc(roomID)
                    .collection('chats')
                    .doc(doc.id)
                    .update({'isread': true});
              })
            });
  }

  // get user groups
  getUserGroups(String myUID) async {
    return userCollection.doc(myUID).snapshots();
  }

  // create group
  Future createGroup(String uid, String userName, String groupName) async {
    var searchKeywords = [];

    var firstName = userName.split(" ")[0];
    var lastName = userName.split(" ")[1];

    for (int i = 0; i < userName.split(" ")[0].length; i++) {
      searchKeywords.add(firstName.substring(0, i + 1));
    }

    for (int j = 0; j < lastName.length; j++) {
      searchKeywords.add(lastName.substring(0, j + 1));
    }

    for (int k = 0; k < groupName.length; k++) {
      searchKeywords.add(groupName.substring(0, k + 1));
    }
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'searchKeywords': searchKeywords,
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }

  // send message
  sendGMessage(String groupId, chatMessageData) async {
    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();

    List<dynamic> members = await groupDocSnapshot.data()['members'];

    Map<String, bool> isreads = {};

    members.forEach((element) {
      String memberId = element.toString().split("_")[0];
      if (memberId == chatMessageData["senderId"])
        isreads[memberId] = true;
      else
        isreads[memberId] = false;
    });

    Map<String, dynamic> gchatMessage = chatMessageData;
    gchatMessage["isreads"] = isreads;

    groupCollection.doc(groupId).collection('messages').add(chatMessageData);
    groupCollection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getGChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  searchByGName(String keyword) async {
    return groupCollection
        .where('searchKeywords', arrayContains: keyword)
        .get();
  }

  Future<bool> isUserJoined(
      String uid, String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data()['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // toggling the user group join
  Future togglingGroupJoin(
      String uid, String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot.data()['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }
}
