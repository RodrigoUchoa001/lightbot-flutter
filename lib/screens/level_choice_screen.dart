import 'package:flutter/material.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/game_screen.dart';
import 'package:lightbot_flutter/screens/game_screen2.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mecânica 1"),
              ListView.builder(
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
              ),
              const SizedBox(height: 24),
              const Text("Mecânica 2"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: niveis2.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: () {
                          provider.alterarNivel(index + niveis.length);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GameScreen2(
                                tabuleiro: niveis2[
                                    provider.nivelAtual - niveis.length],
                                sequenciaMovimentos: sequenciaMecanica2[0],
                              ),
                            ),
                          );
                        },
                        child: Text('Nível ${index + 1}',
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
