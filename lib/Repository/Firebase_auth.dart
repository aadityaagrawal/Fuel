import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email and Password Authentication
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  // Email Verification
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    try{
    await user?.sendEmailVerification();
    }
    catch(e)
    {
        throw e;
    }
  }

  // Mobile Number Verification
  // Add your mobile number verification logic here

  // Sign Out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
Future forgotPassword({required String email}) async {
      try {
             await _auth.sendPasswordResetEmail(email: email);
          } on FirebaseAuthException catch (err) {
             throw Exception(err.message.toString());
          } catch (err) {
             throw Exception(err.toString());
          }
      }

  // Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
