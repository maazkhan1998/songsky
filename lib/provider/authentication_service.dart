import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService with ChangeNotifier {
   FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

   User? get currentUser =>_firebaseAuth.currentUser;


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
}

  Future<void> signIn({required String email,required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.toString();
    }
    on SocketException catch (e){
      throw e;
    }
  }


  Future<void> signUp({required String email,required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.toString();
    }
  }
}