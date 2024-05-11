import 'package:flutter/material.dart';
import 'package:practice_app4/screens/step_counter_screen.dart';
import 'package:practice_app4/screens/step_counter_screen2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Home Screen")),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StepCounterScreen()),
                );
              },
              child: const Text("All facilty"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StepCounterScreen2()),
                );
              },
              child: const Text("GyroScope"),
            ),
          ],
        ),
      ),
    );
  }
}
