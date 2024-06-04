# lightbot_flutter

Um versão do jogo Light Bot, desenvolvido usando flutter para ser jogado em dispositivos mobile Android.

Neste jogo, você controla um robô dentro de um tabuleiro para fazer ele chegar a uma casa específica. Para controlar o robô, existem três botões: Virar a Esquerda, Ir em frente e Virar a Direita. O objetivo é escolher uma sequência de movimentos que levam a casa verde.

## Screenshots

### Tela Inicial:
Tela que aparece ao entrar no jogo.
![Alt text](doc_imgs/tela_inicial.png)

### Tela de Escolha de níveis
Tela de escolha de níveis, onde é possível escolher entre as três fases da primeira mecânica, ou as três fases da segunda mecânica.
![Alt text](doc_imgs/escolha_de_nivel.png)

### Tela de Fase da Mecânica 1
Tela de uma fase da primeira mecânica. Nessas 3 primeiras fases, o jogador deve escolher uma sequência de movimentos usando os três botões abaixo da tela. Após escolher, o jogador aperta em "executar" para rodar a sequência de movimentos.

Se o jogador acertar a sequência, aparecerá um dialog com uma mensagem de "vitória" e um botão que leva a próxima fase. Caso o jogador erre, após rodar a sequência, aparecerá um dialog indicando que o jogador errou, e um botão para repetir a fase.

![Alt text](doc_imgs/mecanica_1.png)

### Tela de Fase da Mecânica 2

Tela de uma fase da mecânica 2. As fases da segunda mecânica são o oposto dos da primeira. Aqui, o jogador recebe uma sequência de movimentos e deve apertar, no tabuleiro, na casa que ele acredita que o robô irá chegar ao finalizar a sequência.

Após apertar em uma casa, o jogo irá exibir uma animação demonstrando o robô rodando a sequência. Caso o jogador acerte a casa, aparecerá um dialog com uma mensagem de "sucesso", junto com um botão que leva a primeira fase. Caso erre, irá aparecer uma mensagem de erro com um botão para repetir a fase.
![Alt text](doc_imgs/mecanica_2.png)

## Download
Para instalar o jogo no seu próprio celular Android, o arquivo .apk pode ser baixado [aqui](release-apk/app-release.apk).

## Referências
[Light-Bot](https://www.gameflare.com/online-game/light-bot/)