import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/orientacao.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart'; // Escolha um tema de sua preferência

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Forçar orientação paisagem
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    final provider = Provider.of<GameProvider>(context);

    print(
        "posicao robo: ${provider.tabuleiro.posicaoRobo!.linha},${provider.tabuleiro.posicaoRobo!.coluna}");
    print(
        "posicao vitoria: ${provider.tabuleiro.posicaoVitoria.linha}, ${provider.tabuleiro.posicaoVitoria.coluna}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Lightbot nível ${provider.nivelAtual + 1}'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Consumer<GameProvider>(
                    builder: (context, provider, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double maxHeight = constraints.maxHeight;
                          double maxWidth = constraints.maxWidth;
                          int linhas = provider.tabuleiro.linhas;
                          int colunas = provider.tabuleiro.colunas;
                          double cellSize =
                              (maxHeight < maxWidth / colunas * linhas)
                                  ? maxHeight / linhas
                                  : maxWidth / colunas;

                          return SingleChildScrollView(
                            child: SizedBox(
                              height: cellSize * linhas,
                              width: cellSize * colunas,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: colunas,
                                  childAspectRatio: 1,
                                ),
                                itemCount: linhas * colunas,
                                itemBuilder: (context, index) {
                                  int linha = index ~/ colunas;
                                  int coluna = index % colunas;
                                  CasaDoTabuleiro casa =
                                      provider.tabuleiro.casas[linha][coluna];

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2.0),
                                      color: casa.objetoPresente
                                          ? Colors.grey
                                          : linha ==
                                                      provider
                                                          .tabuleiro
                                                          .posicaoVitoria
                                                          .linha &&
                                                  coluna ==
                                                      provider.tabuleiro
                                                          .posicaoVitoria.coluna
                                              ? Colors.green
                                              : Colors.white,
                                    ),
                                    child: linha ==
                                                provider.tabuleiro.posicaoRobo!
                                                    .linha &&
                                            coluna ==
                                                provider.tabuleiro.posicaoRobo!
                                                    .coluna
                                        ? Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Image.asset(
                                              _getRobotImage(provider
                                                  .tabuleiro.orientacaoRobo),
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Código gerado:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: HighlightView(
                          "void main(){\n    Robo robo = Robo();\n${_gerarCodigo(provider.comandos)}\n}",
                          language: 'dart', // ou a linguagem que você desejar
                          theme: githubTheme, // ou outro tema que você preferir
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Comandos Selecionados:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
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
    );
  }

  String _gerarCodigo(List<Direcao> comandos) {
    return comandos.map((comando) {
      if (comando == Direcao.virarEsquerda) {
        return '    robo.virarEsquerda();';
      } else if (comando == Direcao.virarDireita) {
        return '    robo.virarDireita();';
      } else if (comando == Direcao.avancar) {
        return '    robo.irEmFrente();';
      }
      return '';
    }).join('\n');
  }

  String _getRobotImage(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return 'assets/images/robot__up.png';
      case Orientacao.direita:
        return 'assets/images/robot__right.png';
      case Orientacao.baixo:
        return 'assets/images/robot__down.png';
      case Orientacao.esquerda:
        return 'assets/images/robot__left.png';
      default:
        return 'assets/images/robot__up.png';
    }
  }
}
