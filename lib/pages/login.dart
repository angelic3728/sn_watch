import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sn_watch/helper/helperfunctions.dart';
import 'package:sn_watch/services/auth.dart';
import 'package:sn_watch/services/database.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;
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
                    height:
                        (mq.height - 50 - MediaQuery.of(context).padding.top),
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
                                  "Welcome,",
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
                                      "Sign in to continue!",
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
                            margin: EdgeInsets.only(top: 20),
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
                          margin: EdgeInsets.only(top: 55, bottom: 10),
                          child: isLoading
                              ? Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: CupertinoActivityIndicator(
                                    radius: 20,
                                  ))
                              : TextButton(
                                  child: Text(
                                    "LOGIN",
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
                                      bool isValid = await signin(
                                          email.text.toLowerCase(),
                                          password.text);
                                      if (isValid) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()),
                                            ModalRoute.withName("/LoginPage"));
                                      }
                                    }
                                  },
                                ),
                        ),
                        Container(
                          width: double.infinity,
                          child: new Image.asset("assets/images/or_border.png"),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue[700],
                          ),
                          margin: EdgeInsets.only(top: 10),
                          child: isLoading
                              ? Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                )
                              : TextButton(
                                  child: Container(
                                    width: mq.width * 0.8,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Image.asset(
                                          "assets/images/google-logo.png",
                                          height: 30,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "LOGIN WITH GOOGLE",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ))
                                      ],
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!isLoading) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      bool isValid = await signinWithGoogle();
                                      if (isValid) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()),
                                            ModalRoute.withName("/LoginPage"));
                                      }
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                        TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text(
                              "Sign Up",
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

  Future signin(String email, String password) async {
    if (email.trim().length == 0) {
      snackbar(context, 'Please type your email address.', _scaffoldKey);
      setState(() {
        isLoading = false;
      });
      return false;
    } else if (password.length < 6) {
      snackbar(context, 'Please type your correct password.', _scaffoldKey);
      setState(() {
        isLoading = false;
      });
      return false;
    } else {
      try {
        User user =
            await authService.signInWithEmailAndPassword(email, password);
        if (user == null) {
          snackbar(context, 'The user is not exist.', _scaffoldKey);
          setState(() {
            isLoading = false;
          });
          return false;
        } else {
          FocusScope.of(context).requestFocus(FocusNode());
          final displayName = user.displayName;
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUIDSharedPreference(user.uid);
          HelperFunctions.saveUserNameSharedPreference(displayName);
          HelperFunctions.saveUserEmailSharedPreference(email);
          snackbar(context, 'Logged in Successfully...', _scaffoldKey);
          setState(() {
            isLoading = false;
          });
          return true;
        }
      } catch (error) {
        snackbar(context, error.toString(), _scaffoldKey);
        setState(() {
          isLoading = false;
        });
        return false;
      }
    }
  }

  Future signinWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print(googleUser.email);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final email = googleUser.email;
      final uid = userCredential.user.uid;
      bool isEmpty = await databaseMethods.checkGoogleUser(email);
      print(isEmpty.toString());
      if (!isEmpty) {
        bool isTriedUser = await databaseMethods.isTriedUser(email, uid);
        if (!isTriedUser) {
          await databaseMethods.addGoogleUser(email, uid);
        }
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        snackbar(context, 'Logged in Successfully...', _scaffoldKey);
        setState(() {
          isLoading = false;
        });
        return true;
      } else {
        setState(() {
          isLoading = false;
        });
        snackbar(
            context,
            'The account is not registered yet. Please register first.',
            _scaffoldKey);
        authService.deleteUser();
        await GoogleSignIn().signOut();
        return false;
      }
    } catch (error) {
      print(error.toString());
      snackbar(context, error.toString(), _scaffoldKey);
      setState(() {
        isLoading = false;
      });
      return false;
    }
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
