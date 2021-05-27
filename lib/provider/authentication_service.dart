import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:new_clean/const.dart';
import 'package:new_clean/model/userModel.dart';

class AuthenticationService with ChangeNotifier {
   FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

   User? get currentUser =>_firebaseAuth.currentUser;

   late CurrentUser user;


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
      throw e.message!;
    }
    on SocketException catch (e){
      throw e;
    }
  }

  getUser()async{
    final data= await firestore.FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).get();
      user=CurrentUser.fromDocument(data);
  }


  Future<void> signUp({required String email,required String password, required File? image,
 required String name}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      String? imageURL;
      if(image!=null){
      final task= await firebaseStorage.FirebaseStorage.instance.ref('users').child(_firebaseAuth.currentUser!.uid).putFile(image);
      imageURL=await task.ref.getDownloadURL();
      }
      await firestore.FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).set({
        'name':name,'email':email,'token':0,
        'imageURL':imageURL==null?defaultImage:imageURL
      });
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
    on SocketException catch (e){
      throw e.message;
    }
  }
}