import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_watch/pages/login.dart';
import 'package:sn_watch/services/auth.dart';
import 'package:sn_watch/services/database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPwd = new TextEditingController();
  bool isLoading = false;
  static const gradi_top_color = Color(0xFFd7781d);
  static const gradi_bottom_color = Color(0xFFff1586);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
              padding:
                  EdgeInsets.only(left: mq.width * 0.1, right: mq.width * 0.1),
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: mq.height * 0.85,
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: mq.height * 0.05),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Create Account,",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Sign up to get started!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800]),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40, bottom: 40),
                          alignment: Alignment.center,
                          child: new Image.asset(
                            "assets/images/s_logo.png",
                            width: mq.width * 0.4,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 0),
                            child: TextFormField(
                              controller: firstName,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: 'First Name',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                  enabled: true),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: lastName,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                  enabled: true),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: email,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  prefixIcon: Icon(
                                    Icons.email,
                                  ),
                                  enabled: true),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: password,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  enabled: true),
                              obscureText: true,
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: confirmPwd,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  enabled: true),
                              obscureText: true,
                            )),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    gradi_bottom_color,
                                    gradi_top_color
                                  ])),
                          margin: EdgeInsets.only(top: 20),
                          child: isLoading
                              ? Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                )
                              : TextButton(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    if (!isLoading) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await register(
                                          context,
                                          firstName.text.trim(),
                                          lastName.text.trim(),
                                          email.text.trim(),
                                          password.text,
                                          confirmPwd.text);
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: mq.height * 0.15,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("I already have an account.",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.blue[500], fontSize: 18),
                            ))
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  Future register(BuildContext context, String firstName, String lastName,
      String email, String password, String confirmPwd) async {
    if (firstName.trim().length == 0) {
      snackbar(context, "Please type your first name.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else if (lastName.trim().length == 0) {
      snackbar(context, "Please type your last name.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else if (email.trim().length == 0) {
      snackbar(context, "Please type your email.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else if (password.trim().length == 0) {
      snackbar(context, "Please type password.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else if (password.length < 6) {
      snackbar(
          context, "Password must be longer than 5 characters.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else if (password != confirmPwd) {
      snackbar(context, "Please confirm your password.", _scaffoldKey);
      setState(() {
        isLoading = false;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!(regex.hasMatch(email))) {
        snackbar(
            context, "Please type your valid email address.", _scaffoldKey);
      } else {
        try {
          String displayName = firstName + " " + lastName;
          await authService
              .signUpWithEmailAndPassword(email, password, displayName)
              .then((user) async {
            setState(() {
              isLoading = false;
            });

            var searchKeywords = [];

            String emailKeyword = email.split("@")[0].toLowerCase();

            for (int i=0; i<firstName.length; i++) {
              searchKeywords.add(firstName.substring(0, i+1));
            }

            for (int j=0; j<lastName.length; j++) {
              searchKeywords.add(lastName.substring(0, j+1));
            }

            for (int k=0; k<emailKeyword.length; k++) {
              searchKeywords.add(emailKeyword.substring(0, k+1));
            }

            Map<String, dynamic> userDataMap = {
              "userName": displayName,
              "userEmail": email.toLowerCase(),
              "authors": [user.uid],
              "uid":user.uid,
              "searchKeywords":searchKeywords
            };

            databaseMethods.addUserInfo(user.uid, userDataMap);
            snackbar(
                context, "Successfully sign up. Please sign in.", _scaffoldKey);
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName("/RegisterPage"));
          });
        } catch (error) {
          snackbar(context, error.code.toString(), _scaffoldKey);
        }
      }
    }
  }
}

snackbar(
    BuildContext context, String text, GlobalKey<ScaffoldState> _scaffoldKey) {
  final snackBar = SnackBar(
    backgroundColor: Colors.black87,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    content: Text(
      '$text ',
      style: TextStyle(fontSize: 18),
    ),
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
