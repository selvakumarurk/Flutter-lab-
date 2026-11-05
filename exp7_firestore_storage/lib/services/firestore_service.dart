import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  // Collection: products
  final CollectionReference<Map<String, dynamic>> _products =
      FirebaseFirestore.instance.collection('products');

  // CREATE
  Future<void> addProduct(Product p) => _products.add(p.toMap());

  // READ (real-time stream)
  Stream<List<Product>> getProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Product.fromDoc).toList());
  }

  // UPDATE
  Future<void> updateProduct(String id, {String? name, int? quantity, double? price}) {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (quantity != null) data['quantity'] = quantity;
    if (price != null) data['price'] = price;
    return _products.doc(id).update(data);
  }

  // DELETE
  Future<void> deleteProduct(String id) => _products.doc(id).delete();
}
