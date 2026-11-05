import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id; // Firestore document id
  final String name;
  final int quantity;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  // Object -> Firestore document fields
  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      };

  // Firestore document -> object
  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Product(
      id: doc.id,
      name: (d['name'] ?? '') as String,
      quantity: (d['quantity'] ?? 0) as int,
      price: ((d['price'] ?? 0) as num).toDouble(),
    );
  }
}
