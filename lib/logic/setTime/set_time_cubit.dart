import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:periodic_timer/data/models/time.dart';

part 'set_time_state.dart';

class SetTimeCubit extends Cubit<SetTimeState> {
  SetTimeCubit() : super(SetTimeInitial());

  void timeSelectionChanged(Time newTime) {
    emit(TimeChanged(time: newTime));
  }

}
