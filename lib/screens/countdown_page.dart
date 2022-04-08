import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/android_sounds.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_ringtone_player/ios_sounds.dart';

import 'package:periodic_timer/data/models/time.dart';
import 'package:periodic_timer/logic/setTime/set_time_cubit.dart';

class CountDownDisplayPage extends StatefulWidget {
  final Time time;
  const CountDownDisplayPage({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  _CountDownDisplayPageState createState() => _CountDownDisplayPageState();
}

class _CountDownDisplayPageState extends State<CountDownDisplayPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  String get countText {
    Duration count = animationController.duration! * animationController.value;
    return animationController.isDismissed
        ? duraString(animationController.duration!)
        : duraString(count);
  }

  String duraString(Duration duration) =>
      "${(duration.inHours % 60).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  double progress = 1;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(
            hours: widget.time.hours,
            minutes: widget.time.minutes,
            seconds: widget.time.seconds));
    animationController.reverse(from: 1);
    animationController.addListener(() {
      if (animationController.isAnimating) {
        setState(() {
          progress = animationController.value;
          isPlaying = true;
        });
      } else {
        notify();
        // FlutterRingtonePlayer.playRingtone(looping: false, asAlarm: true);
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool isPlaying = false;

  void getRingtones() async {
    List<Object?> result = [];
    List<Object?> result1 = [];
    var channel = const MethodChannel('com.example.periodic_timer1');
    var channel2 = const MethodChannel('com.example.periodic_timer2');
    var channel3 = const MethodChannel('com.example.periodic_timer3');
    try {
      result = await channel.invokeMethod('getAllRingtones');
      if (kDebugMode) {
        print(result);
      }
      // Uint8List x = result[0] as Uint8List;
      
      await channel2
          .invokeMethod('playRingtones', {"text": (result[0] as String)});
      Future.delayed(Duration(seconds: 5), () {
        channel3.invokeMethod('stopRingtone');
      });
      // result1 = await channel.invokeMethod('playRingtones', {"text": result[0] as Uint8List});

      // AudioCache player = AudioCache();

      // // final root = await  getApplicationDocumentsDirectory();
      // // final path = root+'/'+pathFile;
      // File file = File(result[0] as String);
      // Uint8List li = await file.readAsBytes();
      // player.playBytes(li);
      // player.playBytes(fileBytes)
      // player.playBytes(fileBytes)
      // player.play(result[0] as String);
// player.play(alarmAudioPath
// FlutterRingtonePlayer.play(android: AndroidSounds.ringtone, ios: ios)
    } catch (e) {
      print(e);
    }
  }

  void notify() async {
    if (animationController.isCompleted) {
      await FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                  height: 300,
                  width: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white54,
                    value: progress,
                    strokeWidth: 6,
                  )),
              AnimatedBuilder(
                animation: animationController,
                builder: (ctx, child) => Text(
                  countText,
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            // horizontal: 10,
            vertical: 60,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (animationController.isAnimating) {
                    animationController.stop();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    animationController.reverse(
                        from: animationController.value == 0
                            ? 1
                            : animationController.value);
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 65),
              ),
              const SizedBox(width: 50),
              IconButton(
                onPressed: () {
                  animationController.reset();
                  setState(() {
                    isPlaying = false;
                  });
                },
                icon: const Icon(
                  Icons.stop_circle,
                  size: 65,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getRingtones();
                },
                child: const Text("Get Ringtone"),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
/* 

[AcousticGuitar, Andromeda, Aquila, Argo Navis, Atria, Backroad, Beat Plucker, Bell Phone, Bentley Dubs, Big Easy, Bird Loop, Bollywood, Boötes, Bus' a Move, Cairo, Calypso Steel, Candy, Canis Major, Caribbean Ice, Carina, Carousel, Carousel, Cassiopeia, Celesta, Centaurus, Champagne Edition, Childhood, Childhood, Chimey Phone, Club Cubano, Country, Cowboy, Crayon Rock, Crazy Dream, Curve Ball Blend, Cygnus, Dancin' Fool, Digital Phone, Ding, Don' Mess Wiv It, Draco, Dream Theme, Eastern Sky, Echo, Enter the Nexus, Enthusiastic, Eridani, Ether Shake, Fairyland, Fantasy, FieldTrip, Flutey Phone, Free Flight, Freedom, Friendly Ghost, Funk Y'all, Game, Game Over Guitar, Gimme Mo' Town, Girtab, Glacial Groove, Glee, Glockenspiel, Growl, GuitarClassic, GuitarPop, GuitarRetro, Halfway Home, Hydra, IceLatte, IceWorldPiano, Insert Coin, Kuma, Kungfu, LeisureTime, Lollipop, Lollipop, Loopy Lou
 */