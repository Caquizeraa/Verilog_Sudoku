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

### Caixa preta do Sudoku (PixelGen)

Circuito responsável por implementar toda a lógica do jogo. Recebe as entradas da placa e as interpreta para o correto andamento do jogo. Além disso, recebe como entrada diversas informações referentes à renderização do jogo no monitor, provenientes do circuito **VGASync**, e tem como função determinar o valor RGB do pixel expecificado (**pixel_x** e **pixel_y**). Também manipula as demais saídas da placa, como os **leds** e **displays de sete segmentos**.

<p align="center">
  <img src="./readmeFiles/pixelGen.gif" alt="PixelGen">
</p>

### Sincronizadores Switches (AsyncSwitchSynchronizer)

Circuito responsável por receber os swiches da placa e os sincroniza com o sinal de clock.

Cada um dos switches é sincronziado individualmente pelo circuito **AsyncSwitchSincronizer** e a saída dos dez switches sincronizados é comprimida em um array de 10 bits. 

O circuito **AsyncSwitchSincronizer** possui dois **flip-flops do tipo D** conectados em série e ativos na borda de subida do clock. Dessa forma, há maior confiabilidade no valor de saída produzido pelo circuito.

<p align="center">
  <img src="./readmeFiles/switchSync.png" alt="Sincronizadores do Switch">
</p>

### Registradores

Os registradores são responsáveis por salvar dados que podem ser acessíveis por outros circuitos. Possuem uma entrada **enable**, que quando ativa em alto permite que novos valores sejam sobreescritos, e uma entrada **clear**, que reseta o valor salvo para o valor inicial.

O projeto conta com inúmeros desses circuitos instanciados de forma que, em conjunto, eles armazenam o estado global do jogo. Dessa forma, eles permitem que diferentes circuitos se comuniquem e que a máquina de estados possa determinar de maneira correta qual tarefa deve ser executada em determinado momento. Assim, os demais circuitos do sistema atualizam os valores dos registradores e também os consultam para garantir o funcionamento do jogo.

Ao todo são 7 registradores: **linha**, **coluna**, **valor**, **posicaoValida**, **verificaJogo**, **sudokuJogador**, **sudokuFinal**.

<p align="center">
  <img src="./readmeFiles/registrador.png" alt="Sincronizadores do Switch">
</p>


