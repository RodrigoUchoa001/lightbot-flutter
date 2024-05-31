import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';

class GameProvider extends ChangeNotifier {
  late Tabuleiro tabuleiro;
  List<Direcao> comandos = [];
  late int nivelAtual;

  GameProvider({this.nivelAtual = 0}) {
    tabuleiro = niveis[nivelAtual];
  }

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
                nivelAtual >= niveis.length - 1
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fim'),
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          proximoNivel();
                        },
                        child: const Text('Próximo Nível'),
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

  void proximoNivel() {
    if (nivelAtual < niveis.length - 1) {
      nivelAtual++;
      tabuleiro = niveis[nivelAtual];
      notifyListeners();
    }
  }

  void alterarNivel(int nivel) {
    if (nivel < niveis.length) {
      nivelAtual = nivel;
      tabuleiro = niveis[nivelAtual];
    } else {
      throw ("fase invalida");
    }
  }
}
