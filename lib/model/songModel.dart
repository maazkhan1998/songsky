import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel{
  final String artistName;
  final String songID;
  final String imageURL;
  final String songURL;
  final int coins;
  final String songName;
  final String userID;

  SongModel({
    required this.artistName,
    required this.songID,
    required this.imageURL,
    required this.songURL,
    required this.coins,
    required this.songName,
    required this.userID 
  });

  factory SongModel.fromDocument(DocumentSnapshot doc){
    return SongModel(
      songID: doc.id,
      artistName: doc['artist_name'],
      imageURL: doc['image_url'],
      songURL: doc['song_url'],
      coins: doc['skycoins'],
      songName: doc['song_name'],
      userID: doc['userID']
    );
  }
}