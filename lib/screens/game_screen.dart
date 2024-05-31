import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/orientacao.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    print(
        "posicao robo: ${provider.tabuleiro.posicaoRobo!.linha},${provider.tabuleiro.posicaoRobo!.coluna}");
    print(
        "posicao vitoria: ${provider.tabuleiro.posicaoVitoria.linha}, ${provider.tabuleiro.posicaoVitoria.coluna}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lightbot Flutter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, provider, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: provider.tabuleiro.colunas,
                  ),
                  itemCount:
                      provider.tabuleiro.linhas * provider.tabuleiro.colunas,
                  itemBuilder: (context, index) {
                    int linha = index ~/ provider.tabuleiro.colunas;
                    int coluna = index % provider.tabuleiro.colunas;
                    CasaDoTabuleiro casa =
                        provider.tabuleiro.casas[linha][coluna];

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        color: casa.objetoPresente
                            ? Colors.grey
                            : linha ==
                                        provider
                                            .tabuleiro.posicaoVitoria.linha &&
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
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<GameProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    const Text(
                      'Comandos Selecionados:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 10.0,
                      children: provider.comandos.map((comando) {
                        if (comando == Direcao.virarEsquerda) {
                          return const Chip(
                              label: Icon(Icons.rotate_left_rounded));
                        }
                        if (comando == Direcao.virarDireita) {
                          return const Chip(
                              label: Icon(Icons.rotate_right_rounded));
                        }
                        return const Chip(label: Icon(Icons.straight_rounded));
                        // return Chip(
                        //   label: Text(comando.toString().split('.').last),
                        // );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<GameProvider>(context, listen: false)
                          .adicionarComando(Direcao.virarEsquerda);
                    },
                    child: const Icon(Icons.rotate_left_rounded, size: 32),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<GameProvider>(context, listen: false)
                          .adicionarComando(Direcao.avancar);
                    },
                    child: const Icon(Icons.straight_rounded, size: 32),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<GameProvider>(context, listen: false)
                          .adicionarComando(Direcao.virarDireita);
                    },
                    child: const Icon(Icons.rotate_right_rounded, size: 32),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<GameProvider>(context, listen: false)
                          .executarComandos(context);
                    },
                    child: const Text('Executar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
