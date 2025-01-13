import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Admin Screens/AdminDashboard.dart';
import '../Signin_Screen.dart';
import '../User/UserDashboard.dart';

class SplashServices {
  /// Checks if a user is already signed in.
  Future<bool> isUserSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null; // Returns true if user is logged in, false otherwise.
  }

  /// Handles login and role-based navigation.
  void isLogin(BuildContext context) async {
    bool signedIn = await isUserSignedIn();

    if (signedIn) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Check if the user is an admin.
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot adminSnapshot) {
          if (adminSnapshot.exists && adminSnapshot.get('role') == "Admin") {
            // Navigate to AdminDashboard if the role is "Admin".
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ),
            );
          } else {
            // Check if the user is a student in the Users collection.
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get()
                .then((DocumentSnapshot studentSnapshot) {
              if (studentSnapshot.exists &&
                  studentSnapshot.get('role') == "User") {
                // Navigate to UserDashboard if the role is "Student".
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserDashboard(),
                  ),
                );
              } else {
                // If no role matches, navigate to the Signin screen.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Signin(),
                  ),
                );
              }
            }).catchError((error) {
              // Handle errors for Users query.
              print("User Error: $error");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Signin(),
                ),
              );
            });
          }
        }).catchError((error) {
          // Handle errors for Admins query.
          print("Admin Error: $error");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Signin(),
            ),
          );
        });
      }
    } else {
      // If user is not signed in, navigate to the Signin screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Signin(),
        ),
      );
    }
  }
}
