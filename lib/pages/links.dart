import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksPage extends StatefulWidget {
  LinksPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LinksPageState createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  Container _buildButtonColumn(
      BuildContext context, Color color, String imgUrl, String label, flag) {
    final mq = MediaQuery.of(context).size;
    double itemWidth = mq.width * 0.4;

    return Container(
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
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Image.asset(
                imgUrl,
                width: mq.width * 0.25,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text(label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          onTap: () => {
            if (flag == 1)
              _launchPolice()
            else if (flag == 2)
              _launchNixle()
            else if (flag == 3)
              _launchCamera()
            else if (flag == 4)
              _launchOpra()
          },
        ));
  }

  _launchPolice() async {
    const url = 'https://www.cityofsummit.org/231/Police-Department';
    await launch(url);
  }

  _launchNixle() async {
    const url = 'https://www.nixle.com';
    await launch(url);
  }

  _launchCamera() async {
    const url =
        'https://docs.google.com/forms/d/e/1FAIpQLSdnVAcJygUn5gyd-EkMTJ-JQkgcY_hk0ZHTU0AG3N_fxptbMg/viewform';
    await launch(url);
  }

  _launchOpra() async {
    const url =
        'https://main.govpilot.com/web/public/b256d2d4-e6a.html?id=1&uid=6897&pu=1&ust=NJ';
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    Color color = Colors.yellow[900];
    Widget buttonSection1 = Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              context, color, "assets/images/police_icon.png", 'Police', 1),
          _buildButtonColumn(
              context, color, "assets/images/nixle_icon.png", 'Nixle', 2),
        ],
      ),
    );

    Widget buttonSection2 = Container(
      padding: EdgeInsets.only(top: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(context, color, "assets/images/cameraReg_icon.png",
              'CAMERA Reg', 3),
          _buildButtonColumn(
              context, color, "assets/images/opra_icon.png", 'OPRA', 4),
        ],
      ),
    );

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
        title: new Center(
            child: new Text(widget.title, style: TextStyle(fontSize: 24))),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: (mq.width > mq.height)
            ? ListView(children: [buttonSection1, buttonSection2])
            : Column(
                children: [buttonSection1, buttonSection2],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
      ),
    );
  }
}
