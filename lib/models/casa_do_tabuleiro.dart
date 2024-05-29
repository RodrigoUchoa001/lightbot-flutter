import 'package:lightbot_flutter/models/orientacao.dart';

class CasaDoTabuleiro {
  final int linha;
  final int coluna;
  late bool objetoPresente; // Atributo para objeto presente
  late bool roboPresente;
  late Orientacao orientacao;

  CasaDoTabuleiro(this.linha, this.coluna, {this.objetoPresente = false}) {
    roboPresente = false;
    orientacao = Orientacao.cima;
  }
}
