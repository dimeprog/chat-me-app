import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<UserCredential> signup(String email, String password) async {
    try {
      final user = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 40));
      return user;
    } on FirebaseException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future signin(String email, String password) async {
    try {
      final user = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 40));
      return user;
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Future logout() async {
    try {
      final user = await auth.signOut().timeout(const Duration(seconds: 40));
      return user;
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
}
