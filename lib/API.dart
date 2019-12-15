import 'package:cloud_firestore/cloud_firestore.dart';
import 'Models/Store.dart';

final databaseReference = Firestore.instance;


_getLocations() {
  databaseReference.collection("stores").getDocuments().then((snapshot) {
    return snapshot.documents
        .map<Store>(
            (document) => Store.fromMap(document.data, document.documentID))
        .toList();
  });
}