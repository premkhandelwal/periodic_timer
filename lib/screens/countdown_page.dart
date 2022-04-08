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
import 'package:periodic_timer/data/models/ringTone.dart';

import 'package:periodic_timer/data/models/time.dart';
import 'package:periodic_timer/logic/ringtone/ringtone_cubit.dart';

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
  late RingtoneCubit ringtoneCubit;
  @override
  void initState() {
    super.initState();
    ringtoneCubit = BlocProvider.of<RingtoneCubit>(context);
    // ringtoneCubit.getRingtones();
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

  void notify() async {
    if (animationController.isCompleted) {
      await FlutterRingtonePlayer.playNotification();
    }
  }

  RingTone? _selectedRingtone;
  List<RingTone> _ringToneList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: BlocConsumer<RingtoneCubit, RingtoneState>(
      listener: (context, state) {
        if (state is FetchRingtoneSuccessState) {
          _ringToneList = List.from(state.ringToneList);
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                      content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _ringToneList
                            .map((e) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.name),
                                        Radio<RingTone>(
                                            value: e,
                                            groupValue: state.ringTone,
                                            onChanged: (val) {
                                              ringtoneCubit
                                                  .ringtoneRadioValChanged(val);
                                            })
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  )));
        } else if (state is RingtoneRadioValChanged || state is FetchRingtoneSuccessState) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                      content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _ringToneList
                            .map((e) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.name),
                                        Radio<RingTone>(
                                            value: e,
                                            groupValue: state.ringTone,
                                            onChanged: (val) {
                                              ringtoneCubit
                                                  .ringtoneRadioValChanged(val);
                                            })
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  )));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
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
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
/* 

[AcousticGuitar, Andromeda, Aquila, Argo Navis, Atria, Backroad, Beat Plucker, Bell Phone, Bentley Dubs, Big Easy, Bird Loop, Bollywood, Boötes, Bus' a Move, Cairo, Calypso Steel, Candy, Canis Major, Caribbean Ice, Carina, Carousel, Carousel, Cassiopeia, Celesta, Centaurus, Champagne Edition, Childhood, Childhood, Chimey Phone, Club Cubano, Country, Cowboy, Crayon Rock, Crazy Dream, Curve Ball Blend, Cygnus, Dancin' Fool, Digital Phone, Ding, Don' Mess Wiv It, Draco, Dream Theme, Eastern Sky, Echo, Enter the Nexus, Enthusiastic, Eridani, Ether Shake, Fairyland, Fantasy, FieldTrip, Flutey Phone, Free Flight, Freedom, Friendly Ghost, Funk Y'all, Game, Game Over Guitar, Gimme Mo' Town, Girtab, Glacial Groove, Glee, Glockenspiel, Growl, GuitarClassic, GuitarPop, GuitarRetro, Halfway Home, Hydra, IceLatte, IceWorldPiano, Insert Coin, Kuma, Kungfu, LeisureTime, Lollipop, Lollipop, Loopy Lou
 */