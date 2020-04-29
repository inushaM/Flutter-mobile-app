import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_flutter_app/Models/Category.dart';
import 'package:ctse_flutter_app/utils/Resources.dart';

//Add category page
class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => new _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  bool showTextField = false;
  TextEditingController controller = TextEditingController();
  String collectionName = "Categorys";
  bool isEditing = false;
  Category newCategory;
  final String title = Resources.menu_list_name02;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              setState(() {
                showTextField = !showTextField;
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showTextField
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: "Category", hintText: "Enter category"),
                ),
                SizedBox(
                  height: 10,
                ),
                button(),
              ],
            )
                :Container(),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            ),
          ],
        ),
      ),
    );
  }

  //Category add and update buttons
  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(isEditing ? "UPDATE" : "ADD"),
        onPressed: (){
          add();
          setState(() {
            showTextField = false;
          });
        },
      ),
    );
  }

  //Add category function calling
  add() {
    if (isEditing) {
      update(newCategory, controller.text);
      setState(() {
        isEditing = false;
      });
    } else {
      addCategory();
    }
    controller.text = '';
  }

  //Show Category in a List
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: getCategorys(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  //view category list
  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final category = Category.fromSnapshot(data);
    return Padding(
      key: ValueKey(category.name),
      padding:EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(category.name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //delete function calling
              delete(category);
            },
          ),
          onTap: () {
            //update function calling
            setUpdateUI(category);
          },
        ),
      ),
    );
  }

  setUpdateUI(Category category) {
    controller.text = category.name;
    setState(() {
      showTextField = true;
      isEditing = true;
      newCategory = category;
    });
  }

  //get the documents
  getCategorys() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  //Add the Category
  addCategory() {
    Category category = Category(name: controller.text);
    try {
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection(collectionName)
              .document()
              .setData(category.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //Update Category
  update(Category user, String newName) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(user.reference, {'name': newName});
      });
    } catch (e) {
      print(e.toString());
    }
  }

//Delete Category
  delete(Category user) {
    Firestore.instance.runTransaction(
          (Transaction transaction) async {
        await transaction.delete(user.reference);
      },
    );
  }
}
