import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'User Drawer/UserDrawer.dart';

class UserAddToCart extends StatefulWidget {
  const UserAddToCart({super.key});

  @override
  State<UserAddToCart> createState() => _UserAddToCartState();
}

class _UserAddToCartState extends State<UserAddToCart> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isProcessingOrder = false;

  Future<void> placeOrder(List<QueryDocumentSnapshot> cartItems) async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty.")),
      );
      return;
    }

    setState(() {
      isProcessingOrder = true;
    });

    try {
      // Create an order
      final orderItems = cartItems.map((item) {
        final data = item.data() as Map<String, dynamic>;
        return {
          'productId': data['productId'],
          'item name': data['item name'],
          'price': data['price'],
          'quantity': 1, // Assuming 1 for simplicity; you can extend this.
        };
      }).toList();

      final orderTotal = orderItems.fold<double>(
        0.0,
            (sum, item) => sum + (item['price'] as double),
      );

      await FirebaseFirestore.instance.collection('Orders').add({
        'userId': userId,
        'items': orderItems,
        'totalPrice': orderTotal,
        'orderDate': FieldValue.serverTimestamp(),
      });

      // Clear the cart
      for (var item in cartItems) {
        await item.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    } finally {
      setState(() {
        isProcessingOrder = false;
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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final productName = cartItem['item name'] ?? 'Unknown';
                    final price = cartItem['price'] ?? 0.0;
                    final imageUrl = cartItem['image url'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Price: \$${price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await cartItem.reference.delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Item removed from cart."),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: isProcessingOrder
                      ? null
                      : () => placeOrder(cartItems),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: Colors.indigo,
                  ),
                  child: isProcessingOrder
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
