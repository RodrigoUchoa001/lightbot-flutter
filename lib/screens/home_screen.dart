import 'package:flutter/material.dart';
import 'package:lightbot_flutter/screens/level_choice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'LightBot',
                      style: TextStyle(fontSize: 48),
                    ),
                    Text(
                      'Flutter',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48,
                  child: FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LevelChoiceScreen(),
                        ),
                      );
                    },
                    child: const Text('Jogar', style: TextStyle(fontSize: 24)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
