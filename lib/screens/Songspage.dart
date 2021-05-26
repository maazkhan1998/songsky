import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Songspage extends StatefulWidget {
  final String songname, artistname, songurl, imageurl;
 final int skycoins;

 Songspage(
   {
     required this.songname,
     required this.artistname,
     required this.songurl,
     required this.imageurl,
     required this.skycoins
   }
 );

  @override
  _SongspageState createState() => _SongspageState();
}

class _SongspageState extends State<Songspage> {
  AudioPlayer audioPlayer = AudioPlayer();
  late Duration TotalDuration;
  late Duration position;
  late String audioState;

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

  @override
  void giveCoin() {
    widget.skycoins + 1;
  }

  void initState() {
    initAudio();
    super.initState();
  }

  playAudio() {
    audioPlayer.play(widget.songurl == null ? '' : widget.songurl);
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
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

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  widget.songname,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                Text(
                  widget.skycoins.toString(),
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  widget.artistname,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Card(
                  child: Image.network(widget.imageurl, height: 350.00),
                  elevation: 10.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
                SliderTheme(
                    data: SliderThemeData(
                        trackHeight: 5,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 5)),
                    child: Slider(
                      value: audioState == null
                          ? 0
                          : position == null
                              ? 0
                              : position.inMilliseconds.toDouble(),
                      activeColor: Colors.grey,
                      inactiveColor: Colors.black,
                      onChanged: (value) {
                        seekAudio(Duration(milliseconds: value.toInt()));
                      },
                      min: 0,
                      max: TotalDuration == null
                          ? 20
                          : TotalDuration.inMilliseconds.toDouble(),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      onPressed: () {
                        audioState == "Playing" ? pauseAudio() : playAudio();
                      },
                      child: Icon(
                        audioState == "Playing"
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 50.0,
                      ),
                    )),
                    Expanded(
                        child: FlatButton(
                      onPressed: () {
                        stopAudio();
                      },
                      child: Icon(
                        Icons.stop,
                        size: 50.0,
                      ),
                    )),
                    Expanded(
                        child: FlatButton(
                      onPressed: () {
                        giveCoin();
                      },
                      child: Icon(
                        Icons.add_circle,
                        size: 50.0,
                      ),
                    )),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
