import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Splash Screen/SplashScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Platform-specific options
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ar Decor Hub',
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}


