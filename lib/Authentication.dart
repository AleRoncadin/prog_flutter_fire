import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roncadin_app/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roncadin_app/register_screen.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:roncadin_app/main.dart';

class Authentication {

  Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context}) async {
    User? user;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text('${e.message}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
    return user;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Login Failed"),
              content: Text('${e.message}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                )
              ],
            ),
          );
        }

      return user;
    }
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}