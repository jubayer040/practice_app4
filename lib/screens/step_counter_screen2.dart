import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepCounterScreen2 extends StatefulWidget {
  const StepCounterScreen2({super.key});
  @override
  State<StepCounterScreen2> createState() => _StepCounterScreen2State();
}

class _StepCounterScreen2State extends State<StepCounterScreen2> {
  late StreamSubscription<GyroscopeEvent> _accelerometerSubscription;
  GyroscopeEvent _gyroscopeEvent = GyroscopeEvent(0, 0, 0);

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = gyroscopeEventStream().listen((event) {
      if (mounted) {
        setState(() => _gyroscopeEvent = event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("X : ${_gyroscopeEvent.x.toStringAsFixed(2)}"),
              const SizedBox(height: 15),
              Text("Y : ${_gyroscopeEvent.y.toStringAsFixed(2)}"),
              const SizedBox(height: 15),
              Text(
                "Z : ${_gyroscopeEvent.z.toStringAsFixed(5)}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }
}
