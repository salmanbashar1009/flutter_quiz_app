import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onTimeUp;
  final Color? color;

  const CountdownTimer({
    super.key,
    required this.seconds,
    required this.onTimeUp,
    this.color,
  }) ;

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        widget.onTimeUp();
      }
    });
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _timer?.cancel();
      _animationController.reset();
      _animationController.duration = Duration(seconds: widget.seconds);
      _remainingSeconds = widget.seconds;
      _animationController.forward();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color timerColor = widget.color ?? Theme.of(context).primaryColor;

    if (_remainingSeconds <= 5) {
      timerColor = Colors.red;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: _animation.value,
            strokeWidth: 4,
            backgroundColor: Colors.grey.withAlpha(150),
            valueColor: AlwaysStoppedAnimation<Color>(timerColor),
          ),
        ),
        Text(
          '$_remainingSeconds',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: timerColor,
          ),
        ),
      ],
    );
  }
}