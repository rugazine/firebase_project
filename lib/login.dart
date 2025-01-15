import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/forgot.dart';
import 'package:project_firebase/signup.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text, password: password.text);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Enter password'),
            ),
            ElevatedButton(onPressed: (() => signIn()), child: Text("Login")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: (() => signInWithGoogle()),
                child: Text("Login with Google")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: (() => Get.to(Signup())),
                child: Text("Register now")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: (() => Get.to(Forgot())),
                child: Text("Forgot password ?"))
          ],
        ),
      ),
    );
  }
}
