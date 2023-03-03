import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:studentcom/pages/main_page.dart';
import 'package:studentcom/utilities/google_sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirebaseInitialize = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isFirebaseInitialize = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      goHomePape();
    } else {}
  }

  void goHomePape() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void goSplash() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isFirebaseInitialize
              ? SignInButton(onPressed: () async {
                  try {
                    await signInWithGoogle();
                  } catch (e) {
                    print(e);
                  }
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set({
                    'isSignIn': true,
                    'lastSignInDate': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));

                  goHomePape();
                }, Buttons.Google)
              : const CircularProgressIndicator(),
        ],
      ),
    ));
  }
}
