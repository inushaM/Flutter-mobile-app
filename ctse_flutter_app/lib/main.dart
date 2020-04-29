import 'package:flutter/material.dart';
import 'package:ctse_flutter_app/utils/NavDrawer.dart';
import 'package:ctse_flutter_app/pages/SearchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ctse_flutter_app/pages/SplashScreen.dart';
import 'package:ctse_flutter_app/Utils/Resources.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Reading App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: SplashScreen(), // call splash screen
      routes: <String, WidgetBuilder>{ // navigate to home page
        "/home": (BuildContext context) => MyHomePage(title: Resources.title),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController searchController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  String dropdownValue = 'All';
  List <String> dropDownList = [];

  //First run this method when application started
  @override
  void initState() {
//    super.initState();
    setState(() {
      tempSearchStore = [];
      queryResultSet = [];
      dropDownList = SearchCategoryString().getCategoryStringList();
    });

    // create a deadLock --- Initially run below code
    var lock = Lock();
    lock.synchronized(() async {
      var i = 0;
      SearchService().searchBooks('All').then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(
              docs.documents[i].data); //add all category values to a list
        }
        //compare equal value
        queryResultSet.forEach((element) {
          setState(() {
            tempSearchStore.add(element);
            i++;
            print('--- add books to the  list ----');
          });
        });
      });

      //if the have no match value, list should be empty
      if (i == 0) {
        setState(() {
          tempSearchStore = [];
        });
      }
    }); //deadLock End
  } //initState Method End

//----------------------------------------------------------------------

  //Book Search Method --- START
  initiateSearch(value, flag) {
    print('inside-----------------------');
    print(value);

    var capitalizedValue;
    if (value.length > 0) {
      //Firat letter capitalized
      capitalizedValue = value.substring(0, 1).toUpperCase() +
          value.substring(1);
    }

    var i = 0;
    if (value == 'All' || value.length == 0) {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        setState(() {
          tempSearchStore.add(element);
          i++;
        });
      });
    } else if (queryResultSet.length > 0 && flag == 'DROP_DOWN') {
      tempSearchStore = [];
      //compare equal value
      queryResultSet.forEach((element) {
        if (element['category'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            i++;
          });
        }
      });
    } else if (queryResultSet.length > 0 && flag == 'SERCH_BAR') {
      tempSearchStore = [];
      //compare equal value
      queryResultSet.forEach((element) {
        if (element['title'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            i++;
          });
        }
      });
    }

    if (i == 0) {
      setState(() {
        tempSearchStore = [];
      });
    }
  }

  //Book Search Method --- END
//----------------------------------------------------------------------
  //View home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(children: <Widget>[
          Padding( // Search filed
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                tempSearchStore = [];
                initiateSearch(val, "SERCH_BAR");
                setState(() {
                  dropdownValue = 'All';
                });
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.cancel),
                  iconSize: 20.0,
                  onPressed: () {
                    searchController.text = '';
                    initState();
                    setState(() {
                      dropdownValue = 'All';
                    });
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by book title',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding( //DropDown search button
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              hint: Text("Select a category"),
              isExpanded: true,
              value: dropdownValue,
              underline: Container(
                height: 2,
                width: 100,
                color: Colors.orange,
              ),
              onChanged: (String newValue) {
                print(newValue);
                initiateSearch(newValue, "DROP_DOWN");
                searchController.text = '';
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: dropDownList.map<DropdownMenuItem<String>>((
                  String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(category,
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          ListView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList()
          ),
        ]));
  }
}


// building view Cards and card details
Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                data['imageURL'],
                height: 200.0,
              ),
              SizedBox(width: 10.0),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                          constraints: BoxConstraints(maxWidth: 230),
                          child: Text(
                            (data['title'] == null) ? " " : 'Title  - ' +
                                data['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                fontSize: 12.0),
                          )
                      ),
                      SizedBox(height: 5.0),
                      Container(
                          constraints: BoxConstraints(maxWidth: 230),
                          child: Text(
                            (data['author'] == null) ? " " : 'Author  - ' +
                                data['author'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                fontSize: 12.0),
                          )
                      ),
                      SizedBox(height: 5.0),
                      Container(
                          constraints: BoxConstraints(maxWidth: 230),
                          child: Text(
                            (data['category'] == null) ? " " : 'Category  - ' +
                                data['category'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                fontSize: 12.0),
                          )
                      ),
                      SizedBox(height: 15.0),
                      Container(
                          constraints: BoxConstraints(maxWidth: 230),
                          child: Text(
                            (data['description'] == null)
                                ? " "
                                : data['description'],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                fontSize: 12.0),
                          )
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('View Book'),
                            onPressed: () => _launchURL(data['bookURL']),
                          ),
                        ],
                      ),
                    ]
                ),
              )
            ]
        ),

      )
  );
}
//URL Launch method
_launchURL(newURL) async {
  String url = newURL;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}



