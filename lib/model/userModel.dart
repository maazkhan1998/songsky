import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser{
  final String id;
  final String name;
  final String email;
  final int tokens;
  final String imageURL;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.tokens,
    required this.imageURL
  });

  factory CurrentUser.fromDocument(DocumentSnapshot doc){
    return CurrentUser(
      id: doc.id,
      email: doc['email'],
      imageURL: doc['imageURL'],
      name: doc['name'],
      tokens: doc['token']
    );
  }
}