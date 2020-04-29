import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_flutter_app/Models/Category.dart';
import 'package:ctse_flutter_app/Models/Book.dart';
import 'package:ctse_flutter_app/pages/SearchService.dart';
import 'package:ctse_flutter_app/utils/Resources.dart';

//Add book page
class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => new _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {

  bool showTextField = false;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerAuthor = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController controllerImage = TextEditingController();
  TextEditingController controllerBook = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  String collectionName = "Books";
  bool isEditing = false;
  Book newBook;
  final String title = Resources.menu_list_name01;
  String dropdownValue = 'All';
  Category categoryObj = null;
  List <String> dropDownList = SearchCategoryString().getCategoryStringList();

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
                  controller: controllerTitle,
                  decoration: InputDecoration(
                      labelText: "Title", hintText: "Enter title"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controllerAuthor,
                  decoration: InputDecoration(
                    labelText: "Author",
                    hintText: "Enter author",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  minLines: 2,
                  maxLines: 5,
                  controller: controllerDescription,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    fillColor: Color(0xFFDBEDFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controllerImage,
                  decoration: InputDecoration(
                      labelText: "Image URL", hintText: "Enter Image URL"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controllerBook,
                  decoration: InputDecoration(
                      labelText: "Book URL", hintText: "Enter Book URL"),
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
                      setState(() {
                        categoryObj = Category(name: newValue);
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
                SizedBox(
                  height: 10,
                ),

                button(),
              ],
            )
                : Container(),
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

  //Book update and add buttons
  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(isEditing ? "UPDATE" : "ADD"),
        onPressed: () {
          add();
          setState(() {
            showTextField = false;
          });
        },
      ),
    );
  }

  //Add a new book function calling
  add() {
    if (isEditing) {
      update(
          newBook,
          controllerTitle.text,
          controllerAuthor.text,
          dropdownValue,
          controllerDescription.text,
          controllerImage.text,
          controllerBook.text);
      setState(() {
        isEditing = false;
      });
    } else {
      addBook();
    }
    controllerTitle.text = '';
    controllerAuthor.text = '';
    dropdownValue = 'All';
    controllerDescription.text = '';
    controllerImage.text = '';
    controllerBook.text = '';
  }

  //Show Category in a List
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

  //View Book List
  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);
    return Padding(
      key: ValueKey(book.title),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(book.title + "\n" + book.author),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //delete function calling
              delete(book);
            },
          ),
          onTap: () {
            //update function calling
            setUpdateUI(book);
          },
        ),
      ),
    );
  }

  setUpdateUI(Book book) {
    controllerTitle.text = book.title;
    controllerAuthor.text = book.author;
    dropdownValue = book.category;
    controllerDescription.text = book.description;
    controllerImage.text = book.imageURL;
    controllerBook.text = book.bookURL;
    setState(() {
      showTextField = true;
      isEditing = true;
      newBook = book;
    });
  }

  //get the book
  getCategorys() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  //Add the book
  addBook() {
    Book book = Book(title: controllerTitle.text,
        author: controllerAuthor.text,
        category: dropdownValue,
        description: controllerDescription.text,
        imageURL: controllerImage.text,
        bookURL: controllerBook.text);
    try {
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection(collectionName)
              .document()
              .setData(book.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //Update book
  update(Book user, String newTitle, String newAuthor, String newCategory,
      String newDescription, String newImageURL, String newBookURL) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(user.reference, {
          'title': newTitle,
          'author': newAuthor,
          'category': newCategory,
          'description': newDescription,
          'imageURL': newImageURL,
          'bookURL': newBookURL
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

//Delete book
  delete(Book book) {
    Firestore.instance.runTransaction(
          (Transaction transaction) async {
        await transaction.delete(book.reference);
      },
    );
  }
}
