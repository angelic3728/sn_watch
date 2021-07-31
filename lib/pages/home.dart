import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sn_watch/helper/constants.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/pages/chatrooms.dart';
import 'package:sn_watch/pages/links.dart';
import 'package:sn_watch/pages/login.dart';
import 'package:sn_watch/pages/questions.dart';
import 'package:sn_watch/services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:badges/badges.dart';

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayName = '';
  String _email = '';
  Stream<List<QuerySnapshot>> unreadMsgs;
  Stream<List<QuerySnapshot>> unreadGMsgs;
  Map<String, int> unreadMsgsObj = {};
  Map<String, int> unreadGMsgsObj = {};

  Future<Null> getInitials() async {
    Constants.myUID = await HelperFunctions.getUIDSharedPreference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString("USERNAME");
    });

    setState(() {
      _email = prefs.getString("USEREMAIL");
    });

    DatabaseMethods().getUnreadMsgs(Constants.myUID).then((data) {
      setState(() {
        unreadMsgs = data;
      });
    });

    DatabaseMethods()
        .getUnreadGMsgs(Constants.myUID, _displayName)
        .then((data) {
      setState(() {
        unreadGMsgs = data;
      });
    });
  }

  GestureDetector _buildButtonColumn(
      BuildContext context, Color color, String imgUrl, String label, flag) {
    final mq = MediaQuery.of(context).size;
    double itemWidth = (flag != 1) ? mq.width * 0.4 : mq.width * 0.8;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: itemWidth,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Image.asset(
              imgUrl,
              width: mq.width * 0.22,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.clip),
            ),
          ],
        ),
      ),
      onTap: () => {
        if (flag == 1)
          _launchGoogleDoc()
        else if (flag == 2)
          {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => LinksPage(title: "Links")))
          }
        else if (flag == 3)
          _makePhoneCall()
        else if (flag == 4)
          {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        QuestionsPage(title: "Question/Request")))
          }
        else if (flag == 5)
          {_launchPoliceBlotter()}
      },
    );
  }

  _launchGoogleDoc() async {
    const url =
        'https://docs.google.com/spreadsheets/d/10FtIW0XJmle55gYBEkHuKF2De99zKIN6GC6KYfDG_ZA/edit#gid=0';
    await launch(url);
  }

  _makePhoneCall() async {
    const phone_number = 'tel://999-999-99999';
    await launch(phone_number);
  }

  _launchPoliceBlotter() async {
    const url = 'https://www.cityofsummit.org/231/Police-Department';
    await launch(url);
  }

  @override
  void initState() {
    getInitials();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DatabaseMethods().getUnreadMsgs(Constants.myUID).then((data) {
        setState(() {
          unreadMsgs = data;
        });
      });

      DatabaseMethods()
          .getUnreadGMsgs(Constants.myUID, _displayName)
          .then((data) {
        setState(() {
          unreadGMsgs = data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    Color color = Colors.blue[500];
    Widget buttonSection1 = Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(context, color, "assets/images/w_icon.png",
              'Fernwood Road Directory', 1),
        ],
      ),
    );

    Widget buttonSection2 = Container(
      padding: EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              context, color, "assets/images/w_icon.png", 'Links', 2),
          _buildButtonColumn(
              context, color, "assets/images/w_icon.png", 'Safety Stats', 3),
        ],
      ),
    );

    Widget buttonSection3 = Container(
      padding: EdgeInsets.only(top: 25, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(context, color, "assets/images/w_icon.png",
              'Question/Request', 4),
          _buildButtonColumn(context, color, "assets/images/police_icon.png",
              'Police Blotter', 5),
        ],
      ),
    );

    Widget multiUnreadChats() {
      return StreamBuilder2<List<QuerySnapshot>, List<QuerySnapshot>>(
        streams: Tuple2(unreadMsgs, unreadGMsgs),
        builder: (context, snapshots) {
          if (snapshots.item1.hasData || snapshots.item2.hasData) {
            int unreadCnt = 0;
            int unreadGCnt = 0;
            if (snapshots.item1.hasData && snapshots.item1.data.length != 0) {
              snapshots.item1.data.forEach((cCollection) {
                Iterable<QueryDocumentSnapshot> isUnreadMsgs = cCollection.docs
                    .where((doc) => doc.data()['isread'] == false);
                String key = cCollection.docs[0].id;
                int value = isUnreadMsgs.length;
                unreadMsgsObj[key] = value;
              });

              unreadMsgsObj.forEach((key, value) {
                unreadCnt += value;
              });
            }

            if (snapshots.item2.hasData && snapshots.item2.data.length != 0) {
              snapshots.item2.data.forEach((gCollection) {
                Iterable<QueryDocumentSnapshot> isUnreadGMsgs = gCollection.docs
                    .where((doc) =>
                        doc.data()['isreads'][Constants.myUID] == false);
                if (isUnreadGMsgs.length != 0) {
                  String key = gCollection.docs[0].id;
                  int value = isUnreadGMsgs.length;
                  print(key);
                  print(value.toString());
                  unreadGMsgsObj[key] = value;
                }
              });

              if (unreadGMsgsObj.length != 0) {
                unreadGMsgsObj.forEach((key, value) {
                  unreadGCnt += value;
                });
              }
            }

            return GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(bottom: 15, right: 20),
                  alignment: Alignment.bottomRight,
                  child: ((unreadCnt + unreadGCnt) == 0)
                      ? Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 35,
                          child: Text('chat',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(5),
                              color: Colors.blue),
                        )
                      : Badge(
                          position: BadgePosition.topEnd(top: -10, end: -15),
                          badgeColor: Colors.red,
                          badgeContent: Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              child: Text(
                                (unreadCnt + unreadGCnt).toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                          child: Container(
                            alignment: Alignment.center,
                            width: 90,
                            height: 35,
                            child: Text('chat',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(5),
                              color: Colors.blue,
                            ),
                          ),
                        )),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => ChatRoom()),
                    ModalRoute.withName("MyHomePage"));
              },
            );
          } else {
            return Container();
          }
        },
      );
    }

    Widget chatButton = Container(height: 65, child: multiUnreadChats());

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Center(child: new Text("Summit Neighborhood Watch")),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Container(
              height: mq.height - 121 - MediaQuery.of(context).padding.top,
              alignment: Alignment.center,
              child: (mq.width > mq.height)
                  ? ListView(
                      children: [
                        buttonSection1,
                        buttonSection2,
                        buttonSection3,
                      ],
                    )
                  : Column(
                      children: [
                        buttonSection1,
                        buttonSection2,
                        buttonSection3,
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
            ),
            chatButton,
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              decoration: new BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _displayName ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _email ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Text("Fernwood Road Directory",
                      style: TextStyle(fontSize: 20, color: Colors.white))
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Log out",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                signout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    await googleSignIn.signOut();
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    HelperFunctions.saveUIDSharedPreference("");
    HelperFunctions.saveUserNameSharedPreference("");
    HelperFunctions.saveUserEmailSharedPreference("");
    snackbar(context, 'Logged out Successfully...', _scaffoldKey);
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => LoginPage()));
  }
}

snackbar(
    BuildContext context, String text, GlobalKey<ScaffoldState> _scaffoldKey) {
  final snackBar = SnackBar(
    backgroundColor: Colors.cyanAccent,
    content: Text(
      '$text ',
      style: TextStyle(fontSize: 18, color: Colors.black87),
    ),
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
