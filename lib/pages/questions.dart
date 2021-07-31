import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sn_watch/helper/helperfunctions.dart';

class QuestionsPage extends StatefulWidget {
  QuestionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<QuestionsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSending = false;

  var firstName;
  var lastName;
  var email;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var commentController = TextEditingController();

  getUserInfo() async {
    var fullName = await HelperFunctions.getUserNameSharedPreference();
    var userEmail = await HelperFunctions.getUserEmailSharedPreference();
    firstNameController.text = fullName.split(" ")[0];
    lastNameController.text = fullName.split(" ")[1];
    emailController.text = userEmail;
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {
            FocusScope.of(context).requestFocus(FocusNode()),
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pop();
            })
          },
        ),
        title: new Center(
            child: new Text(widget.title, style: TextStyle(fontSize: 20))),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 30, right: 30),
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 40),
                  child: TextFormField(
                    controller: firstNameController,
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    controller: lastNameController,
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    controller: emailController,
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[500], width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Comments',
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                  )),
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 50),
                child: isSending
                    ? Container(
                        decoration: new BoxDecoration(
                            color: Colors.amber[900],
                            borderRadius: new BorderRadius.circular(18.0)),
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ))
                    : TextButton(
                        child: Text("Submit".toUpperCase(),
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.amber[900]),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15.0)))),
                        onPressed: () async => {
                              if (commentController.text.trim().length != 0)
                                {
                                  setState(() {
                                    isSending = true;
                                  }),
                                  await sendEmail(
                                      context,
                                      _scaffoldKey,
                                      firstNameController.text +
                                          " " +
                                          lastNameController.text,
                                      emailController.text,
                                      commentController.text)
                                }
                              else
                                snackbar(
                                    context,
                                    "Please type the comment first.",
                                    _scaffoldKey)
                            }),
              )
            ],
          )),
    );
  }

  Future<dynamic> sendEmail(
      BuildContext context,
      GlobalKey<ScaffoldState> _scaffoldKey,
      String name,
      String email,
      String comment) async {
    Map<String, String> requestHeaders = <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "x-rapidapi-host": "email-sender1.p.rapidapi.com",
      "x-rapidapi-key": "b67ed144bemsh5d3dfeae0d7c5d5p10faddjsne34b1f4b5e0f",
    };

    var content =
        '''<div style="width:85%; float:left; padding:15px 5px; border:1px solid gray; border-radius:5px; text-align:center; margin:10px 7.5%;"><img style="width:80px;" src="https://gridsquare-bucket.s3.us-east-2.amazonaws.com/model_1625664396500.png" + '" />
         <h2>Questions/Requests</h2>
         <h3 style="text-align:left">Name : ''' +
            name +
            '''</h4>
         <h3 style="text-align:left">Email : ''' +
            email +
            '''</h3>
         <pre style="text-align:center">''' +
            comment +
            '''</pre>
         <div style="float:left; width:100%;">
         </div></div>''';

    Map<String, String> requestParams = <String, String>{
      "txt_msg": '',
      "to": "deliahamlet@gmail.com",
      "from": "SN-Watch noreply",
      "subject": "Summit Neighborhood Watch",
      "html_msg": content
    };

    final uri = Uri.https('email-sender1.p.rapidapi.com', '/', requestParams);
    try {
      http.Response response = await http.post(
        uri,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        setState(() {
          isSending = false;
        });
        snackbar(context, "Successfully sent.", _scaffoldKey);
      } else {
        setState(() {
          isSending = false;
        });
        snackbar(context, "Error occured.", _scaffoldKey);
      }
    } catch (error) {
      setState(() {
        isSending = false;
      });
      snackbar(context, "Error occured.", _scaffoldKey);
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
