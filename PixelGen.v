module PixelGen(
	input wire clk, rstn,
	input wire video_on, p_tick,
	input wire [9:0] pixel_x, pixel_y,
	input wire [9:0] sw,
	input wire keyEnter,
	input wire keyReset,
	output reg [3:0] r, g, b,
	output [7:0] h5, h4, h3, h2, h1, h0,
	output [0:9] leds
);

	localparam BACKGROUND_COLOR = 12'heee;

	reg [3:0] r_reg, g_reg, b_reg;
	wire [11:0] tab_rgb;
	wire tab_on;
	wire refr_tick;
	
	// **********************************
	
	
	wire [2:0] estadoAtual;
	
	wire [9:0] syncSwitch;
	
	// entradas registradores (dados de entrada e enable)
	wire [3:0] saidaRecebeEntrada;
	wire enableRegLinha, enableRegColuna, enableRegValor;

	
	// saidas registradores atualizadas
	wire [3:0] linha, coluna, valor;
	wire [1:0] posicaoValida;
	wire [2:0] verificaJogo;
	
	// saida circuito verificaPos e verificaJogo
	wire [1:0] saidaPosicao;
	wire [2:0] saidaVerificaJogo;
	
	//enable dos circuitos (saida demux de estado)
	wire enableRecebeEntrada, enableVerificaPos, enableVerificaJogo, enableFimJogo;
	
	// *********************************
	wire rstnRegistradoresPos, rstnRegistradoresJogada, resetExterno; 
	reg rstnRegistradores = 1'b1;
	
	// saida dos registradores sudoku
	wire [0:323] sudokuJogadorSaida;
	wire [0:323] sudokuFinalSaida;
	
	// entrada dos registradores sudoku
	wire [0:323] sudokuJogadorEntrada;
	wire [0:323] sudokuFinalEntrada;
	
	// enable dos registradores sudoku
	wire enableRegSudokuJogador;
	
//	**************************************

	

//	**************************************
	
//	Registrador #(
//		.N(324), 
//		.valorInicial(
//			
//			{	
//				4'd0,	4'd0, 4'd2,	4'd4, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0,
//				4'd5, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd7, 4'd0, 4'd0, 
//				4'd0, 4'd6, 4'd0, 4'd0, 4'd8, 4'd3, 4'd0, 4'd0, 4'd0, 
//				4'd9, 4'd0, 4'd0, 4'd0, 4'd0, 4'd8, 4'd0, 4'd4, 4'd2,
//				4'd0, 4'd0, 4'd7, 4'd0, 4'd0, 4'd0, 4'd5, 4'd0, 4'd8,
//				4'd6, 4'd0, 4'd3, 4'd2, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0,
//				4'd0, 4'd4, 4'd9, 4'd7, 4'd0, 4'd2, 4'd0, 4'd5, 4'd0,
//				4'd8, 4'd0, 4'd0, 4'd0, 4'd5, 4'd0, 4'd9, 4'd0, 4'd6,
//				4'd0, 4'd0, 4'd0, 4'd8, 4'd0, 4'd0, 4'd0, 4'd7, 4'd3
//			}
//		
//		)
//	) sudokuJogadorReg(
//		
//		.clk(clk),
//		.rstn(rstnGlobal),
//		.enable(enableRegSudokuJogador),
//		.dadoEntrada(sudokuJogadorEntrada),
//		.dadoSaida(sudokuJogadorSaida)
//	
//	);

	Registrador #(
		.N(324), 
		.valorInicial(
			
			{	
				4'd1,	4'd3, 4'd2,	4'd0, 4'd9, 4'd7, 4'd6, 4'd8, 4'd5,
				4'd5, 4'd9, 4'd8, 4'd1, 4'd2, 4'd6, 4'd7, 4'd0, 4'd4, 
				4'd7, 4'd6, 4'd4, 4'd5, 4'd8, 4'd3, 4'd2, 4'd1, 4'd9, 
				4'd9, 4'd1, 4'd5, 4'd6, 4'd7, 4'd8, 4'd3, 4'd4, 4'd2,
				4'd4, 4'd0, 4'd7, 4'd9, 4'd3, 4'd1, 4'd5, 4'd0, 4'd8,
				4'd6, 4'd8, 4'd3, 4'd2, 4'd4, 4'd5, 4'd1, 4'd9, 4'd7,
				4'd3, 4'd4, 4'd9, 4'd7, 4'd6, 4'd2, 4'd8, 4'd5, 4'd1,
				4'd8, 4'd7, 4'd0, 4'd3, 4'd5, 4'd0, 4'd9, 4'd0, 4'd6,
				4'd2, 4'd5, 4'd6, 4'd8, 4'd0, 4'd9, 4'd4, 4'd7, 4'd3
			}
		
		)
	) sudokuJogadorReg(
		
		.clk(clk),
		.rstn(rstnGlobal),
		.enable(enableRegSudokuJogador),
		.dadoEntrada(sudokuJogadorEntrada),
		.dadoSaida(sudokuJogadorSaida)
	
	);

	Registrador #(
		.N(324), 
		.valorInicial(
			
			{	
				4'd1,	4'd3, 4'd2,	4'd4, 4'd9, 4'd7, 4'd6, 4'd8, 4'd5,
				4'd5, 4'd9, 4'd8, 4'd1, 4'd2, 4'd6, 4'd7, 4'd3, 4'd4, 
				4'd7, 4'd6, 4'd4, 4'd5, 4'd8, 4'd3, 4'd2, 4'd1, 4'd9, 
				4'd9, 4'd1, 4'd5, 4'd6, 4'd7, 4'd8, 4'd3, 4'd4, 4'd2,
				4'd4, 4'd2, 4'd7, 4'd9, 4'd3, 4'd1, 4'd5, 4'd6, 4'd8,
				4'd6, 4'd8, 4'd3, 4'd2, 4'd4, 4'd5, 4'd1, 4'd9, 4'd7,
				4'd3, 4'd4, 4'd9, 4'd7, 4'd6, 4'd2, 4'd8, 4'd5, 4'd1,
				4'd8, 4'd7, 4'd1, 4'd3, 4'd5, 4'd4, 4'd9, 4'd2, 4'd6,
				4'd2, 4'd5, 4'd6, 4'd8, 4'd1, 4'd9, 4'd4, 4'd7, 4'd3
			}
		
		)
	) sudokuFinalReg(
		
		.clk(clk),
		.rstn(1),
		.enable(0),
		.dadoEntrada({324{1'b0}}),
		.dadoSaida(sudokuFinalSaida)
	
	); 
	
   
	// refr_tick: 1-clock tick asserted at start of v-sync
	//            i.e., when the screen is refreshed (60 Hz)
	assign refr_tick = (pixel_y == 481) && (pixel_x == 0);
	

	EstadoJogo estadoJogo(
		.clk(clk),
		.rstn(resetExterno && rstnGlobal), // saida fim jogo (contador com reset)
		.registradores({linha, coluna, valor, posicaoValida, verificaJogo}),
		.outputEstado(estadoAtual)
	);
	
	AsyncSwitchSynchronizer(
		.clk(clk),
		.asyncn(sw),
		.syncn(syncSwitch)
	);
	
	Registrador regLinha(
		.clk(clk),
		.rstn(rstnRegistradores),
		.enable(enableRegLinha),
		.dadoEntrada(saidaRecebeEntrada),
		.dadoSaida(linha)
	);
	
	Registrador regColuna(
		.clk(clk),
		.rstn(rstnRegistradores),
		.enable(enableRegColuna),
		.dadoEntrada(saidaRecebeEntrada),
		.dadoSaida (coluna)
	);
	
	Registrador regValor(
		.clk(clk),
		.rstn(rstnRegistradores),
		.enable(enableRegValor),
		.dadoEntrada(saidaRecebeEntrada),
		.dadoSaida (valor)
	);
	
	Registrador  #(.N(2)) regPosValida(
		.clk(clk),
		.rstn(rstnRegistradores),
		.enable(enableVerificaPos), // circuito verifica posicao e seta o valor (passa o valor e enable)
		.dadoEntrada(saidaPosicao),
		.dadoSaida (posicaoValida)
	);
	
	Registrador #(.N(3)) regVerificaJogo(
		.clk(clk),
		.rstn(rstnRegistradores),
		.enable(enableVerificaJogo), // circuito verifica jogada e seta o valor (passa o valor e enable)
		.dadoEntrada(saidaVerificaJogo),
		.dadoSaida (verificaJogo)
	);
	
	DemuxEstado(
		.clk(clk),
		.estadoJogo(estadoAtual),
		.enableRecebeEntrada(enableRecebeEntrada), 
		.enableVerificaPos(enableVerificaPos), 
		.enableVerificaJogo(enableVerificaJogo), 
		.enableFimJogo(enableFimJogo)
	);
	
	RecebeEntradas (
	.clk(clk),
	.enable(enableRecebeEntrada), // estado jogo (demux)
	.keyEnter(keyEnter),
	.switch(syncSwitch[9:1]),
	.estadoJogo(estadoAtual),
	.saidaEntrada(saidaRecebeEntrada),
	.enableLinha(enableRegLinha), 
	.enableColuna(enableRegColuna), 
	.enableValor(enableRegValor)
	);
	
	Tabuleiro tab(
		.clk(clk),
		.refr_tick(refr_tick),
		.y(pixel_y), 
		.x(pixel_x),
		.sudoku(sudokuJogadorSaida),
		.output_rgb(tab_rgb),
		.tabuleiro_on(tab_on)
	);
	
	MostraEntradas(
		.clk(clk),
		.estadoJogo(estadoAtual),
		.switch(syncSwitch[9:1]),
		.regLinha(linha),
		.regColuna(coluna),
		.regValor(valor),
		.h5(h5),
		.h4(h4),
		.h3(h3),
		.h2(h2),
		.h1(h1),
		.h0(h0)
	);
//	
	VerificaPosicao(
		.clk(clk),
		.enable(enableVerificaPos),
		.regLinha(linha),
		.regColuna(coluna),
		.saidaPosicao(saidaPosicao), // wire de entrada regPosValida (2 bits)
		.sudokuJogador(sudokuJogadorSaida),
		.rstnRegistradores(rstnRegistradoresPos)
	);
	
	VerificaJogada(
		.clk(clk),
		.enable(enableVerificaJogo),
		.regLinha(linha),
		.regColuna(coluna),
		.regValor(valor),
		.regPosValida(posicaoValida),
		.regVerificaJogo(verificaJogo), 
		.saidaValor(saidaVerificaJogo),
		.rstnRegistradores(rstnRegistradoresJogada),
		.sudokuJogador(sudokuJogadorSaida),
		.sudokuCompleto(sudokuFinalSaida),
		.novoSudoku(sudokuJogadorEntrada),
		.enableRegSudoku(enableRegSudokuJogador)
	);
	
	ResetaEntrada(
		.clk(clk),
		.keyReset(keyReset), 
		.estadoJogo(estadoAtual),
		.saidaResetEntrada(resetExterno)
		);
	
	FimJogo(
		.clk(clk),
		.enable(enableFimJogo),
		.keyPressed(keyReset || keyEnter),
		.registradores(verificaJogo[1:0]), // 01: ganhou, 10: perdeu
		.rstnGlobal(rstnGlobal)
	);
	
	ModoDica(
		.clk(clk),
		.enable(syncSwitch[0]),	
		.estadoJogo(estadoAtual),
		.regLinha(linha),
		.regColuna(coluna),
		.sudokuJogador(sudokuJogadorSaida),
		.saidaLeds(leds)
	);
	
	// output
	
	always@ (posedge clk) begin
		rstnRegistradores <= rstnRegistradoresJogada && rstnRegistradoresPos && resetExterno && rstnGlobal;
	end
	
	always@* begin
		if(~video_on)
			{r, g, b} = 12'h000;
		else if(tab_on)
			{r, g, b} = tab_rgb;
		else
			{r, g, b} = BACKGROUND_COLOR;
	end
		
	// 2 resets (
//		externo: reinicia jogada -> reset chega no recebeEntrada e limpa registradores e maquina de estados (estadoJogo)
//		interno: reinicia jogo
//		)

endmodule