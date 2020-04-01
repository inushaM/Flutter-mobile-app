import 'package:flutter/material.dart';
import 'package:ctse_flutter_app/CategoryService.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('images/side-menu-image.jpg'))
            ),
          ),
          ListTile(
          leading: Icon(Icons.library_books),
          title: Text('Add Books'),
          onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.clear_all),
            title: Text('Add Category'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              )
            },
          ),
        ],
      ),
    );
  }
}

//    ListTile(
//    leading: Icon(Icons.settings),
//    title: Text('Settings'),
//    onTap: (){
//    Navigator.of(context).pop();
//    Navigator.push(
//    context,
//    new MaterialPageRoute(
//    builder: (BuildContext context) => new AboutPage()));
//
//    },
//    ),