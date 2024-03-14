import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialswap/components/io.dart';
import 'package:socialswap/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Swap",
      debugShowCheckedModeBanner: false,
      home: IO(),
    );
  }
}
