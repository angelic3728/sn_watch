import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Center(
            child: new Text(widget.title, style: TextStyle(fontSize: 24))),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              TextFormField(
                initialValue: 'John Doe',
                style: new TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                    enabled: false),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '+1 999-999-999',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Call',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(
                          Icons.phone,
                        ),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '+1 999-999-999',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'WhatsApp',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: new Image.asset(
                            "assets/images/whatsapp.png",
                            width: 10),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '+1 999-999-999',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'SMS',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(Icons.perm_phone_msg),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: 'test@email.com',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(Icons.email),
                        enabled: false),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: 'Ipsum app',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'skype',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: new Image.asset("assets/images/skype.png",
                            width: 10),
                        enabled: false),
                  )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: '95240 San Francisco',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Address',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(Icons.location_on_sharp),
                        enabled: false),
                  )),
                  Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: 'https://www.google.com',
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: 'Website',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        prefixIcon: Icon(Icons.public),
                        enabled: false),
                  )),
            ],
          )),
    );
  }
}
