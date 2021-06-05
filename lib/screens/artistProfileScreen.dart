import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/screens/Songspage.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ArtistProfileScreen extends StatefulWidget {

  final String userID;


  ArtistProfileScreen({required this.userID});

  @override
  _ArtistProfileScreenState createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaginateFirestore(
          padding: EdgeInsets.all(20),
          separator: SizedBox(height: 10,),
          query: FirebaseFirestore.instance.collection('songs').where('userID',isEqualTo: widget.userID).orderBy('date',descending: true),
          isLive: true,
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (i,context,doc){
            final song=SongModel.fromDocument(doc);
            return GestureDetector(
              onTap: ()=>Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_)=>Songspage(song: song,)
                )
              ),
              child: SingleTrackWidget(song: song));
          },
        ),
      ),
    );
  }
}