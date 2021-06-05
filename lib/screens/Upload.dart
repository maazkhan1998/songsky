import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import 'package:new_clean/widgets/onSubmitButton.dart';
import 'package:provider/provider.dart';

import '../const.dart';


class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController songname=TextEditingController();

File? image,song;
late String imagepath,songpath;
late Reference ref;
final firestoreinstance=FirebaseFirestore.instance;
final firebaseStorage=FirebaseStorage.instance;
double progress=0;

bool canPop=true;

  void selectimage()async {
    final PickedFile? pickedImage=await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedImage==null){

    }
    else{
      setState(()=>image=File(pickedImage.path));
    }
  }

  void selectsong() async{
    final pickedFile=await FilePicker.platform.pickFiles(
      allowMultiple: false,type: FileType.audio,
    );
    if(pickedFile!.files.isEmpty){

    }
    else{
      setState(() {
        song=File(
          pickedFile.files[0].path!
        );
      });
    }
  }

  finalupload()async{
    try{
      if(song==null) return Fluttertoast.showToast(msg: 'Select a song');
      if(songname.text.trim().isEmpty) return Fluttertoast.showToast(msg: 'Enter song name');
      progressIndicator(context);
      canPop=false;
      List<SongModel> allSongs=[];
      final allSongsData=await firestoreinstance.collection('songs').where('userID',isEqualTo:Provider.of<AuthenticationService>(context,listen:false).user.id).get();
      allSongsData.docs.forEach((element) {
        allSongs.add(SongModel.fromDocument(element));
      });
      if(allSongs.any((element) => element.songName==songname.text)){
        Navigator.of(context,rootNavigator: true).pop();
        canPop=true;
        return Fluttertoast.showToast(msg: 'Song name already exists');
      }
      Navigator.of(context,rootNavigator: true).pop();
      final task=firebaseStorage.ref('songs').child(Provider.of<AuthenticationService>(context,listen:false).user.id).child(songname.text).putFile(song!);
      task.snapshotEvents.listen((event) {
        setState(() {
          progress=event.bytesTransferred/event.totalBytes;
        });
      });
      task.whenComplete(()async{
         print('completed');
        progressIndicator(context);
        String? imageURL;
        String songURL=await task.storage.ref('songs').child(Provider.of<AuthenticationService>(context,listen:false).user.id).child(songname.text).getDownloadURL();
        if(image!=null){
          final task=await firebaseStorage.ref('songsImages').child(Provider.of<AuthenticationService>(context,listen:false).user.id).child(image!.path).putFile(image!);
          imageURL=await task.ref.getDownloadURL();
        }
        await firestoreinstance.collection('songs').add({
          'song_name':songname.text,
          'artist_name':Provider.of<AuthenticationService>(context,listen:false).user.name,
          'song_url':songURL,
          'image_url':image==null?defaultSongImage:imageURL,
          'skycoins':0,
          'userID':Provider.of<AuthenticationService>(context,listen:false).user.id,
          'date':DateTime.now().toIso8601String()
        });
        Navigator.of(context,rootNavigator: true).pop();
        canPop=true;
        setState((){
          image=null;
          song=null;
          songname.text='';
          progress=0;
        });
      });
    }on FirebaseException catch(e){
      canPop=true;
      customErrorDialog(context, 'Error', e.message!);
    }on SocketException catch(e){
      canPop=true;
      customErrorDialog(context, 'Error', e.message);
    }

    // var data= {
    //   "song_name": songname.text,
    //   "artist_name": artistname.text,
    //   "song_url": song_down_url.toString(),
    //   "image_url": image_down_url.toString(),
    //   "skycoins": 0,
    // };
    // firestoreinstance.collection("songs").doc().set(data);
  }

  late ThemeData themeData;


  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return WillPopScope(
      onWillPop: ()async{
        return canPop;
      },
      child: Scaffold(
            body: SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: selectimage,
                              child: Container(
                                alignment: Alignment.center,
                    height: ScreenUtil().setHeight(175),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black,width: 1
                      )
                    ),
                    child: image==null?Center(child: Text('Select image')):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(image!,fit: BoxFit.fill,height:ScreenUtil().setHeight(175),width: double.infinity,))
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                GestureDetector(
                    onTap:selectsong ,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:10),
                      height: ScreenUtil().setHeight(40),
                      width: ScreenUtil().setWidth(175),
                      decoration: BoxDecoration(
                          color:themeData.colorScheme.primary ,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      alignment: Alignment.center,
                      child:song==null? Text('Select song'):Text(song!.name,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                EmailNameTextField(text: 'Enter song name', controller: songname, type: TextInputType.name, icon: Icon(
                  MdiIcons.music
                )),
                SizedBox(height:ScreenUtil().setHeight(20)),
                LinearProgressIndicator(
                  value: progress
                ),
                OnSubmitButton(func: finalupload, text: 'Upload'),
              ],
        ),
        ),
                        ),
            ),
      ),
    );
  }
}


extension FileExtention on FileSystemEntity{
  String get name {
    return this.path.split("/").last;
  }
}
