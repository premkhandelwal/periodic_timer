import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:periodic_timer/data/enums.dart';
import 'package:periodic_timer/data/models/time.dart';
import 'package:periodic_timer/logic/setTime/set_time_cubit.dart';
import 'package:periodic_timer/screens/countdown_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

int hours = 0;
int minutes = 0;
int seconds = 0;

class _HomePageState extends State<HomePage> {
  final ScrollController middle = ScrollController();
  late SetTimeCubit setTimeCubit;
  @override
  void initState() {
   setTimeCubit = BlocProvider.of<SetTimeCubit>(context);
    super.initState();
  }

  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Container(
                height: 375,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimeSelectorWidget(maxVal: 23, timeType: TimeType.hours),
                    TimeSelectorWidget(maxVal: 59, timeType: TimeType.minutes),
                    TimeSelectorWidget(maxVal: 59, timeType: TimeType.seconds),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: IconButton(
                onPressed: () {
                  setTimeCubit.timeSelectionChanged(
                      Time(hours: hours, minutes: minutes, seconds: seconds));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => CountDownDisplayPage(time:  Time(hours: hours, minutes: minutes, seconds: seconds),)),
                  );
                },
                icon: const Icon(Icons.play_circle, size: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSelectorWidget extends StatelessWidget {
  final int maxVal;
  final TimeType timeType;
  TimeSelectorWidget({
    Key? key,
    required this.maxVal,
    required this.timeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListWheelScrollView.useDelegate(
          itemExtent: 50,
          diameterRatio: 0.9,
          magnification: 1.5,
          useMagnifier: true,
          controller: FixedExtentScrollController(initialItem: 0),
          childDelegate: ListWheelChildLoopingListDelegate(
            children: List.generate(
              maxVal + 1,
              (index) {
                String newIndex = index.toString().padLeft(2, '0');
                return Center(
                  child: Text(newIndex, style: const TextStyle(fontSize: 30)),
                );
              },
            ),
          ),
          onSelectedItemChanged: (int index) {
            // Time time = Time(hours: hours, minutes: minutes, seconds: seconds);
            if (timeType == TimeType.hours) {
              hours = index;
            } else if (timeType == TimeType.minutes) {
              minutes = index;
            } else if (timeType == TimeType.seconds) {
              seconds = index;
            }
          }),
    );
  }
}
