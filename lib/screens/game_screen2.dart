import 'package:flutter/material.dart';
import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';
import 'package:lightbot_flutter/models/orientacao.dart';
import 'package:lightbot_flutter/niveis/niveis.dart';
import 'package:lightbot_flutter/providers/game_provider.dart';
import 'package:lightbot_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';

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
                      });
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lightbot nível ${provider.nivelAtual + 1}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.tabuleiro.colunas,
              ),
              itemCount: widget.tabuleiro.linhas * widget.tabuleiro.colunas,
              itemBuilder: (context, index) {
                int linha = index ~/ widget.tabuleiro.colunas;
                int coluna = index % widget.tabuleiro.colunas;
                CasaDoTabuleiro casa = widget.tabuleiro.casas[linha][coluna];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _casaSelecionada = CasaDoTabuleiro(linha, coluna);
                    });
                    _iniciarAnimacao(linha, coluna);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: _casaSelecionada != null &&
                              _casaSelecionada!.linha == linha &&
                              _casaSelecionada!.coluna == coluna
                          ? Colors.amber
                          : casa.objetoPresente
                              ? Colors.grey
                              : linha ==
                                          provider
                                              .tabuleiro.posicaoVitoria.linha &&
                                      coluna ==
                                          provider
                                              .tabuleiro.posicaoVitoria.coluna
                                  ? Colors.green
                                  : Colors.white,
                    ),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        if (linha == _posicaoRobo.linha &&
                            coluna == _posicaoRobo.coluna) {
                          return Transform.rotate(
                            angle: _getRotationAngle(_orientacaoRobo),
                            child: const Icon(Icons.arrow_upward,
                                color: Colors.blue, size: 48),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Em qual casa o Robô vai parar se ele seguir a seguinte sequência de Movimentos?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10.0,
                  children: widget.sequenciaMovimentos.map((comando) {
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
}
