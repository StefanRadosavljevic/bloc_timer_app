import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/timer/bloc/timer_bloc.dart';
import 'package:flutter_timer/timer/view/widgets/background.dart';

import '../../timer.dart';
import 'widgets/actions.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer app"),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              ActionsWidget(),
            ],
          )
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesString =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsString = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesString:$secondsString',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
