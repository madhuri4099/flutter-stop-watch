
import 'dart:async';
import 'package:bloc/bloc.dart';
import '_timer_event.dart';
import '_timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60; // 1 minute

  TimerBloc() : super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
  }

  StreamSubscription<int>? _tickerSubscription;

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _tick(event.duration).listen(
          (duration) => add(TimerTicked(duration: duration)),
    );
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerRunInProgress(event.duration)
        : const TimerRunComplete());
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  Stream<int> _tick(int duration) {
    return Stream.periodic(const Duration(seconds: 1), (x) => duration - x - 1)
        .take(duration);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

