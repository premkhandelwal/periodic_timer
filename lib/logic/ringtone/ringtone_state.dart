part of 'ringtone_cubit.dart';

abstract class RingtoneState extends Equatable {
  get ringTone => RingTone(name: "", uri: "");
  Time get time => Time(hours: 0, minutes: 0, seconds: 0);

  const RingtoneState();

  @override
  List<Object> get props => [DateTime.now(), time];
}

class RingtoneInitial extends RingtoneState {}

class ChangePageState extends RingtoneState {
  final Widget page;
  ChangePageState({
    required this.page,
  });
}

class RingtoneRadioValChanged extends RingtoneState {
  @override
  final RingTone? ringTone;
  const RingtoneRadioValChanged({
    required this.ringTone,
  });
}

class FetchRingtoneSuccessState extends RingtoneState {
  final List<RingTone> ringToneList;
  const FetchRingtoneSuccessState({
    required this.ringToneList,
  });
}

class FetchRingtoneFailureState extends RingtoneState {}

class FetchRingtoneInProgressState extends RingtoneState {}

class TimeChanged extends RingtoneState {
  @override
  final Time time;
  TimeChanged({
    required this.time,
  });
}
