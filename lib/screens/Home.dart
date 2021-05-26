import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Songspage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getdata() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('songs').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(strokeWidth: 3,),
          );
        } else {if (snapshot.data != null) {
          final list = snapshot.data as List;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Songspage(
                                songname:
                                    list[index].data()["song_name"],
                                artistname:
                                    list[index].data()["artist_name"],
                                songurl:
                                    list[index].data()["song_url"],
                                imageurl:
                                    list[index].data()["image_url"],
                                skycoins:
                                    list[index].data()["skycoins"],
                              ))),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column( crossAxisAlignment: CrossAxisAlignment.end,children:<Widget>[Text(
                        list[index].data()["song_name"],
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ElevatedButton(onPressed: null,
                    child:Icon(Icons.upload_sharp, size: 15,color: Colors.black,))],
                      ),
                    ),
                    elevation: 10.0,
                  ),
                );
              });
        }else {
    return Text("No data");
    }
      }},
    );
  }
}
