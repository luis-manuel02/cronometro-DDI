import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartWatch Timer',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        hintColor: Colors.tealAccent,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode: mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen({required this.mode, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _count = 0;
  String _strCount = "00:00";
  String _status = "Start";

  @override
  void initState() {
    _status = "Start";
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAmbient = widget.mode == WearMode.ambient;
    return Scaffold(
      backgroundColor: isAmbient ? Colors.black : Colors.grey[800],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Cronómetro",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isAmbient ? Colors.grey : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _strCount,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isAmbient ? Colors.grey : Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (!isAmbient)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildButton(
                      icon: _status == "Start" || _status == "Continue"
                          ? Icons.play_arrow
                          : Icons.pause,
                      onPressed: _handleStartStop,
                    ),
                    const SizedBox(width: 10),
                    _buildButton(
                      icon: Icons.refresh,
                      onPressed: _handleReset,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required IconData icon, required VoidCallback onPressed}) {
    bool isAmbient = widget.mode == WearMode.ambient;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isAmbient ? Colors.grey[700] : Colors.grey[500],
        foregroundColor: isAmbient ? Colors.black : Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        elevation: isAmbient ? 0 : 8,
        shadowColor: isAmbient ? Colors.transparent : Colors.black54,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Icon(icon, size: 12),
    );
  }

  void _handleStartStop() {
    setState(() {
      if (_status == "Start" || _status == "Continue") {
        _startTimer();
        _status = "Stop";
      } else if (_status == "Stop") {
        _timer.cancel();
        _status = "Continue";
      }
    });
  }

  void _handleReset() {
    _timer.cancel();
    setState(() {
      _count = 0;
      _strCount = "00:00";
      _status = "Start";
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count++;
        int minutes = _count ~/ 60;
        int seconds = _count % 60;
        _strCount =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    });
  }
}
