import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';
import 'package:lightbot_flutter/models/orientacao.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';

class GameScreen2 extends StatelessWidget {
  final Tabuleiro tabuleiro;
  final List<Direcao> sequenciaMovimentos;

  const GameScreen2(
      {super.key, required this.tabuleiro, required this.sequenciaMovimentos});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lightbot Flutter - Nova Mecânica'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tabuleiro.colunas,
              ),
              itemCount: tabuleiro.linhas * tabuleiro.colunas,
              itemBuilder: (context, index) {
                int linha = index ~/ tabuleiro.colunas;
                int coluna = index % tabuleiro.colunas;
                CasaDoTabuleiro casa = tabuleiro.casas[linha][coluna];

                return GestureDetector(
                  onTap: () {
                    bool resultado = _verificarEscolha(linha, coluna);
                    _mostrarDialogoResultado(context, resultado, provider);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: casa.objetoPresente
                          ? Colors.grey
                          : linha == provider.tabuleiro.posicaoVitoria.linha &&
                                  coluna ==
                                      provider.tabuleiro.posicaoVitoria.coluna
                              ? Colors.green
                              : Colors.white,
                    ),
                    child: linha == provider.tabuleiro.posicaoRobo!.linha &&
                            coluna == provider.tabuleiro.posicaoRobo!.coluna
                        ? Transform.rotate(
                            angle: _getRotationAngle(
                                provider.tabuleiro.orientacaoRobo),
                            child: const Icon(Icons.arrow_upward,
                                color: Colors.blue, size: 48),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Sequência de Movimentos:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 10.0,
                  children: sequenciaMovimentos.map((comando) {
                    return Chip(
                      label: Text(comando.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _verificarEscolha(int linha, int coluna) {
    var robo = CasaDoTabuleiro(
      tabuleiro.posicaoRobo!.linha,
      tabuleiro.posicaoRobo!.coluna,
    );
    var orientacao = tabuleiro.orientacaoRobo;

    for (var comando in sequenciaMovimentos) {
      switch (comando) {
        case Direcao.virarEsquerda:
          orientacao = _virarEsquerda(orientacao);
          break;
        case Direcao.avancar:
          robo = _avancar(robo, orientacao);
          break;
        case Direcao.virarDireita:
          orientacao = _virarDireita(orientacao);
          break;
      }
    }

    return robo.linha == linha && robo.coluna == coluna;
  }

  Orientacao _virarEsquerda(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return Orientacao.esquerda;
      case Orientacao.esquerda:
        return Orientacao.baixo;
      case Orientacao.baixo:
        return Orientacao.direita;
      case Orientacao.direita:
        return Orientacao.cima;
      default:
        return orientacao;
    }
  }

  Orientacao _virarDireita(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return Orientacao.direita;
      case Orientacao.direita:
        return Orientacao.baixo;
      case Orientacao.baixo:
        return Orientacao.esquerda;
      case Orientacao.esquerda:
        return Orientacao.cima;
      default:
        return orientacao;
    }
  }

  CasaDoTabuleiro _avancar(CasaDoTabuleiro casa, Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return CasaDoTabuleiro(casa.linha - 1, casa.coluna);
      case Orientacao.direita:
        return CasaDoTabuleiro(casa.linha, casa.coluna + 1);
      case Orientacao.baixo:
        return CasaDoTabuleiro(casa.linha + 1, casa.coluna);
      case Orientacao.esquerda:
        return CasaDoTabuleiro(casa.linha, casa.coluna - 1);
      default:
        return casa;
    }
  }

  void _mostrarDialogoResultado(
      BuildContext context, bool resultado, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(resultado ? 'Parabéns!' : 'Erro!'),
          content: Text(resultado
              ? 'Você acertou a posição final!'
              : 'Você errou a posição final.'),
          actions: resultado
              ? provider.nivelAtual >= (niveis.length + niveis2.length) - 1
                  ? [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text('Voltar ao início'),
                      )
                    ]
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          provider.proximoNivel();
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
                        child: const Text('Próximo nível'),
                      ),
                    ]
              : [
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

  double _getRotationAngle(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return 0.0;
      case Orientacao.direita:
        return 0.5 * 3.14;
      case Orientacao.baixo:
        return 3.14;
      case Orientacao.esquerda:
        return 1.5 * 3.14;
      default:
        return 0.0;
    }
  }
}
