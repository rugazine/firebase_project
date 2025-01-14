import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();
  String message = ''; // Menyimpan pesan untuk ditampilkan

  // Fungsi untuk mereset password
  reset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      setState(() {
        message = 'Link reset password telah dikirim ke email Anda!';
      });
    } catch (e) {
      setState(() {
        message = 'Terjadi kesalahan: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            ElevatedButton(
              onPressed: reset,
              child: Text("Send link"),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: message.contains('error') ? Colors.red : Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
