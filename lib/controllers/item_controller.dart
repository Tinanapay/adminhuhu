import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getItems(bool isLibrary) {
    final collection = isLibrary ? 'library' : 'catalog';
    return _firestore.collection(collection).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => {
        'id': doc.id,
        'item': Item(
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
        ),
      }).toList());
  }

  Future<void> addItem(bool isLibrary, Item item) {
    final collection = isLibrary ? 'library' : 'catalog';
    return _firestore.collection(collection).add({
      'name': item.name,
      'description': item.description,
    });
  }

  Future<void> updateItem(bool isLibrary, String docId, Item item) {
    final collection = isLibrary ? 'library' : 'catalog';
    return _firestore.collection(collection).doc(docId).update({
      'name': item.name,
      'description': item.description,
    });
  }

  Future<void> deleteItem(bool isLibrary, String docId) {
    final collection = isLibrary ? 'library' : 'catalog';
    return _firestore.collection(collection).doc(docId).delete();
  }
}
