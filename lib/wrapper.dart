import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/homepage.dart';
import 'package:project_firebase/login.dart'; // Pastikan Login diimpor

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading ketika sedang menunggu data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // Jika pengguna sudah login
            return Homepage();
          } else {
            // Jika pengguna belum login
            return Login();
          }
        },
      ),
    );
  }
}
