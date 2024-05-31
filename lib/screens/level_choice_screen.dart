import 'package:flutter/material.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/game_screen.dart';
import 'package:provider/provider.dart';

class LevelChoiceScreen extends StatelessWidget {
  const LevelChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Escolha um nível:',
        ),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: niveis.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 48,
                  child: FilledButton.tonal(
                    onPressed: () {
                      provider.alterarNivel(index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                    child: Text('Nível ${index + 1}',
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            },
          )),
    );
  }
}
