import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/firestore_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _name = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _service = FirestoreService.instance;

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final qty = int.tryParse(_qty.text.trim());
    final price = double.tryParse(_price.text.trim());

    if (name.isEmpty || qty == null || price == null || qty < 0 || price < 0) {
      _msg('Enter a valid name, quantity and price');
      return;
    }

    try {
      await _service.addProduct(Product(name: name, quantity: qty, price: price));
      _name.clear();
      _qty.clear();
      _price.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (e) {
      _msg('Could not save: $e');
    }
  }

  Future<void> _delete(Product p) async {
    try {
      await _service.deleteProduct(p.id!);
    } catch (e) {
      _msg('Could not delete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Inventory Tracker'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Enter Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _qty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _price,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Enter Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(onPressed: _save, child: const Text('Save Product')),
              ],
            ),
          ),
          Expanded(
            // Real-time list + total, rebuilt whenever Firestore data changes
            child: StreamBuilder<List<Product>>(
              stream: _service.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Firestore error:\n${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!;
                final total =
                    products.fold(0.0, (sum, p) => sum + p.quantity * p.price);

                return Column(
                  children: [
                    Expanded(
                      child: products.isEmpty
                          ? const Center(child: Text('No products yet'))
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, i) {
                                final p = products[i];
                                final low = p.quantity < 5;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(p.name.isEmpty
                                        ? '?'
                                        : p.name[0].toUpperCase()),
                                  ),
                                  title: Text(p.name),
                                  subtitle: Text(
                                      'Qty: ${p.quantity}  |  Price: ₹${p.price.toStringAsFixed(2)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (low)
                                        const Text(
                                          'Low Stock!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _delete(p),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.deepPurple.shade50,
                      padding: const EdgeInsets.all(16),
                      child: SafeArea(
                        top: false,
                        child: Text(
                          'Total Stock Value: ₹${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
