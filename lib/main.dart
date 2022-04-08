import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:periodic_timer/screens/home_page.dart';
import 'package:periodic_timer/logic/setTime/set_time_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SetTimeCubit(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(brightness: Brightness.light, primarySwatch: Colors.teal),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
