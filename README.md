# Verilog Sudoku: Projeto prático de Circuitos Digitais

Projeto desenvolvido para a disciplina de Laboratório de Circuitos Digitais, ofertada pela UFLA.

## Desenvolvedores:

* [Gabriel Coelho Costa](https://github.com/gabrielzinCoelho)
* [Isac Gonçalves Cunha](https://github.com/Caquizeraa)

## Sobre o projeto

Foi implementado um jogo **Sudoku** utilizando o kit **FPGA DE10-Lite Altera**. Além disso, foi utilizada a lingaguem de descrição de hardware **Verilog** para o desenvolvimento do projeto.

Inicialmente, o tabuleiro irá aparecer no monitor via saída VGA, a partir de um jogo sudoku já carregado na memória. O jogador preencherá o tabuleiro utilizando os switches e keys da placa e, a cada nova entrada, há uma verificação se o valor inserido está correto. O jogo é finalizado quando todo o tabuleiro for preenchido corretamente ou quando um número errado for inserido na matriz.

Além das funcionalidades básicas de um sudoku, a dupla decidiu expandir o escopo do projeto visando tornar o jogo o mais rico possível. Sendo assim, foi incrementado o **"modo dica"**, o qual será mais detalhado adiante.

<p align="center">
  <img src="./readmeFiles/apresentacao.gif" alt="Demo animated">
</p>



