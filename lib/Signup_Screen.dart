import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Signin_Screen.dart';
import 'Widget/Button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // ✅ Form Key for validation
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _selectedRole = 'User'; // Default role
  final _roles = ['User', 'Admin']; // Available roles
  bool _isLoading = false;
  bool _passwordVisible = false; // ✅ Password visibility toggle
  bool _confirmPasswordVisible = false; // ✅ Confirm Password visibility toggle

  // ✅ Email Validation Function
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    return emailRegex.hasMatch(email);
  }

  // ✅ Password Validation Function (Only alphabets & numbers, minimum 8 characters)
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // Future<void> _signUp() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   final name = _nameController.text.trim();
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text.trim();
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     // ✅ Create user with Firebase Auth
  //     UserCredential userCredential =
  //     await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     // ✅ Store user details in Firestore
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set({
  //       'name': name,
  //       'email': email,
  //       'role': _selectedRole,
  //     });
  //
  //     // ✅ Success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Account created successfully as $_selectedRole!')),
  //     );
  //
  //     // ✅ Navigate to the Sign-In screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Signin()),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage;
  //
  //     // ✅ Handle Firebase authentication errors
  //     if (e.code == 'email-already-in-use') {
  //       errorMessage = 'This email is already registered. Please use another email.';
  //     } else if (e.code == 'invalid-email') {
  //       errorMessage = 'The email address entered is not valid.';
  //     } else if (e.code == 'weak-password') {
  //       errorMessage = 'The password is too weak. Use at least 8 characters with letters and numbers.';
  //     } else {
  //       errorMessage = 'An unexpected error occurred: ${e.message}';
  //     }
  //
  //     // ❌ Show actual Firebase error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage)),
  //     );
  //   } catch (e) {
  //     // ❌ Catch any other unexpected errors
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Unexpected error: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Create user with Firebase Auth
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Store user details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'role': _selectedRole,
      });

      // ✅ Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully as $_selectedRole!')),
      );

      // ✅ Navigate to the Sign-In screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // ✅ Handle Firebase authentication errors
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered. Please use another email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address entered is not valid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak. Use at least 8 characters with letters and numbers.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.message}';
      }

      // ❌ Show actual Firebase error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // ❌ Catch any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Splash.jpg'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.black26],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey, // ✅ Wrap with Form widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.home_outlined,
                        size: 50,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Text(
                      "AR Decor Hub",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Create New Account".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),

                    // ✅ Name Input Field
                    _buildTextField(_nameController, 'Enter your name', Icons.person, (value) {
                      return value!.trim().isEmpty ? 'Name is required' : null;
                    }),

                    // ✅ Email Input Field
                    _buildTextField(_emailController, 'Enter your email', Icons.email, (value) {
                      return !isValidEmail(value!) ? 'Enter a valid email address' : null;
                    }),

                    // ✅ Password Input Field with Validation and Visibility Toggle
                    _buildPasswordField(_passwordController, 'Enter your Password', _passwordVisible, () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    }, (value) {
                      return !isValidPassword(value!)
                          ? 'Password must be at least 8 characters & contain only letters/numbers'
                          : null;
                    }),

                    // ✅ Confirm Password Input Field with Validation and Visibility Toggle
                    _buildPasswordField(_confirmPasswordController, 'Confirm Password', _confirmPasswordVisible, () {
                      setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                    }, (value) {
                      return value != _passwordController.text ? 'Passwords do not match' : null;
                    }),

                    // Role Dropdown
                    DropdownButtonFormField(
                      value: _selectedRole,
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    RoundButton(
                        loading: _isLoading,
                        title: "Sign Up",
                        onTap: _signUp),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Signin()),
                      ),
                      child: const Text('Already have an account? Sign In',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Helper function to build text input fields
  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon, String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        validator: validator,
      ),
    );
  }

  // ✅ Helper function to build password fields with validation and visibility toggle
  Widget _buildPasswordField(
      TextEditingController controller, String hintText, bool isVisible, VoidCallback toggleVisibility,
      [String? Function(String?)? validator]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        validator: validator,
      ),
    );
  }
}
