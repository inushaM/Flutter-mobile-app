import 'package:flutter/material.dart';
import 'package:ctse_flutter_app/Utils/Resources.dart';

//About page
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  //Inititate page name
  final String title = Resources.menu_list_name03;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(Resources.about,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(Resources.contact_us,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
