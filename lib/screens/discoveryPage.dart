import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class DiscoveryScreen extends StatefulWidget {
  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme=Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: PaginateFirestore(
        padding: EdgeInsets.all(20),
        itemBuilderType: PaginateBuilderType.listView,
        isLive: true,
        query: FirebaseFirestore.instance.collection('songs').orderBy('date',descending: true),
        separator: SizedBox(height: ScreenUtil().setHeight(10),),
        itemBuilder: (i,context,doc){
          final song=SongModel.fromDocument(doc);
          return SingleTrackWidget(song: song,);
        },
      ),
    );
  }
}