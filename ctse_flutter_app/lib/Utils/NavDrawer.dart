import 'package:flutter/material.dart';
import 'package:ctse_flutter_app/pages/CategoryService.dart';
import 'package:ctse_flutter_app/pages/BookService.dart';
import 'package:ctse_flutter_app/Pages/About.dart';
import 'package:ctse_flutter_app/Utils/Resources.dart';

//Navigation Bar
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
            Resources.menu_name,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.orange,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('images/side-menu-image.jpg'))
            ),
          ),
          ListTile( //Add book
            leading: Icon(Icons.library_books),
            title: Text(Resources.menu_list_name01),
            onTap: () => {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBookPage()),
              )
            },
          ),
          ListTile( // Add category
            leading: Icon(Icons.clear_all),
            title: Text(Resources.menu_list_name02),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              )
            },
          ),
          ListTile( // About us
            leading: Icon(Icons.error_outline),
            title: Text(Resources.menu_list_name03),
            onTap: () => {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
              )
            },
          ),
        ],
      ),
    );
  }
}
