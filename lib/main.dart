import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_firebase/sign/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Tambahkan GetX di sini
import 'sign/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Ganti dengan GetMaterialApp agar navigasi GetX berfungsi
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}
