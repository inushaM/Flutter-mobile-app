import 'package:cloud_firestore/cloud_firestore.dart';

//Search service class
class SearchService {
  //Get Category
  searchByName(String searchField) {
    return Firestore.instance
        .collection('Categorys').getDocuments();
  }

  //Get Books
  searchBooks(String searchField){
    return Firestore.instance
        .collection('Books').getDocuments();
  }
}

class SearchCategory {
  //get All Category
  getAllCategory() {
    return Firestore.instance
        .collection('Categorys').getDocuments();
  }
}

//Search Category by string
class SearchCategoryString {
  //Create String category List
  List <String> getCategoryStringList() {
    List <String> dropDownList = ['All'];

    SearchCategory().getAllCategory().then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; ++i) {
        String nameNew = docs.documents[i].data['name'];
        dropDownList.add(nameNew);
        print(nameNew);
      }
      return dropDownList;
    });
    return dropDownList;
  }
}


