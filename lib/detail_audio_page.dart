import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_file.dart';

class DetailAudioPage extends StatefulWidget {
  final Map<String, dynamic> book;
  const DetailAudioPage({required this.book});

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  late AudioPlayer advancedPlayer;

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight / 3,
              child: Container(
                color: Colors.blue,
              )),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() async {
                      await advancedPlayer.stop();
                      await advancedPlayer.dispose();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              )),
          Positioned(
              top: screenHeight * 0.2,
              left: 0,
              right: 0,
              child: Container(
                  height: screenHeight * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Text(widget.book["title"],
                          style: TextStyle(fontSize: 10)),
                      Text(widget.book["text"]),
                      AudioFile(
                          advancedPlayer: advancedPlayer,
                          audiopath: widget.book["audio"]),
                    ],
                  ))),
          Positioned(
              top: screenHeight * 0.12,
              left: (screenWidth - 150) / 2,
              right: (screenWidth - 150) / 2,
              child: Container(
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(image: AssetImage(widget.book["img"])),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  // child: Image(image: image)
                ),
              )),
        ]));
  }
}
