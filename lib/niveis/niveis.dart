import 'package:lightbot_flutter/models/casa_do_tabuleiro.dart';
import 'package:lightbot_flutter/models/tabuleiro.dart';

List<Tabuleiro> niveis = [
  // Nível 1
  Tabuleiro(
    3, // Linhas
    3, // Colunas
    [
      [
        CasaDoTabuleiro(0, 0),
        CasaDoTabuleiro(0, 1),
        CasaDoTabuleiro(0, 2),
      ],
      [
        CasaDoTabuleiro(1, 0),
        CasaDoTabuleiro(1, 1, objetoPresente: true),
        CasaDoTabuleiro(1, 2)
      ],
      [
        CasaDoTabuleiro(2, 0),
        CasaDoTabuleiro(2, 1),
        CasaDoTabuleiro(2, 2, objetoPresente: true)
      ],
    ],
    CasaDoTabuleiro(0, 0),
    CasaDoTabuleiro(2, 1),
  ),

  // Nível 2
  Tabuleiro(
    4, // Linhas
    4, // Colunas
    [
      [
        CasaDoTabuleiro(0, 0),
        CasaDoTabuleiro(0, 1),
        CasaDoTabuleiro(0, 2),
        CasaDoTabuleiro(0, 3)
      ],
      [
        CasaDoTabuleiro(1, 0),
        CasaDoTabuleiro(1, 1, objetoPresente: true),
        CasaDoTabuleiro(1, 2, objetoPresente: true),
        CasaDoTabuleiro(1, 3)
      ],
      [
        CasaDoTabuleiro(2, 0),
        CasaDoTabuleiro(2, 1, objetoPresente: true),
        CasaDoTabuleiro(2, 2),
        CasaDoTabuleiro(2, 3)
      ],
      [
        CasaDoTabuleiro(3, 0),
        CasaDoTabuleiro(3, 1),
        CasaDoTabuleiro(3, 2),
        CasaDoTabuleiro(3, 3, objetoPresente: true)
      ],
    ],
    CasaDoTabuleiro(0, 0),
    CasaDoTabuleiro(3, 2),
  ),

  // Nível 3
  Tabuleiro(
    5, // Linhas
    5, // Colunas
    [
      [
        CasaDoTabuleiro(0, 0),
        CasaDoTabuleiro(0, 1),
        CasaDoTabuleiro(0, 2),
        CasaDoTabuleiro(0, 3),
        CasaDoTabuleiro(0, 4)
      ],
      [
        CasaDoTabuleiro(1, 0),
        CasaDoTabuleiro(1, 1, objetoPresente: true),
        CasaDoTabuleiro(1, 2, objetoPresente: true),
        CasaDoTabuleiro(1, 3, objetoPresente: true),
        CasaDoTabuleiro(1, 4)
      ],
      [
        CasaDoTabuleiro(2, 0),
        CasaDoTabuleiro(2, 1, objetoPresente: true),
        CasaDoTabuleiro(2, 2),
        CasaDoTabuleiro(2, 3, objetoPresente: true),
        CasaDoTabuleiro(2, 4)
      ],
      [
        CasaDoTabuleiro(3, 0),
        CasaDoTabuleiro(3, 1, objetoPresente: true),
        CasaDoTabuleiro(3, 2, objetoPresente: true),
        CasaDoTabuleiro(3, 3, objetoPresente: true),
        CasaDoTabuleiro(3, 4)
      ],
      [
        CasaDoTabuleiro(4, 0),
        CasaDoTabuleiro(4, 1),
        CasaDoTabuleiro(4, 2),
        CasaDoTabuleiro(4, 3),
        CasaDoTabuleiro(4, 4, objetoPresente: true)
      ],
    ],
    CasaDoTabuleiro(2, 2),
    CasaDoTabuleiro(4, 2),
  ),
];
