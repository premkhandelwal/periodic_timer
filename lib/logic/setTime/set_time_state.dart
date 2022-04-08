part of 'set_time_cubit.dart';

@immutable
abstract class SetTimeState extends Equatable{
  Time get time => Time(hours: 0, minutes: 0, seconds: 0);

  @override
  List<Object?> get props => [time];
}

class SetTimeInitial extends SetTimeState {}

class TimeChanged extends SetTimeState {
  @override
  final Time time;
  TimeChanged({
    required this.time,
  });
  @override
  List<Object?> get props => [DateTime.now()];
}
