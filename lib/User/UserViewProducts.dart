import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddtoCart.dart';
import 'ProductDetails.dart';
import 'User Drawer/UserDrawer.dart';

class UserViewProducts extends StatefulWidget {
  const UserViewProducts({super.key});

  @override
  _UserViewProductsState createState() => _UserViewProductsState();
}

class _UserViewProductsState extends State<UserViewProducts> {
  String searchQuery = '';

  /// ✅ Function to navigate to the product details screen
  void viewDetails(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    );
  }

  /// ✅ Function to add a product to the cart
  Future<void> addToCart(Map<String, dynamic> product, String productId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to the cart.')),
      );
      return;
    }

    try {
      final cartCollection = FirebaseFirestore.instance.collection('Cart');
      final existingItem = await cartCollection
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (existingItem.docs.isNotEmpty) {
        // ✅ Update quantity if product already exists in cart
        final docId = existingItem.docs.first.id;
        final currentQuantity = existingItem.docs.first['quantity'] ?? 1;
        await cartCollection.doc(docId).update({'quantity': currentQuantity + 1});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product quantity updated in cart!')),
        );
      } else {
        // ✅ Add new product to the cart
        await cartCollection.add({
          'userId': userId,
          'productId': productId,
          'productName': product['item name'] ?? product['productName'] ?? 'Unknown',
          'price': product['price'],
          'image url': product['image url'],
          'quantity': 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart successfully!')),
        );
      }

      // ✅ Navigate to Cart Screen with Product Details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAddToCart(
            productId: productId,
            productName: product['productName'] ?? 'Unknown',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Products',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAddToCart()),
              );
            },
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // ✅ Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by product name or description',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Product List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading products.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products available.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final products = snapshot.data!.docs.where((product) {
                    final name = product['item name']?.toString().toLowerCase() ?? '';
                    final description = product['description']?.toString().toLowerCase() ?? '';
                    return name.contains(searchQuery) || description.contains(searchQuery);
                  }).toList();

                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products match your search.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final productDoc = products[index];
                      final productId = productDoc.id;
                      final product = productDoc.data() as Map<String, dynamic>;
                      final imageUrl = product['image url'] ?? 'Unknown';
                      final name = product['item name'] ?? 'Unknown';
                      final price = product['price'] ?? 0.0;
                      final description = product['description'] ?? 'No description';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Image Section
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // ✅ Content Section
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Price: \$${price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // ✅ Button Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => viewDetails(productId),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                                    child: const Text('View Details'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => addToCart(product, productId),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    child: const Text('Add to Cart'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
