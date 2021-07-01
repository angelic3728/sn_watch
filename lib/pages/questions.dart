import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  QuestionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Center(
            child: new Text(widget.title, style: TextStyle(fontSize: 20))),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20, right: 20),
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        enabled: true),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        enabled: true),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        enabled: true),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
                        enabled: true),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: TextFormField(
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.phone_android,
                        ),
                        enabled: true),
                  )),
              TextField(
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
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: TextButton(
                    child: Text("Submit".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () => null),
              )
            ],
          )),
    );
  }
}
