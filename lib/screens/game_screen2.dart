import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';
import 'package:lightbot_flutter/models/orientacao.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart'; // Escolha um tema de sua preferência

class GameScreen2 extends StatefulWidget {
  final Tabuleiro tabuleiro;
  final List<Direcao> sequenciaMovimentos;

  const GameScreen2(
      {super.key, required this.tabuleiro, required this.sequenciaMovimentos});

  @override
  _GameScreen2State createState() => _GameScreen2State();
}

class _GameScreen2State extends State<GameScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late CasaDoTabuleiro _posicaoInicialRobo;
  late CasaDoTabuleiro _posicaoRobo;
  late Orientacao _orientacaoRobo;
  CasaDoTabuleiro? _casaSelecionada;
  String _codigoGerado = '''
void main(){
  robo.fazerSequenciaDeMovimentos();
  if (robo.casaAtual == (x, y)) {
      print("resposta correta!");
  } else {
      print("resposta errada!");
  }
}
''';

  @override
  void initState() {
    super.initState();
    _posicaoInicialRobo = CasaDoTabuleiro(
      widget.tabuleiro.posicaoRobo!.linha,
      widget.tabuleiro.posicaoRobo!.coluna,
    );
    _posicaoRobo = _posicaoInicialRobo;
    _orientacaoRobo = widget.tabuleiro.orientacaoRobo;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _iniciarAnimacao(int linha, int coluna) async {
    var robo = CasaDoTabuleiro(
      _posicaoInicialRobo.linha,
      _posicaoInicialRobo.coluna,
    );
    var orientacao = widget.tabuleiro.orientacaoRobo;

    for (var comando in widget.sequenciaMovimentos) {
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
      setState(() {
        _posicaoRobo = robo;
        _orientacaoRobo = orientacao;
      });
      _controller.reset();
      await _controller.forward();
    }

    bool resultado = robo.linha == linha && robo.coluna == coluna;
    _mostrarDialogoResultado(
        context, resultado, Provider.of<GameProvider>(context, listen: false));
    // _gerarCodigo(linha, coluna);
  }

  bool _verificarEscolha(int linha, int coluna) {
    var robo = CasaDoTabuleiro(
      widget.tabuleiro.posicaoRobo!.linha,
      widget.tabuleiro.posicaoRobo!.coluna,
    );
    var orientacao = widget.tabuleiro.orientacaoRobo;

    for (var comando in widget.sequenciaMovimentos) {
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

                          provider.proxSequencia();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GameScreen2(
                                tabuleiro: niveis2[
                                    provider.nivelAtual - niveis.length],
                                sequenciaMovimentos:
                                    sequenciaMecanica2[provider.sequenciaAtual],
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
                      setState(() {
                        _posicaoRobo = _posicaoInicialRobo;
                        _orientacaoRobo = widget.tabuleiro.orientacaoRobo;
                        _casaSelecionada = null;
                        _codigoGerado = '''
                          robo.fazerSequenciaDeMovimentos();
                          if (robo.casaAtual == (x, y)) {
                              print("resposta correta!");
                          } else {
                              print("resposta errada!");
                          }
                        '''; // Limpa o código gerado
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lightbot nível ${provider.nivelAtual + 1}'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxHeight = constraints.maxHeight;
                  double maxWidth = constraints.maxWidth;
                  int linhas = widget.tabuleiro.linhas;
                  int colunas = widget.tabuleiro.colunas;
                  double cellSize = (maxHeight < maxWidth / colunas * linhas)
                      ? maxHeight / linhas
                      : maxWidth / colunas;
                  return SizedBox(
                    height: cellSize * linhas,
                    width: cellSize * colunas,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: colunas,
                      ),
                      itemCount: linhas * colunas,
                      itemBuilder: (context, index) {
                        int linha = index ~/ colunas;
                        int coluna = index % colunas;
                        CasaDoTabuleiro casa =
                            widget.tabuleiro.casas[linha][coluna];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _casaSelecionada = CasaDoTabuleiro(linha, coluna);
                            });
                            _iniciarAnimacao(linha, coluna);
                            _codigoGerado = '''
void main(){
  robo.fazerSequenciaDeMovimentos();
  if (robo.casaAtual == ($linha,$coluna)) {
      print("resposta correta!");
  } else {
      print("resposta errada!");
  }
}
                              ''';
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 2.0),
                              color: _casaSelecionada != null &&
                                      _casaSelecionada!.linha == linha &&
                                      _casaSelecionada!.coluna == coluna
                                  ? Colors.amber
                                  : casa.objetoPresente
                                      ? Colors.grey
                                      : linha ==
                                                  widget.tabuleiro
                                                      .posicaoVitoria.linha &&
                                              coluna ==
                                                  widget.tabuleiro
                                                      .posicaoVitoria.coluna
                                          ? Colors.green
                                          : Colors.white,
                            ),
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                if (linha == _posicaoRobo.linha &&
                                    coluna == _posicaoRobo.coluna) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      _getRobotImage(_orientacaoRobo),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Em qual casa o Robô vai parar se ele seguir a seguinte sequência de Movimentos?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.sequenciaMovimentos.map((comando) {
                          return Chip(
                            label: Text(comando.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Código gerado:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: HighlightView(
                            _codigoGerado!,
                            language: 'dart',
                            theme: githubTheme,
                            padding: const EdgeInsets.all(8),
                            textStyle: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
