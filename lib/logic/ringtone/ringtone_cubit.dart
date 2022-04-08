import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:periodic_timer/data/models/ringTone.dart';
import 'package:periodic_timer/data/models/time.dart';

part 'ringtone_state.dart';

class RingtoneCubit extends Cubit<RingtoneState> {
  RingtoneCubit() : super(RingtoneInitial());

  void changePage(Widget changeToPage) {
    emit(ChangePageState(page: changeToPage));
  }

   void timeSelectionChanged(Time newTime) {
    emit(TimeChanged(time: newTime));
  }

  void ringtoneRadioValChanged(RingTone? ringTone) {
    emit(RingtoneRadioValChanged(ringTone: ringTone));
  }

  void getRingtones() async {
    emit(FetchRingtoneInProgressState());
    var channel = const MethodChannel('com.example.periodic_timer1');
    Map<String, String> result = {};
    List<RingTone> _ringtones = [];
    try {
      result = Map.from(await channel.invokeMethod('getAllRingtones'));
      List<String> names = result.keys.toList();
      List<String> uris = result.values.toList();
      for (var i = 0; i < result.length; i++) {
        RingTone ringTone = RingTone(name: names[i], uri: uris[i]);
        _ringtones.add(ringTone);
      }
      emit(FetchRingtoneSuccessState(ringToneList: _ringtones));
    } catch (e) {
      emit(FetchRingtoneFailureState());
    }
  }
}
