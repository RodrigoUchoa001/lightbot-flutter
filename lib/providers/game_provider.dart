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
        await Future.delayed(const Duration(
            milliseconds: 500)); // Espera para exibir o último movimento
        showDialog(
          context:
              context, // Atualize aqui para utilizar corretamente o contexto
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
        break;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    comandos.clear();
    notifyListeners();
  }
}
