import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_firebase/auth/wrapper.dart';
import 'package:get/get.dart';
import 'package:project_firebase/puhsnotif/notif_api.dart';
import 'auth/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Firebase API atau notifikasi
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
