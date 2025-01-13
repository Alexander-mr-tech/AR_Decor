import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Signin_Screen.dart';
import '../AddtoCart.dart';
import '../UserDashboard.dart';
import '../UserOrderHistory.dart';
import '../UserViewProducts.dart';
import '../ViewOrder.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String userEmail = user.email.toString(); // Initialize userEmail here

    return Drawer(
      child: Container(
        // Apply gradient to the entire drawer
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurpleAccent,
              Colors.cyan,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context, userEmail),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String userEmail) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepPurpleAccent,
          Colors.cyan,
        ],
      ),
    ),
    width: double.infinity,
    padding: EdgeInsets.only(
      top: 10 + MediaQuery.of(context).padding.top,
      bottom: 10,
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blue,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 57,
            child: Icon(
              Icons.person,
              size: 100,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "AR Decor Hub",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    ),
  );

  Widget buildMenuItems(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserDashboard()),
            );
          },
        ),
        const Divider(color: Colors.blue, thickness: 2),
        ListTile(
          leading: const Icon(Icons.add_shopping_cart),
          title: const Text('View Products'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserViewProducts()),
            );
          },
        ),
        const Divider(color: Colors.blue, thickness: 2),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('View Orders'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  const UserViewOrders()),
            );
          },
        ),
        const Divider(color: Colors.blue, thickness: 2),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Add to Cart'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserAddToCart()),
            );
          },
        ),
        const Divider(color: Colors.blue, thickness: 2),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Order History'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserOrderHistory()),
            );
          },
        ),
        const Divider(color: Colors.blue, thickness: 2),
        ListTile(
          leading: const Icon(Icons.assignment_late_outlined),
          title: const Text('Sign Out'),
          onTap: () {
            widget.signOut(context); // Correctly call the signOut method
          },
        ),
      ],
    ),
  );
}
