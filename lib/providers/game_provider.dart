import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';

class GameProvider extends ChangeNotifier {
  Tabuleiro tabuleiro;
  List<Direcao> comandos = [];

  GameProvider(this.tabuleiro);

  void adicionarComando(Direcao comando) {
    comandos.add(comando);
    notifyListeners();
  }

  Future<void> executarComandos(BuildContext context) async {
    for (var comando in comandos) {
      tabuleiro.moverRobo(comando);
      notifyListeners();
      if (tabuleiro.verificarVitoria()) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Parabéns!'),
              content: const Text('Você alcançou a posição de vitória!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        print("vitoria!");
        await Future.delayed(const Duration(
            milliseconds: 500)); // Espera para exibir o último movimento
        break;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!tabuleiro.verificarVitoria()) {
      tabuleiro.reiniciarTabuleiro();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Perdeu!'),
            content:
                const Text('Sequência de comandos incorreta! Tente novamente!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    comandos.clear();
    notifyListeners();
  }
}
