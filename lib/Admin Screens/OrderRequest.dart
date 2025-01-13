// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'Admin Drawer/AdminDrawer.dart';
//
// class ManageOrdersScreen extends StatelessWidget {
//   Future<void> updateOrderStatus(String orderId, String status) async {
//     await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
//       'status': status,
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Manage Orders',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       drawer: const AdminDrawer(),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.lightBlueAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               );
//             }
//
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                   'Failed to load orders.',
//                   style: TextStyle(fontSize: 18, color: Colors.red),
//                 ),
//               );
//             }
//
//             final orders = snapshot.data?.docs ?? [];
//
//             if (orders.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No orders available.',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final orderId = order.id;
//                 final itemName = order['productName'] ?? 'Unknown';
//                 final quantity = order['quantity'] ?? 0;
//                 final imageUrl = order['imageUrl'] ?? '';
//                 final price = order['totalPrice'] ?? 0.0;
//                 final username = order['customerName'] ?? 'Unknown';
//                 final status = order['status'] ?? 'Pending';
//                 final address = order['address'] ?? 'No address provided';
//                 final orderDate = order['orderDate']?.toDate();
//                 final email = order['userEmail'] ?? 'No email provided';
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Product Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             imageUrl,
//                             height: 100,
//                             width: 100,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) => const Icon(
//                               Icons.broken_image,
//                               size: 100,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//
//                         // Order Details
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Item Name
//                               Text(
//                                 itemName,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//
//                               // User Info and Quantity
//                               Text(
//                                 'Customer: $username',
//                                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//                               ),
//                               Text(
//                                 'Quantity: $quantity',
//                                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//                               ),
//                               const SizedBox(height: 6),
//
//                               // Total Price
//                               Text(
//                                 'Total: \$${price.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//
//                               // Address
//                               Text(
//                                 'Address: $address',
//                                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//                               ),
//                               const SizedBox(height: 6),
//
//                               // Order Date
//                               Text(
//                                 'Order Date: ${orderDate != null ? orderDate.toString().split(' ')[0] : 'Unknown'}',
//                                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//                               ),
//                               const SizedBox(height: 6),
//
//                               // Status
//                               Row(
//                                 children: [
//                                   const Text(
//                                     'Status:',
//                                     style: TextStyle(fontSize: 14, color: Colors.black87),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: status == 'Accepted'
//                                           ? Colors.green
//                                           : status == 'Rejected'
//                                           ? Colors.red
//                                           : status == 'Completed'
//                                           ? Colors.blue
//                                           : Colors.orange,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Text(
//                                       status,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//
//                               // Action Buttons
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed: () => updateOrderStatus(orderId, 'Accepted'),
//                                     icon: const Icon(Icons.check, size: 16),
//                                     label: const Text('Accept'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   ElevatedButton.icon(
//                                     onPressed: () => updateOrderStatus(orderId, 'Rejected'),
//                                     icon: const Icon(Icons.close, size: 16),
//                                     label: const Text('Reject'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   ElevatedButton.icon(
//                                     onPressed: () => updateOrderStatus(orderId, 'Completed'),
//                                     icon: const Icon(Icons.close, size: 16),
//                                     label: const Text('Completed'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Admin Drawer/AdminDrawer.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  Future<void> updateOrderStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Orders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const AdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Failed to load orders.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            }

            final orders = snapshot.data?.docs ?? [];

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  'No orders available.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderId = order.id;
                final itemName = order['productName'] ?? 'Unknown';
                final quantity = order['quantity'] ?? 0;
                final imageUrl = order['imageUrl'] ?? '';
                final price = order['totalPrice'] ?? 0.0;
                final username = order['customerName'] ?? 'Unknown';
                final status = order['status'] ?? 'Pending';
                final address = order['address'] ?? 'No address provided';
                final orderDate = order['orderDate']?.toDate();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Order Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Item Name
                                  Text(
                                    itemName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Customer Info
                                  Text(
                                    'Customer: $username',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Quantity: $quantity',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Total Price
                                  Text(
                                    'Total: \$${price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Address
                                  Text(
                                    'Address: $address',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Order Date
                                  Text(
                                    'Order Date: ${orderDate != null ? orderDate.toString().split(' ')[0] : 'Unknown'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Status
                                  Row(
                                    children: [
                                      const Text(
                                        'Status:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: status == 'Accepted'
                                              ? Colors.green
                                              : status == 'Rejected'
                                              ? Colors.red
                                              : status == 'Completed'
                                              ? Colors.blue
                                              : Colors.orange,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          status,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  updateOrderStatus(orderId, 'Accepted'),
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  updateOrderStatus(orderId, 'Rejected'),
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  updateOrderStatus(orderId, 'Completed'),
                              icon: const Icon(Icons.done_all, size: 16),
                              label: const Text('Complete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
