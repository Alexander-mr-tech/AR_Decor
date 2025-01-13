import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Admin Drawer/AdminDrawer.dart';
class RejectedOrders extends StatelessWidget {
  const RejectedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rejected Orders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const AdminDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('status', isEqualTo: 'Rejected') // Fetch completed orders
            .orderBy('orderDate', descending: true) // Sort by date
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load order history.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No order history available.',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              // final orderId = order.id;
              final productName = order['productName'] ?? 'Unknown Product';
              final totalPrice = order['totalPrice'] ?? 0.0;
              final orderDate = order['orderDate']?.toDate();
              final customerName = order['customerName'] ?? 'Unknown Customer';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.blueGrey),
                  title: Text(
                    productName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: $customerName'),
                      Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                      Text(
                        'Date: ${orderDate != null ? orderDate.toString().split(' ')[0] : 'Unknown'}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
