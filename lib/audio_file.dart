import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  final String audiopath;
  const AudioFile({required this.advancedPlayer, required this.audiopath});

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isRepeat = false;
  List<IconData> _icons = [Icons.play_circle_fill, Icons.pause_circle_filled];
  Color color = Colors.black;

  @override
  void initState() {
    super.initState();
    print(widget.audiopath);
    widget.advancedPlayer.setSourceUrl(widget.audiopath);
    widget.advancedPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() {
        _duration = d;
      });
    });

    widget.advancedPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    widget.advancedPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        if (isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
          widget.advancedPlayer.dispose();
        }
      });
    });
  }

  Widget btnStart() {
    return IconButton(
        icon: isPlaying == false
            ? Icon(_icons[0], size: 50)
            : Icon(_icons[1], size: 50),
        onPressed: () {
          if (isPlaying == false) {
            setState(() {
              widget.advancedPlayer.play(UrlSource(widget.audiopath));
              isPlaying = true;
            });
          } else if (isPlaying == true) {
            widget.advancedPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          }
        });
  }

  Widget btnFast() {
    return IconButton(
        onPressed: () {
          widget.advancedPlayer.setPlaybackRate(1.5);
        },
        icon: ImageIcon(AssetImage('img/forward.png'),
            size: 15, color: Colors.black));
  }

  Widget btnSlow() {
    return IconButton(
      icon: ImageIcon(AssetImage('img/backword.png'),
          size: 15, color: Colors.black),
      onPressed: () {
        this.widget.advancedPlayer.setPlaybackRate(0.5);
      },
    );
  }

  Widget btnRepeat() {
    return IconButton(
      icon: ImageIcon(AssetImage('img/repeat.png'), size: 15, color: color),
      onPressed: () {
        if (isRepeat == false) {
          widget.advancedPlayer.setReleaseMode(ReleaseMode.loop);
          setState(() {
            isRepeat = true;
            color = Colors.blue;
          });
        } else if (isRepeat == true) {
          widget.advancedPlayer.setReleaseMode(ReleaseMode.release);
          setState(() {
            isRepeat = false;
            color = Colors.black;
          });
        }
      },
    );
  }

  Widget loadAsset() {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnSlow(),
        btnStart(),
        btnFast(),
        btnRepeat(),
      ],
    ));
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        });
  }

  void changeToSecond(int second) {
    Duration newPosition = Duration(seconds: second);
    widget.advancedPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_position.toString().split(".")[0],
                  style: TextStyle(fontSize: 16)),
              Text(_duration.toString().split(".")[0],
                  style: TextStyle(fontSize: 16)),
            ],
          )),
      // slider(),
      loadAsset(),
    ]));
  }
}
