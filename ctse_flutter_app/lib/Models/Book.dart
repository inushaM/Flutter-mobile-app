import 'package:cloud_firestore/cloud_firestore.dart';

//Book Class
class Book {
  String title;
  String author;
  String category;
  String description;
  String imageURL;
  String bookURL;
  DocumentReference reference;

  Book({this.title,this.author,this.category, this.description,this.imageURL,this.bookURL});

  Book.fromMap(Map<String, dynamic> map, {this.reference}) {
    title = map["title"];
    author = map["author"];
    category = map["category"];
    description = map["description"];
    imageURL = map["imageURL"];
    bookURL = map["bookURL"];
  }

  Book.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference:snapshot.reference);

  toJson() {
    return {'title':title,'author':author,'category':category,'description':description,'imageURL':imageURL,'bookURL':bookURL};
  }
}