// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/_timer_bloc.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(const TimerStopwatchApp());
}

class TimerStopwatchApp extends StatelessWidget {
  const TimerStopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer/Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(),
        child: const TimerScreen(),
      ),
    );
  }
}
