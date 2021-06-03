import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_clean/model/ratingModel.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';

class RatedSongScreen extends StatefulWidget {

  final Future<QuerySnapshot> query;

  RatedSongScreen(this.query);
  @override
  _RatedSongScreenState createState() => _RatedSongScreenState();
}

class _RatedSongScreenState extends State<RatedSongScreen> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child:
              FutureBuilder<List<SongModel>>(
                future: query(
                  widget.query
                ),
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
              ),
        ),
      ),
    );
  }
}

Future<List<SongModel>> query(Future<QuerySnapshot> query)async{
    try{
      final ratingsData=await query;
      List<RatingsModel> ratingList=[];
      ratingsData.docs.forEach((element)=>ratingList.add(RatingsModel.fromDocument(element)));
      List<String> ratingSongIDList=[];
      ratingList.forEach((element)=>ratingSongIDList.add(element.songID));
      List<String> ratingSongsFilteredList=ratingSongIDList.toSet().toList();
      final Map<String,int> map={};
      ratingSongsFilteredList.forEach((element)=>map.addAll({element:ratingSongIDList.where((element2) => element2==element).toList().length}));
      final sortedKey=map.keys.toList(growable: false)..sort((k1,k2)=>map[k1]!.compareTo(map[k2]!));
      final sortedMap=Map<String,int>.fromIterable(sortedKey,key: (k) => k, value: (k) => map[k]!);
      final List<String> sortedSongIDList=sortedMap.keys.toList().reversed.toList();
      print(sortedSongIDList);
      List<SongModel> songs=[];
      for(int i=0;i<sortedSongIDList.length;i++){
       final doc=await  FirebaseFirestore.instance.collection('songs').doc(sortedSongIDList[i]).get();
       songs.add(SongModel.fromDocument(doc));
      }
      return songs;
    }
    catch(e){
      print(e.toString());
      throw e;
    }
  }