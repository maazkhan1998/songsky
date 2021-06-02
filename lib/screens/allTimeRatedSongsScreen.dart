import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AllTimeRatingScreen extends StatefulWidget {
  @override
  _AllTimeRatingScreenState createState() => _AllTimeRatingScreenState();
}

class _AllTimeRatingScreenState extends State<AllTimeRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaginateFirestore(
          padding: EdgeInsets.all(20),
          itemsPerPage: 20,
          isLive: true,
          separator: SizedBox(height: 10,),
          itemBuilderType: PaginateBuilderType.listView,
          query: FirebaseFirestore.instance.collection('songs').orderBy('skycoins',descending: true),
          itemBuilder: (i,context,doc){
            final song=SongModel.fromDocument(doc);
            return SingleTrackWidget(song: song,);
          },
        ),
      ),
    );
  }
}