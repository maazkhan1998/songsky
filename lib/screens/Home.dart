import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/screens/Songspage.dart';
import 'package:new_clean/screens/Upload.dart';
import 'package:new_clean/screens/allTimeRatedSongsScreen.dart';
import 'package:new_clean/screens/ratedSongScreen.dart';
import 'package:new_clean/screens/marketScreen.dart';
import 'package:new_clean/screens/profileScreen.dart';
import 'package:new_clean/widgets/drawer_item.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 42),
          child: Column(
            children: <Widget>[
              DrawerItem(
                text: "Profile",
                onPressed: ()=>Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_)=>ProfileScreen()
                  )
                ),
              ),
              DrawerItem(
                text: "Add SkyCoins",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_)=>MarketScreen()
                    )
                  );
                  },
              ),
              DrawerItem(
                text: "Daily rated songs",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_)=>RatedSongScreen(
                        FirebaseFirestore.instance.collection('ratings').where('date',isLessThanOrEqualTo: DateTime.now().toIso8601String()).where('date',isGreaterThan: DateTime.now().subtract(Duration(hours: 24)).toIso8601String()).get()
                      )
                    )
                  );
                  },
              ),
               DrawerItem(
                text: "Weekly rated songs",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_)=>RatedSongScreen(
                        FirebaseFirestore.instance.collection('ratings').where('date',isLessThanOrEqualTo: DateTime.now().toIso8601String()).where('date',isGreaterThan: DateTime.now().subtract(Duration(days: 7)).toIso8601String()).get()
                      )
                    )
                  );
                  },
              ),
               DrawerItem(
                text: "Monthly rated songs",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_)=>RatedSongScreen(
                        FirebaseFirestore.instance.collection('ratings').where('date',isLessThanOrEqualTo: DateTime.now().toIso8601String()).where('date',isGreaterThan: DateTime.now().subtract(Duration(days: 31)).toIso8601String()).get()
                      )
                    )
                  );
                  },
              ),
              DrawerItem(
                text: "All time rated songs",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_)=>AllTimeRatingScreen()
                    )
                  );
                  },
              ),
              DrawerItem(
                text: "Sign Out",
                onPressed: () { context.read<AuthenticationService>().signOut();},
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
              child: PaginateFirestore(
          padding: EdgeInsets.all(20),
          itemBuilderType: PaginateBuilderType.listView,
          isLive: true,
          query: FirebaseFirestore.instance.collection('songs').orderBy('date',descending: true),
          separator: SizedBox(height: ScreenUtil().setHeight(10),),
          itemBuilder: (i,context,doc){
            final song=SongModel.fromDocument(doc);
            return GestureDetector(
              onTap: ()=>Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_)=>Songspage(song: song,)
                )
              ),
              child: SingleTrackWidget(song: song,));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_)=>Upload()
          )
        ),
        child: Icon(MdiIcons.cloudUpload),
      ),
    );
  }
}
