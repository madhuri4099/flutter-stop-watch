// lib/screens/timer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/_timer_bloc.dart';
import '../bloc/_timer_event.dart';
import '../bloc/_timer_state.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer/Stopwatch'),
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final String minutesStr =
          ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
          final String secondsStr =
          (state.duration % 60).floor().toString().padLeft(2, '0');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$minutesStr:$secondsStr',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                _mapStateToActionButtons(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _mapStateToActionButtons(BuildContext context, TimerState state) {
    final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);
    if (state is TimerInitial) {
      return FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () => timerBloc.add(TimerStarted(duration: state.duration)),
      );
    } else if (state is TimerRunInProgress) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.pause),
            onPressed: () => timerBloc.add(TimerPaused()),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            child: const Icon(Icons.replay),
            onPressed: () => timerBloc.add(TimerReset()),
          ),
        ],
      );
    } else if (state is TimerRunPause) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () => timerBloc.add(TimerResumed()),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            child: const Icon(Icons.replay),
            onPressed: () => timerBloc.add(TimerReset()),
          ),
        ],
      );
    } else if (state is TimerRunComplete) {
      return FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () => timerBloc.add(TimerReset()),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
