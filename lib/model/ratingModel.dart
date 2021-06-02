import 'package:cloud_firestore/cloud_firestore.dart';

class RatingsModel{
  final String id;
  final String songID;
  final String donorID;
  final String date;

  RatingsModel({
    required this.id,required this.songID,required this.donorID,required this.date
  });

  factory RatingsModel.fromDocument(DocumentSnapshot doc){
    return RatingsModel(
      id: doc.id,
      date: doc['date'],
      donorID: doc['donorID'],
      songID: doc['songID']
    );
  }
}