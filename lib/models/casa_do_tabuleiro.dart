class CasaDoTabuleiro {
  final int linha;
  final int coluna;
  late bool objetoPresente;
  late bool roboPresente;

  CasaDoTabuleiro(this.linha, this.coluna, {this.objetoPresente = false}) {
    roboPresente = false;
  }
}
