import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_clean/model/ratingModel.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';

class DailyHighRatedSongScreen extends StatefulWidget {
  @override
  _DailyHighRatedSongScreenState createState() => _DailyHighRatedSongScreenState();
}

class _DailyHighRatedSongScreenState extends State<DailyHighRatedSongScreen> {

  Future<List<SongModel>> query()async{
    try{
      final date=DateTime.now();
      final ratingsData=await 
      FirebaseFirestore.instance.collection('ratings').where('date',isLessThanOrEqualTo: date.toIso8601String()).where('date',isGreaterThan: date.subtract(Duration(hours: 24)).toIso8601String()).get();
      List<RatingsModel> ratingList=[];
      ratingsData.docs.forEach((element)=>ratingList.add(RatingsModel.fromDocument(element)));
      List<String> ratingSongIDList=[];
      ratingList.forEach((element)=>ratingSongIDList.add(element.songID));
      List<String> ratingSongsFilteredList=ratingSongIDList.toSet().toList();
      List<SongModel> songs=[];
      for(int i=0;i<ratingSongsFilteredList.length;i++){
        print(ratingSongsFilteredList[i]);
       final doc=await  FirebaseFirestore.instance.collection('songs').doc(ratingSongsFilteredList[i]).get();
       songs.add(SongModel.fromDocument(doc));
      }
      return songs;
    }
    catch(e){
      print(e.toString());
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<List<SongModel>>(
                future: query(),
                builder: (context,data){
                  if(data.connectionState==ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                  if(!data.hasData) return Center(child:Text('No data'));
                  if(data.hasError) return Center(child:Text('Something went wrong'));
                  return ListView.separated
                  (
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,i)=>SingleTrackWidget(song: data.data![i],),
                   separatorBuilder: (context,i)=>SizedBox(height: 10,),
                    itemCount: data.data!.length);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}