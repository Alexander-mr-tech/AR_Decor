import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'User Drawer/UserDrawer.dart';

class UserAddToCart extends StatefulWidget {
  final String? productId;
  final String? productName;

  const UserAddToCart({super.key, this.productId, this.productName});

  @override
  State<UserAddToCart> createState() => _UserAddToCartState();
}

class _UserAddToCartState extends State<UserAddToCart> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isProcessingOrder = false;
  String? processingProductId;

  /// ✅ Function to update quantity in Firestore
  Future<void> _updateQuantity(String docId, int currentQuantity, int change) async {
    int newQuantity = currentQuantity + change;
    if (newQuantity <= 0) {
      await FirebaseFirestore.instance.collection('Cart').doc(docId).delete();
    } else {
      await FirebaseFirestore.instance.collection('Cart').doc(docId).update({
        'quantity': newQuantity,
        'totalPrice': newQuantity * (await FirebaseFirestore.instance.collection('Cart').doc(docId).get()).data()?['price'],
      });
    }
  }

  /// ✅ Function to show popup & collect customer details before placing an order
  void _showOrderPopup(BuildContext context, QueryDocumentSnapshot cartItem) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Your Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Customer Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _buyNow(cartItem, nameController.text, addressController.text);
            },
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }

  /// ✅ Function to buy a **single** product and store total price + customer details
  Future<void> _buyNow(QueryDocumentSnapshot cartItem, String customerName, String address) async {
    if (customerName.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name and address!")),
      );
      return;
    }

    final data = cartItem.data() as Map<String, dynamic>;

    setState(() {
      processingProductId = cartItem.id;
    });

    try {
      final totalPrice = data['price'] * data['quantity'];

      // ✅ Prepare order details
      final orderDetails = {
        'userId': userId,
        'status': 'Pending',
        'productId': data['productId'],
        'imageUrl': data['image url'],
        'productName': data['productName'],
        'price': data['price'],
        'quantity': data['quantity'],
        'totalPrice': totalPrice, // ✅ Store correct total price
        'customerName': customerName, // ✅ Store Customer Name
        'address': address, // ✅ Store Address
        'orderDate': FieldValue.serverTimestamp(),
      };

      // ✅ Save order in Firestore
      await FirebaseFirestore.instance.collection('Orders').add(orderDetails);

      // ✅ Remove the purchased item from cart
      await cartItem.reference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully! Total: \$${totalPrice.toStringAsFixed(2)}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    } finally {
      setState(() {
        processingProductId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      drawer: const UserDrawer(),
      body: userId == null
          ? const Center(
        child: Text(
          "Please log in to view your cart.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Cart')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load cart items.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          final cartItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              final docId = cartItem.id;
              final productName = cartItem['productName'] ?? 'Unknown';
              final price = cartItem['price'] ?? 0.0;
              final imageUrl = cartItem['image url'] ?? '';
              final quantity = cartItem['quantity'] ?? 1;
              final totalPrice = price * quantity;

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // ✅ Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ✅ Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Item Price: \$${price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Quantity Controls
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _updateQuantity(docId, quantity, -1),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () => _updateQuantity(docId, quantity, 1),
                          ),
                        ],
                      ),

                      // ✅ Buy Now Button
                      ElevatedButton(
                        onPressed: processingProductId == cartItem.id
                            ? null
                            : () => _showOrderPopup(context, cartItem),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: processingProductId == cartItem.id
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Buy Now"),
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
