# Verilog Sudoku: Projeto prático de Circuitos Digitais

Projeto desenvolvido para a disciplina de Laboratório de Circuitos Digitais, ofertada pela UFLA.

## Desenvolvedores:

* [Gabriel Coelho Costa](https://github.com/gabrielzinCoelho)
* [Isac Gonçalves Cunha](https://github.com/Caquizeraa)

## Sobre o projeto

Foi implementado um jogo **Sudoku** utilizando o kit **FPGA DE10-Lite Altera**. Além disso, foi utilizada a linguagem de descrição de hardware **Verilog** para o desenvolvimento do projeto.

Inicialmente, o tabuleiro irá aparecer no monitor via saída VGA, a partir de um jogo sudoku já carregado na memória. O jogador preencherá o tabuleiro utilizando os switches e keys da placa e, a cada nova entrada, há uma verificação se o valor inserido está correto. O jogo é finalizado quando todo o tabuleiro for preenchido corretamente ou quando um número errado for inserido na matriz.

Além das funcionalidades básicas de um sudoku, a dupla decidiu expandir o escopo do projeto visando tornar o jogo o mais rico possível. Sendo assim, foi incrementado o **"modo dica"** (leds acesos acima dos swiches), o qual será mais detalhado adiante.

<p align="center">
  <img src="./readmeFiles/apresentacao.gif" alt="Funcionamento do jogo">
</p>

## Detalhes da implementação

<p align="center">
  <img src="./readmeFiles/visaoGeralCircuito.png" alt="Visão Geral do Circuito">
</p>

### Circuito Detector de Borda (Edge Detector)

<p align="center">
  <img src="./readmeFiles/edgeDetector.png" alt="Circuito Detector de Borda">
</p>

O circuito detector de borda é responsável por transformar o pressionamento de um dos botões (EnterKey e ResetKey), que pode perdurar por vários clock's, em apenas um pulso de clock.

Para isso, ele conta com dois **FF's do tipo D** conectados em série.  A saída é o resultado de uma porta **AND** com o valor salvo no primeiro FF e a negação do valor salvo no segundo FF. Nesse caso, a saída ocorre em nível alto se a saída do primeiro FF for 1 e do segundo for 0. Logo, o circuito se torna sensível apenas ao primeiro clock em que um dos botões é pressionado (visto que nos próximos clock, enquanto o botão se mantém pressionado o segundo flip-flop irá receber a entrada em nível alto do primeiro flip-flop).

```
assign rising_edge = ~ffs[1] & ffs[0];
```
```
pulse <= (rstn == 0) ? 1'b0 : rising_edge;
```



