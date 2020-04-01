import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  DocumentReference reference;

  Category({this.name});

  Category.fromMap(Map<String, dynamic> map, {this.reference}) {
    name = map["name"];
  }

  Category.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference:snapshot.reference);

  toJson() {
    return {'name':name};
  }
}