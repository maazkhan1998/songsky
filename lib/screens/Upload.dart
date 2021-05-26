import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';


class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController songname=TextEditingController();
  TextEditingController artistname=TextEditingController();

late File image,song;
late String imagepath,songpath;
late Reference ref;
var image_down_url,song_down_url;
final firestoreinstance=FirebaseFirestore.instance;

  void selectimage()async {
// image=await FilePicker().pickFiles();

//     setState(() {
//       image=image;
//       imagepath=basename(image.path);
//       uploadimagefile(image.readAsBytesSync(),imagepath);
//     });
  }

  Future<String> uploadimagefile(List<int> image, String imagepath) async{
    ref=FirebaseStorage.instance.ref().child(imagepath);
    // UploadTask uploadTask=ref.putData(image);

    // return image_down_url=await (await uploadTask).ref.getDownloadURL();
    return '';
  }

  void selectsong() async{
    // song=await FilePicker();

    // setState(() {
    //   song=song;
    //   songpath=basename(song.path);
    //   uploadsongfile(song.readAsBytesSync(),songpath);
    // });
  }


  Future<String> uploadsongfile(List<int> song, String songpath) async{
    ref=FirebaseStorage.instance.ref().child(songpath);
    // UploadTask uploadTask=ref.

    // return song_down_url=await (await uploadTask).ref.getDownloadURL();
    return '';
  }

  finalupload(){
    var data= {
      "song_name": songname.text,
      "artist_name": artistname.text,
      "song_url": song_down_url.toString(),
      "image_url": image_down_url.toString(),
      "skycoins": 0,
    };
    firestoreinstance.collection("songs").doc().set(data);
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
            ElevatedButton(
                onPressed: ()=>selectimage(),
            child: Text("Select Image"),
            ),
          ElevatedButton(
              onPressed: ()=>selectsong(),
            child: Text("Select Song"),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: TextField(
                controller: songname,
              decoration: InputDecoration(
                hintText: "Enter song name",

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: artistname,
              decoration: InputDecoration(
                hintText: "Enter artist name",

              ),
            ),
          ),
          ElevatedButton(
              onPressed: ()=>finalupload(),
            child: Text(
              "Upload"
            ),
          ),
        ],
    ),
    );
  }
}
