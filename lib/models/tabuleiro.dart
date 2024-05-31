import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/direcao.dart';
import 'package:lightbot_flutter/models/orientacao.dart';

class Tabuleiro {
  final int linhas;
  final int colunas;
  final List<List<CasaDoTabuleiro>> casas;
  late CasaDoTabuleiro? posicaoRobo;
  late CasaDoTabuleiro posicaoVitoria;
  late Orientacao orientacaoRobo; // Orientação do robô agora no Tabuleiro

  Tabuleiro(this.linhas, this.colunas, this.casas, this.posicaoRobo,
      this.posicaoVitoria) {
    _validarCasas(casas);
    orientacaoRobo = Orientacao.direita;
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

  void colocarRobo(int linha, int coluna) {
    if (isDentroDosLimites(linha, coluna)) {
      casas[linha][coluna].roboPresente = true;
      if (posicaoRobo != null) {
        posicaoRobo!.roboPresente = false;
      }
      posicaoRobo = casas[linha][coluna];
    }
  }

  bool isDentroDosLimites(int linha, int coluna) {
    return linha >= 0 && linha < linhas && coluna >= 0 && coluna < colunas;
  }

  void moverRobo(Direcao comando) {
    switch (comando) {
      case Direcao.virarEsquerda:
        orientacaoRobo = _novaOrientacaoVirandoEsquerda(orientacaoRobo);
        break;
      case Direcao.virarDireita:
        orientacaoRobo = _novaOrientacaoVirandoDireita(orientacaoRobo);
        break;
      case Direcao.avancar:
        int novaLinha = posicaoRobo!.linha + _movimentoLinha(orientacaoRobo);
        int novaColuna = posicaoRobo!.coluna + _movimentoColuna(orientacaoRobo);

        if (isDentroDosLimites(novaLinha, novaColuna) &&
            !casas[novaLinha][novaColuna].objetoPresente) {
          colocarRobo(novaLinha, novaColuna);
        }
        break;
      default:
        throw Exception('Comando inválido: $comando');
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
