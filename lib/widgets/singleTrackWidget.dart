import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/model/userModel.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/screens/Songspage.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class SingleTrackWidget extends StatefulWidget {
  final SongModel song;

   SingleTrackWidget(
      {
      required this.song});

  @override
  _SingleTrackWidgetState createState() => _SingleTrackWidgetState();
}

class _SingleTrackWidgetState extends State<SingleTrackWidget> {

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            offset: Offset(2,3)
          ),
          BoxShadow(
            color:Colors.black87.withOpacity(0.4),
            offset: Offset(2,3)
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image(
                image: NetworkImage(widget.song.imageURL),
                fit: BoxFit.cover,
                height: 56,
                width: 56,
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.song.songName,
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1!,
                    fontSize: 14,height: 1,color: Colors.black,
                        fontWeight: 600, letterSpacing: 0.2),
                  ),
                  SizedBox(height:ScreenUtil().setHeight(5)),
                  Text(
                    widget.song.artistName,
                    style: themeData.textTheme.subtitle2!.merge(TextStyle(
                        color: themeData.colorScheme.onBackground,
                        letterSpacing: 0.10)),
                  )
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: ()=>tokenDialog(context, widget.song),
           child: Icon(Icons.arrow_upward_sharp)),
        ],
      ),
    );
  }
}

Future<CurrentUser> getAnyUser(String id)async{
  try{
   final data=await firestore.FirebaseFirestore.instance.collection('users').doc(id).get();
   return CurrentUser.fromDocument(data);
  }
  catch(e){
    throw e;
  }
}