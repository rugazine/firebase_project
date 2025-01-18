import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/pages/homepage.dart';
import 'package:project_firebase/auth/login.dart';

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
          // Handle loading state while checking authentication status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 

          // If the user is logged in, navigate to Homepage
          else if (snapshot.hasData) {
            return  Homepage();
          } 

          // If the user is not logged in, navigate to Login page
          else {
            return Login();
          }
        },
      ),
    );
  }
}
