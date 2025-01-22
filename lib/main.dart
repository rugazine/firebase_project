import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_firebase/pages/auth/wrapper.dart';
import 'package:get/get.dart';
import 'package:project_firebase/puhsnotif/notif_api.dart';
import 'pages/auth/firebase_options.dart';
import 'pages/auth/login.dart'; // Impor halaman login
import 'pages/expense/view/expense_page.dart'; // Impor halaman expense
import 'bindings/expense_binding.dart'; // Impor binding

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
      initialRoute: '/', // Rute awal
      getPages: [
        GetPage(name: '/', page: () => const Wrapper()), // Rute untuk Wrapper
        GetPage(name: '/login', page: () => const Login()), // Rute untuk Login
        GetPage(
          name: '/expense',
          page: () =>  ExpensePage(), // Rute untuk Expense Page
          binding: ExpenseBinding(), // Tambahkan binding di sini
        ),
      ],
    );
  }
}