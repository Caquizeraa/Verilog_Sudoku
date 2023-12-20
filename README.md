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

### Caixa preta do Sudoku (PixelGen)

<p align="center">
  <img src="./readmeFiles/pixelGen.gif" alt="PixelGen">
</p>

Circuito responsável por implementar toda a lógica do jogo. Recebe as entradas da placa e as interpreta para o correto andamento do jogo. Além disso, recebe como entrada diversas informações referentes à renderização do jogo no monitor, provenientes do circuito **VGASync**, e tem como função determinar o valor RGB do pixel expecificado (**pixel_x** e **pixel_y**). Também manipula as demais saídas da placa, como os **leds** e **displays de sete segmentos**.

### Máquina de Estados (EstadoJogo)

<p align="center">
  <img src="./readmeFiles/diagramaEstados.png" alt="Máquina de Estados">
</p>

<p align="center">
  <img src="./readmeFiles/estadoJogo.png" alt="Máquina de Estados">
</p>

A cada clock, o estado atual é atualizado com o valor salvo do estado seguinte (pode ser, inclusive, o próprio estado atual).

```
if(!rstn)
  state_reg <= recebeLinha;
else
	state_reg <= state_next;
```

O cálculo do próximo estado é feito considerando o estado atual e o valor salvo nos registradores. Sempre que algum dos registradores relacionados a lógica dos estados é alterado, a variável que armazena o estado seguinte é atualizada.

Todos circuitos, cada um ativo em um estado específico, executam suas funções e, para garantir que o próximo estado seja computado corretamente, atualizam os valores dos registradores associados a ele. Essa mudança é percebida pelo circuito da máquina de estados que consulta o novo valor dos registradores e avalia qual deve ser o estado seguinte.

Por exemplo, considere o estado verifica jogo. Tal estado é responsável por verificar se o valor inserido em determinada posição (já verificada como uma posição válida pelo estado anterior) constitui uma jogada válida. Além disso, ele deve determinar o resultado dessa jogada: uma jogada inválida necessariamente finaliza o jogo, porém, uma jogada válida pode encerrar o jogo ou não, dependendo do tabuleiro estar completo ou não. No caso do jogo ainda não se encerrar, todos registradores relacionados à máquina de estados devem ser resetados para que estejam disponíveis para a próxima jogada (caso contrário a máquina de estados consultaria valores antigos e pularia diversos estados).

Ainda nesse caso específico do estado de verifica jogada, dependendo da jogada feita ele pode exibir 3 saídas possíveis, que serão gravadas em seus registradores e, posteriormente, consideradas pela máquina de estados para avançar para o estado adequado. Tais saídas contam com 3 bits: o primeiro informa se o circuito já terminou sua tarefa de computar a jogada  (0 em caso negativo e 1 em caso positivo). Enquanto esse primeiro bit for 0 a máquina de estados garante que vai permancer no estado de verifica jogada. Os próximos dois bits (acertou e não acabou -> 00, acertou e acabou -> 01, errou -> 10) determinarão, então,  o pŕoximo estado.

```
case(state_reg)

  recebeLinha:
    if(registradores[16:13]) state_next = recebeColuna;
    else state_next = recebeLinha;

  recebeColuna:
    if(registradores[12:9]) state_next = verificaPos;
    else state_next = recebeColuna;

  recebeValor:
    if(registradores[8:5]) state_next = verificaJogo;
    else state_next = recebeValor;

  verificaPos:
    if(registradores[4]) begin
      if(registradores[3])
        state_next = recebeValor;
      else
        state_next = recebeLinha;
    end
    else state_next = verificaPos;

  verificaJogo:
    if(registradores[2]) begin
      case (registradores[1:0])
        2'b00:
          state_next = recebeLinha; // jogada valida e jogo em andamento
        2'b01:
          state_next = fimJogo; // jogada valida e jogo completo
        2'b10:
          state_next = fimJogo; // jogada invalida (fim jogo)
        default:
          state_next = verificaJogo;
      endcase
    end
    else state_next = verificaJogo;
    
  default:
    state_next = fimJogo;
endcase
```

### Ativador de Circuitos (DemuxEstado)

<p align="center">
  <img src="./readmeFiles/demuxEstado.png" alt="Demux do Estado">
</p>

Circuito responsável por ativar apenas o circuito associado ao estado atual.

Utiliza a saída da máquina de estados como entrada de seleção de um demultiplexador, que passa a entrada com valor 1, para a porta **enable** de apenas um dos circuitos que estão conectados.

```
case (estadoJogo)

  recebeLinha: begin
    enableRecebeEntrada <= 1;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 0;
    enableFimJogo <= 0; 
  end

  recebeColuna: begin
    enableRecebeEntrada <= 1;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 0;
    enableFimJogo <= 0; 
  end

  recebeValor: begin
    enableRecebeEntrada <= 1;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 0;
    enableFimJogo <= 0; 
  end

  verificaPos: begin
    enableRecebeEntrada <= 0;
    enableVerificaPos <= 1;
    enableVerificaJogo <= 0;
    enableFimJogo <= 0; 
  end

  verificaJogo: begin
    enableRecebeEntrada <= 0;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 1;
    enableFimJogo <= 0; 
  end

  fimJogo: begin
    enableRecebeEntrada <= 0;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 0;
    enableFimJogo <= 1; 
  end

  default: begin
    enableRecebeEntrada <= 1;
    enableVerificaPos <= 0;
    enableVerificaJogo <= 0;
    enableFimJogo <= 0; 
  end
      
endcase
```

### Circuito Detector de Borda (Edge Detector)

###### * EdgeDetector: Código de autoria do docente [Bruno de Abreu](https://github.com/brabreus)

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

### Sincronizadores Switches (AsyncSwitchSynchronizer)

<p align="center">
  <img src="./readmeFiles/switchSync.png" alt="Sincronizadores do Switch">
</p>

Circuito responsável por receber os swiches da placa e os sincroniza com o sinal de clock.

Cada um dos switches é sincronziado individualmente pelo circuito **AsyncInputSincronizer** e a saída dos dez switches sincronizados é comprimida em um array de 10 bits. 

O circuito **AsyncInputSincronizer** possui dois **flip-flops do tipo D** conectados em série e ativos na borda de subida do clock. Dessa forma, há maior confiabilidade no valor de saída produzido pelo circuito.

###### * AsyncInputSincronizer: Código de autoria do docente [Bruno de Abreu](https://github.com/brabreus)

```
if(asyncn == 0) begin
		first_ff <= 0;
		second_ff <= 0;
end
else begin
		first_ff <= 1;
		second_ff <= first_ff;
end	
```
```
assign syncn = second_ff;
```

### Registradores

<p align="center">
  <img src="./readmeFiles/registrador.png" alt="Sincronizadores do Switch">
</p>

Os registradores são responsáveis por salvar dados que podem ser acessíveis por outros circuitos. Possuem uma entrada **enable**, que quando ativa em alto permite que novos valores sejam sobreescritos, e uma entrada **clear**, que reseta o valor salvo para o valor inicial.

O projeto conta com inúmeros desses circuitos instanciados de forma que, em conjunto, eles armazenam o estado global do jogo. Dessa forma, eles permitem que diferentes circuitos se comuniquem e que a máquina de estados possa determinar de maneira correta qual tarefa deve ser executada em determinado momento. Assim, os demais circuitos do sistema atualizam os valores dos registradores e também os consultam para garantir o funcionamento do jogo.

Ao todo são 7 registradores: **linha**, **coluna**, **valor**, **posicaoValida**, **verificaJogo**, **sudokuJogador**, **sudokuFinal**.

No momento da criação de cada um deles, o **Verilog** permite que sejam especificados parâmetros de instanciação. Nesse caso, cada registrador é criado com uma capacidade de armazenamento (número de bits) e com um valor inicial específicos. Assim, o circuito se adapta melhor a cada necessidade, se torna mais flexível e permite a sua reutilização em diferentes contextos.

```
if(!rstn)
	valorSalvo <= valorInicial;
else begin
	if(enable)
		valorSalvo <= dadoEntrada;
	else
		valorSalvo <= valorSalvo;
end
```
```
dadoSaida <= valorSalvo;
```

### Codificador dos Switches (CodificadorSwitch)

Circuito que atua como um **codificador de prioridade** e converte o valor dos switches em um número entre **1 e 9** (linha, coluna ou valor).

Cada switch é associado a um número no intervalo de 1 a 9 e, dessa forma, ele captura o switch com o valor mais alto e ignora o estado dos anteriores.

```
casex (switch)
	9'b1xxxxxxxx: switchCod = 4'd9;
	9'b01xxxxxxx: switchCod = 4'd8;
	9'b001xxxxxx: switchCod = 4'd7;
	9'b0001xxxxx: switchCod = 4'd6;
	9'b00001xxxx: switchCod = 4'd5;
	9'b000001xxx: switchCod = 4'd4;
	9'b0000001xx: switchCod = 4'd3;
	9'b00000001x: switchCod = 4'd2;
	9'b000000001: switchCod = 4'd1;
	default: switchCod = 4'd0;
endcase
```

### Recebe Entradas do Usuário (RecebeEntradas)

<p align="center">
  <img src="./readmeFiles/recebeEntradas.png" alt="Sincronizadores do Switch">
</p>

Circuito responsável por capturar a entrada do usuário nos switches e, dependendo do estado atual (máquina de estados), repassar esse valor para o registrador referente (linha, coluna ou valor).

Assim, ele utiliza o estado atual (proveniente da máquina de estados) como entrada de seleção para um demultiplexador que recebe o valor 1 na entrada e o transmite como enable a apenas um dos registradores. Dessa forma, ele passa a saída codificada dos switches para todos os registradores (linha, coluna e valor), mas apenas um deles recebe o sinal de enable em alto. 

```
if(keyEnter) begin // demux  registradores
			
	case (estadoJogo)
    3'b000: begin
      enableLinha = 1;
      enableColuna = 0;
      enableValor = 0;
    end
    
    3'b001: begin	
      enableLinha = 0;
      enableColuna = 1;
      enableValor = 0;
    end

    3'b011: begin
      enableLinha = 0;
      enableColuna = 0;
      enableValor = 1;
    end

    default: begin
      enableLinha = 0;
      enableColuna = 0;
      enableValor = 0;
    end
  endcase
  
end
```

### Mostra Entradas do Usuário (MostraEntradas)

<p align="center">
  <img src="./readmeFiles/mostraEntradas.png" alt="Mostra entradas do usuário">
</p>

Circuito responsável por mostras as entradas selecionadas pelo usuário nos **displays de sete segmentos**.

Instancia um circuito **SEG7_LUT** para cada um dos seis displays. 3 deles, referentes aos rótulos das entradas, permanecem sempre ativos e com valores fixos. Os outros 3, referentes aos valores inseridos pelo usuário, podem estar ativos e fixos, ativos e piscando ou então desligados.

Os 3 leds referentes às entradas do usuário são gerenciados individualmente pelo circuito **ControlaHex**.

O circuito **SEG7_LUT** basicamente codifica os valores de 1 a 9 e alguns caracteres para os bits que acendem corretamente cada segmento dos displays.

```
SEG7_LUT v5(.iDIG(4'ha), .oSEG(h5));
SEG7_LUT v3(.iDIG(4'hb), .oSEG(h3));
SEG7_LUT v1(.iDIG(4'hc), .oSEG(h1));

SEG7_LUT v4(.iDIG(saidaHexLinha), .oSEG(h4));
SEG7_LUT v2(.iDIG(saidaHexColuna), .oSEG(h2));
SEG7_LUT v0(.iDIG(saidaHexValor), .oSEG(h0));


ControlaHex #(.meuEstado(3'b000)) hexLinha(
  .clk(clk),
  .estadoJogo(estadoJogo), 
  .switchCod(switchCod),
  .registrador(regLinha),
  .hex(saidaHexLinha)
);

ControlaHex #(.meuEstado(3'b001)) hexColuna(
  .clk(clk),
  .estadoJogo(estadoJogo), 
  .switchCod(switchCod),
  .registrador(regColuna),
  .hex(saidaHexColuna)
);

ControlaHex #(.meuEstado(3'b011)) hexValor(
  .clk(clk),
  .estadoJogo(estadoJogo), 
  .switchCod(switchCod),
  .registrador(regValor),
  .hex(saidaHexValor)
);

```
### Gerencia os Displays de Entradas do Usuário (ControlaHex)

<p align="center">
  <img src="./readmeFiles/controlaHex.png" alt="Reseta entradas do usuário">
</p>

Circuito instanciado três vezes: gerenciar entrada de linha, coluna e valor.

Possui comparadores de magnitude e determina se o estado atual que o jogo se encontra é maior, menor ou igual ao estado que ele monitora (propositalmente, os valores de saída da máquina de estados foram organizados em ordem cronológica de execução).

Dessa forma, o circuito pode se encontrar em três situações:

  * Estado monitorado menor que o estado atual

    O led fica aceso de forma fixa e o valor mostrado provém dos registradores (entrada já foi capturada e salva nos registradores)

  * Estado monitorado igual ao estado atual

    O led fica piscando e o valor mostrado provém do valor definido nos switches (entrada está sendo captura nesse exato momento)

  * Estado monitorado maior que o estado atual

    O led fica desligado (as entradas anteriores ainda não foram selecionadas).

```
if(meuEstado < estadoJogo)begin
  //Led fixo
  valorHex <= registrador;
  enable <= 1'b1;
end

else if(meuEstado > estadoJogo)begin
  //Led apagado
  hex <= 4'he;
  enable <= 1'b0;
end

else begin
  //Led Piscando
  valorHex <= switchCod;
  enable <= saidaDivisor;
end
```
No caso em que o led está aceso de forma fixa, a entrada enable recebe o valor 1 a todo momento. De forma similar, no caso em que o led está apagado de forma fixa, a entrada enable recebe o valor 0 a todo momento. Porém, quando o led se sencontra piscando, sua entrada enable é proveniente de um **divisor de frequências**, o qual intercala esse valor entre 0 e 1 em intervalos de tempos iguais e determinados pela magnitude do valor que o clock é dividido.

```
if(enable)
	hex <= valorHex;
else
  hex <= 4'he;
```

### Verifica Posição Escolhida pelo Usuário (VerificaPosicao)

### Verifica Jogada Feita pelo Usuário (VerificaJogada)

### Reseta Entradas do Usuário (ResetaEntrada)

<p align="center">
  <img src="./readmeFiles/resetaEntrada.png" alt="Reseta entradas do usuário">
</p>

Circuito responsável por resetar as entradas selecionadas pelo usuário ao receber o acionamento da **resetKey**.

Produz uma saída que é conectada nas entradas reset da máquina de estado e dos registradores, que, quando em nível baixo, limpa todas as entradas do usuário selecionadas até então e retorna para a etapa de seleção de linha.

Para isso, o circuito faz uma porta **AND** com o valor da entrada **keyReset** e da saída do **comparador de magnitude** (garante que o estado atual ainda seja de escolha de uma das entradas: linha, coluna ou valor). Essa saída possui seu valor negado, visto que a entrada reset é ativa em nível baixo.

```
saidaResetEntrada <= !(keyReset && (estadoJogo <= recebeValor));
```

### Fim de Jogo (FimJogo)

<p align="center">
  <img src="./readmeFiles/fimJogo.png" alt="Circuito de Fim de Jogo">
</p>

### Renderiza Saída no Monitor (Tabuleiro)

<p align="center">
  <img src="./readmeFiles/tabuleiro.png" alt="Renderiza Tabuleiro">
</p>

Circuito responsável por definir se derminado pixel recebido como entrada pertence à renderização do tabuleiro no monitor ou não.

Para isso, ele armazena quais coordenadas de linha e coluna compõe o tabuleiro. Para reduzir o gasto desnecessário de memória, foram utilizados diversos artíficios visando salvar o mínimo de informações referentes ao desenho do tabuleiro.

  * A primeira delas, foi interpretar o sudoku como um tabuleiro composto por subblocos idênticos que se repetem. Além disso, como se tratam de quadrados, pode-se garantir que as coordenadas verticais e horizontais são sempre as mesmas, devido a sua simetria.

  * Além disso, foi criada uma lógica de proporção, que permite representar cada quatro pixels na tela como apenas um único pixel. Dessa forma, internamente o tabuleiro é desenhado em uma proporção dezesseis vezes menor (redução da área é impactada duas vezes, uma para cada dimensão).

Para fazer a renderização dos números presentes no tabuleiro, foi instanciado um circuito chamado **DesenhaNumeros** que realiza a verificação se determinado pixel pertence ou não ao desenho do tabuleiro.

```
always@* begin

  if(~video_on) {r, g, b} = 12'h000;

  else if(tab_on) {r, g, b} = tab_rgb;

  else {r, g, b} = BACKGROUND_COLOR;

end
```

### Renderiza Saída no Monitor (DesenhaNumeros)

<p align="center">
  <img src="./readmeFiles/desenhaNum.png" alt="Renderiza Tabuleiro">
</p>

Circuito interno ao **Tabuleiro** responsável por definir se derminado pixel recebido como entrada pertence ao bitmap do número presente naquela posição ou não.

Para isso, ele armazena o bitmap de todos os algarismos que podem aparecer no tabuleiro do sudoku. Dessa forma, ele recebe como entrada o numero que pertence àquela posição e as coordenadas x e y relativas de tal posição (coordenadas internas de uma posição específica do tabuleiro). Assim, basta consultar se tal pixel possui valor 0 ou 1 no bitmap do número especificado.

```
if(3 <= posX && posX <= 10 && 3 <= posY && posY <= 10)
  num_on <= numeroAtual[(posX - 3) + ( (posY - 3) * 8)];

else
  num_on <= 0;
```

### Modo Fornece Dicas (ModoDica)

