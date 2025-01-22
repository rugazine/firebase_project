import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut(); 
      print("User logged out successfully.");
    } catch (e) {
      print("Error logging out: $e");
    }
  }
}