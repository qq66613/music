import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const musicPlayer(),
    );
  }
}

class musicPlayer extends StatefulWidget {
  const musicPlayer({Key? key}) : super(key: key);

  @override
  State<musicPlayer> createState() => _musicPlayerState();
}

class _musicPlayerState extends State<musicPlayer> {
  bool isPlaying = false;
  double value = 0;
  final player = AudioPlayer();

  Duration? duration = Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(AssetSource("audio1.mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.greenAccent,
        title: const Text("Music App"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/cover.png"),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.5, sigmaY: 20.5),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    "assets/cover.png",
                    width: 250.0,
                  )),
              const SizedBox(height: 20),
              const Text(
                "METTALICA-kill'em All",
                style: TextStyle(
                    color: Colors.blueAccent, fontSize: 36.0, letterSpacing: 6),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()}:${(value % 60).floor()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Slider.adaptive(
                    onChanged: (rogue) {
                      setState(() {
                        value = rogue;
                      });
                    },
                    min: 0.0,
                    max: duration!.inSeconds.toDouble(),
                    value: value,
                    onChangeEnd: (newValue) async {
                      setState(() {
                        value = newValue;
                        print(newValue);
                      });
                      player.pause();
                      await player.seek(Duration(seconds: newValue.toInt()));
                      await player.resume();
                    },
                    activeColor: Colors.green,
                  ),
                  Text(
                    "${duration!.inMinutes} : ${duration!.inSeconds % 60}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Colors.black87,
                    border: Border.all(color: Colors.redAccent)),
                child: InkWell(
                  onTap: () async {
                    if (isPlaying) {
                      await player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });

                      player.onPositionChanged.listen(
                        (position) {
                          setState(() {
                            value = position.inSeconds.toDouble();
                          });
                        },
                      );
                    }
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                    //Icons.play_arrow_sharp,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
