import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/screens/Songspage.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:provider/provider.dart';
import '../provider/authentication_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:20,vertical:30),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CollectedPointsContainer(),
                    Container(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      height: 150,width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2,2),
                          color: Colors.black.withOpacity(0.7)
                          ),
                          BoxShadow(
                            offset: Offset(2,2),
                          color: Colors.black87.withOpacity(0.4)
                          )
                        ]
                      ),
                      child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Available Points',style:TextStyle(
                      color:Colors.white,fontSize:15,fontWeight: FontWeight.w600
                    )),
                    Text(Provider.of<AuthenticationService>(context).user.tokens.toString(),style:TextStyle(
                      color:Colors.white,fontSize:18,fontWeight: FontWeight.w600
                    ))
                  ],
                ),
                    )
                  ],
                ),
              ),
              SizedBox(height:ScreenUtil().setHeight(15)),
              StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection('songs').where('userID',isEqualTo:Provider.of<AuthenticationService>(context,listen:false).user.id ).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting) return Center(child:CircularProgressIndicator());
                  if(!snapshot.hasData) return Center(child:Text('No songs uploaded',style: TextStyle(
                    color: Colors.black,fontSize: 16
                  ),));

                  List<SongModel> songs=[];
                  snapshot.data?.docs.forEach((element)=>songs.add(SongModel.fromDocument(element)));
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,i)=>GestureDetector(
                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                        builder: (_)=>Container()
                      )),
                      child: SingleTrackWidget(song: songs[i])),
                     separatorBuilder:(context,i)=>SizedBox(height:ScreenUtil().setHeight(10)),
                     itemCount: songs.length);
                })
            ],
          ),
        ),
      ),
    );
  }
}

class CollectedPointsContainer extends StatelessWidget {

  late ThemeData themeData;
  
  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      height: 150,width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2,2),
                          color: Colors.black.withOpacity(0.7)
                          ),
                          BoxShadow(
                            offset: Offset(2,2),
                          color: Colors.black87.withOpacity(0.4)
                          )
                        ]
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: 
              FirebaseFirestore.instance.collection('songs').where('userID',isEqualTo: Provider.of<AuthenticationService>(context,listen:false).user.id).orderBy('date',descending: true).snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting) return CircularProgressIndicator();
                if(!snapshot.hasData) return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Collected Points'),
                    Text('0')
                  ],
                );

                List<SongModel> songList=[];
                snapshot.data?.docs.forEach((element) { 
                  songList.add(SongModel.fromDocument(element));
                });
                int points=0;
                songList.forEach((element)=>points+=element.coins);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Collected Points',style:TextStyle(
                      color:Colors.white,fontSize:15,fontWeight: FontWeight.w600
                    )),
                    Text(points.toString(),style:TextStyle(
                      color:Colors.white,fontSize:18,fontWeight: FontWeight.w600
                    ))
                  ],
                );
              },
                      ),
                    );
  }
}