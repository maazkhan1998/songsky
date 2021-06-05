import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/screens/artistProfileScreen.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:new_clean/widgets/singleTrackWidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Songspage extends StatefulWidget {
  final SongModel song;

  Songspage({required this.song});

  @override
  _SongspageState createState() => _SongspageState();
}

class _SongspageState extends State<Songspage>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration TotalDuration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  String audioState = 'Paused';
  late AnimationController _animationController;
  bool isPlaying = false;


  initAudio() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        TotalDuration = updatedDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((updatedPositon) {
      setState(() {
        position = updatedPositon;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.STOPPED) audioState = "Stopped";
      if (playerState == PlayerState.PLAYING) audioState = "Playing";
      if (playerState == PlayerState.PAUSED) audioState = "Paused";

      setState(() {});
    });
  }

  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    initAudio();
    super.initState();
  }

  playAudio() {
    audioPlayer.play(widget.song.songURL == null ? '' : widget.song.songURL);
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
    _animationController.reverse();
    setState(() => isPlaying = false);
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop();
    stopAudio();
    throw '';
  }

  dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () {
              Navigator.of(context).pop();
              stopAudio();
            }),
            title: Text("Kamran's Song App"),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(widget.song.imageURL),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MySize.size16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.song.songName.toUpperCase(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6!,
                                  height: 1,
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: 600),
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: ()=>Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_)=>ArtistProfileScreen(userID: widget.song.userID)
                                )
                              ),
                              child: Text(
                                widget.song.artistName,
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.caption!,
                                    height: 1,
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: 400,
                                    letterSpacing: 0.3),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 220,
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                        clipper: _Clipper(),
                        child: Container(
                          color: themeData.colorScheme.background,
                        )),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: MySize.size8),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                MySize.size28),
                                            side: BorderSide.none),
                                        child: InkWell(
                                          splashColor:
                                              themeData.colorScheme.primary,
                                          child: SizedBox(
                                              height: MySize.size48,
                                              width: MySize.size48,
                                              child: Icon(
                                                MdiIcons.stop,
                                                color: themeData
                                                    .colorScheme.onBackground,
                                                size: MySize.size28,
                                              )),
                                          onTap: () {
                                            stopAudio();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Hero(
                                    tag: 'music-fab',
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              MySize.size48),
                                          boxShadow: [
                                            BoxShadow(
                                                color: themeData
                                                    .colorScheme.primary
                                                    .withAlpha(42),
                                                spreadRadius: 1,
                                                blurRadius: 6,
                                                offset: Offset(0, 6))
                                          ]),
                                      child: ClipOval(
                                        child: Material(
                                          elevation: 5,
                                          color: themeData.colorScheme.primary,
                                          child: InkWell(
                                            splashColor: Colors.white,
                                            child: IconButton(
                                              iconSize: 28,
                                              icon: AnimatedIcon(
                                                icon: AnimatedIcons.play_pause,
                                                progress: _animationController,
                                              ),
                                              onPressed: () {
                                                if (isPlaying) {
                                                  _animationController
                                                      .reverse();
                                                  pauseAudio();
                                                  setState(() {
                                                    isPlaying = false;
                                                  });
                                                } else {
                                                  _animationController
                                                      .forward();
                                                  playAudio();
                                                  setState(() {
                                                    isPlaying = true;
                                                  });
                                                }
                                              },
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: MySize.size8),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                MySize.size28),
                                            side: BorderSide.none),
                                        child: InkWell(
                                          splashColor:
                                              themeData.colorScheme.primary,
                                          child: SizedBox(
                                              height: MySize.size48,
                                              width: MySize.size48,
                                              child: Icon(
                                                Icons.add_circle,
                                                color: themeData
                                                    .colorScheme.onBackground,
                                                size: MySize.size28,
                                              )),
                                          onTap:()=> tokenDialog(context,widget.song),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: MySize.size16,
                                  right: MySize.size16,
                                  top: MySize.size12),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SliderTheme(
                                        data: SliderThemeData(
                                            trackHeight: 5,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 5)),
                                        child: Slider(
                                          value: audioState == null
                                              ? 0
                                              : position == null
                                                  ? 0
                                                  : position.inMilliseconds
                                                      .toDouble(),
                                          activeColor: Colors.grey,
                                          inactiveColor: Colors.black,
                                          onChanged: (value) {
                                            seekAudio(Duration(
                                                milliseconds: value.toInt()));
                                          },
                                          min: 0,
                                          max: TotalDuration == null
                                              ? 20
                                              : TotalDuration.inMilliseconds
                                                  .toDouble(),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

onDonateToken(BuildContext context,SongModel song,int tokens) async {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    try {
      if (song.userID == provider.user.id)
        return Fluttertoast.showToast(
            msg: 'Cannot give tokens to your own songs');
      if (provider.user.tokens < tokens)
        return Fluttertoast.showToast(msg: 'Not enough tokens');
      await firestore.FirebaseFirestore.instance.collection('ratings').add({
        'donorID': provider.user.id,
        'songID': song.songID,
        'date': DateTime.now().toIso8601String(),
        'tokens':tokens
      });
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(provider.user.id)
          .update({'token': provider.user.tokens - tokens});
      await firestore.FirebaseFirestore.instance
          .collection('songs')
          .doc(song.songID)
          .update({'skycoins': song.coins + tokens});
      final songUser = await getAnyUser(song.userID);
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(song.userID)
          .update({
        'recievedTokens': songUser.recievedTokens + tokens,
        'token': songUser.tokens + tokens
      });
      provider.getUser();
      Fluttertoast.showToast(msg: 'Token send');
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }


class _Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(size.width / 2, -40, size.width, size.height * 0.65);
    path.lineTo(size.width, size.height * 0.65);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
