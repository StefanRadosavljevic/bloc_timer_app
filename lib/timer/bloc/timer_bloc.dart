import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../timer.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;
  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(_duration));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    }
  }

  Future<void> close() {
    if (_tickerSubscription != null) {
      _tickerSubscription.cancel();
      return super.close();
    }
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    if (_tickerSubscription == null) {
      print("_tickerSubscription is null");
    }
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield tick.duration > 0
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete();
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      if (_tickerSubscription == null) {
        print("_tickerSubscription is null");
      }
      _tickerSubscription.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      if (_tickerSubscription == null) {
        print("_tickerSubscription is null");
      }
      _tickerSubscription.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    if (_tickerSubscription == null) {
      print("_tickerSubscription is null");
    }
    _tickerSubscription.cancel();
    yield TimerInitial(_duration);
  }
}
