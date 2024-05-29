import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/orientacao.dart';

class Tabuleiro {
  final int linhas;
  final int colunas;
  List<List<CasaDoTabuleiro>> casas;
  late CasaDoTabuleiro? posicaoRobo;
  late CasaDoTabuleiro posicaoVitoria;

  Tabuleiro(this.linhas, this.colunas, this.casas, this.posicaoVitoria) {
    _validarCasas(casas);
  }

  void _validarCasas(List<List<CasaDoTabuleiro>> casas) {
    for (final linha in casas) {
      for (final casa in linha) {
        if (casa.objetoPresente && casa.roboPresente) {
          throw Exception(
              'Uma casa não pode ter objeto e robô ao mesmo tempo.');
        }
      }
    }
  }

  void colocarRobo(int linha, int coluna, Orientacao orientacaoInicial) {
    if (isDentroDosLimites(linha, coluna)) {
      casas[linha][coluna].roboPresente = true;
      if (posicaoRobo != null) {
        posicaoRobo!.roboPresente = false;
      }
      posicaoRobo = casas[linha][coluna];
      posicaoRobo!.orientacao = orientacaoInicial;
    }
  }

  bool isDentroDosLimites(int linha, int coluna) {
    return linha >= 0 && linha < linhas && coluna >= 0 && coluna < colunas;
  }

  void moverRobo(Direcao comando) {
    Orientacao novaOrientacao;

    switch (comando) {
      case Direcao.virarEsquerda:
        novaOrientacao =
            _novaOrientacaoVirandoEsquerda(posicaoRobo!.orientacao);
        break;
      case Direcao.virarDireita:
        novaOrientacao = _novaOrientacaoVirandoDireita(posicaoRobo!.orientacao);
        break;
      default:
        throw Exception('Comando inválido: $comando');
    }

    int novaLinha = posicaoRobo!.linha + _movimentoLinha(novaOrientacao);
    int novaColuna = posicaoRobo!.coluna + _movimentoColuna(novaOrientacao);

    if (isDentroDosLimites(novaLinha, novaColuna) &&
        !casas[novaLinha][novaColuna].objetoPresente) {
      colocarRobo(novaLinha, novaColuna, novaOrientacao);
      posicaoRobo!.orientacao = novaOrientacao;
    }
  }

  bool verificarVitoria() {
    if (posicaoRobo == posicaoVitoria) {
      return true;
    }
    return false;
  }

  Orientacao _novaOrientacaoVirandoEsquerda(Orientacao orientacaoAtual) {
    switch (orientacaoAtual) {
      case Orientacao.cima:
        return Orientacao.esquerda;
      case Orientacao.baixo:
        return Orientacao.direita;
      case Orientacao.esquerda:
        return Orientacao.baixo;
      case Orientacao.direita:
        return Orientacao.cima;
    }
  }

  Orientacao _novaOrientacaoVirandoDireita(Orientacao orientacaoAtual) {
    switch (orientacaoAtual) {
      case Orientacao.cima:
        return Orientacao.direita;
      case Orientacao.baixo:
        return Orientacao.esquerda;
      case Orientacao.esquerda:
        return Orientacao.cima;
      case Orientacao.direita:
        return Orientacao.baixo;
    }
  }

  int _movimentoLinha(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.cima:
        return -1;
      case Orientacao.baixo:
        return 1;
      default:
        return 0;
    }
  }

  int _movimentoColuna(Orientacao orientacao) {
    switch (orientacao) {
      case Orientacao.esquerda:
        return -1;
      case Orientacao.direita:
        return 1;
      default:
        return 0;
    }
  }
}
