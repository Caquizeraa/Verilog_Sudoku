module VerificaJogada(
	input wire clk, enable,
	input wire [3:0] regLinha, regColuna, regValor, regPosValida, regVerificaJogo,
	input wire [0:323] sudokuJogador, sudokuCompleto,
	output reg [0:323] novoSudoku,
	output reg enableRegSudoku,
	output reg [2:0] saidaValor,
	output reg rstnRegistradores // reseta tudo se jogo continuar (or com reset verifica pos)
);

	integer indexSudoku;
	
	reg [0:323] sudokuBuffer;
	reg computouJogada = 1'b0, jogadaValida = 1'b1, verificouJogada = 1'b0;
	
	always @ (posedge clk) begin
			
		if(enable) begin
		
			indexSudoku = (regLinha  - 1) * 36 + (regColuna  - 1) * 4; 
			
			if(!computouJogada) begin
			
				if(!indexSudoku)
					sudokuBuffer <= {regValor, sudokuJogador[4:323]};
				else if(indexSudoku == 320)
					sudokuBuffer <= {sudokuJogador[0:319], regValor};
				else begin
				
						sudokuBuffer <= sudokuJogador;
					
						sudokuBuffer[indexSudoku] <= regValor[3];
						sudokuBuffer[indexSudoku + 1] <= regValor[2];
						sudokuBuffer[indexSudoku + 2] <= regValor[1];
						sudokuBuffer[indexSudoku + 3] <= regValor[0];
					
				end
				
				computouJogada <= 1'b1;
				enableRegSudoku <= 1'b0;
				verificouJogada <= 1'b0;
				jogadaValida <= 1'b0;
				saidaValor <= 3'b000;
				rstnRegistradores <= 1'b1;
			
			end // end jogada nao computada
						
			else begin
				
				novoSudoku <= sudokuBuffer;
				enableRegSudoku <= 1'b1;
				
				if(!verificouJogada) begin
					jogadaValida <= (sudokuCompleto[indexSudoku+:4] == sudokuBuffer[indexSudoku+:4]);
					verificouJogada <= 1'b1;
					computouJogada <= 1'b1;
					saidaValor <= 3'b000;
					rstnRegistradores <= 1'b1;
				end
					
				else begin
				
					//			ja verificou jogada (
					//				I: acertou e nn acabou -> 00
					//				II: acertou e acabou -> 01
					//				III: errou -> 10
					//			)
								
					//
					
					verificouJogada <= 1'b1;
					computouJogada <= 1'b1;
					
					if(jogadaValida) begin //acertou
						if (sudokuBuffer == sudokuCompleto) begin //completo
							saidaValor <= 3'b101;
							rstnRegistradores <= 1'b1;
						end
						
						else begin //incompleto
						
							// garantir que os reg serao resetados antes de trocar estado
						
							if(!regLinha && !regColuna && !regValor && !regPosValida && !regVerificaJogo) begin
								saidaValor <= 3'b100;
								rstnRegistradores <= 1'b1; // nao reseta e vai para estado de fim de jogo
							end
							
							else begin
								saidaValor <= 3'b000;
								rstnRegistradores <= 1'b0; // reseta e vai para estado de receber linha
							end
							
						end
						
					end // end jogada valida
					
					else begin //errou (jogada invalida)
					
						saidaValor <= 3'b110;
						rstnRegistradores <= 1'b1; // nao reseta e vai para estado de fim de jogo
						
					end // end jogada invalida
				end
				
						
			end // end jogada ja computada
		end // end enable
		
		else begin // else enable
			saidaValor <= 3'b000;
			rstnRegistradores <= 1'b1;
			novoSudoku <= sudokuJogador;
			jogadaValida <= 1'b1;
			computouJogada = 1'b0;
			enableRegSudoku <= 1'b0;
			verificouJogada <= 1'b0;
		end
	end
endmodule