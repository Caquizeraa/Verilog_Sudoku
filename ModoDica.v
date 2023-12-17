module ModoDica(
	input wire clk, enable,	
	input wire [2:0] estadoJogo,
	input wire [3:0] regLinha, regColuna,
	input wire [0:323] sudokuJogador,
	output reg [0:9] saidaLeds
);

	localparam [2:0] recebeLinha = 3'b000, 
	                 recebeColuna = 3'b001, 
						  recebeValor = 3'b011, 
						  fimJogo = 3'b101;
						  
	reg [0:8] leds;
	reg verificouLinha, verificouColuna, verificouBloco;
	integer i, j, k, indexSudoku, linhaIniciaBloco, colunaIniciaBloco, linhaAtualBloco, colunaAtualBloco, indexBloco;
	reg jogadaValida;

	always@ (posedge clk) begin
		
		if(enable) begin
			
			case (estadoJogo)
			
				recebeLinha: begin
					for(i = 0; i < 9; i = i + 1) begin
						leds[i] <= 1'b0;
						for(j = 0; j < 9; j = j+1) begin
						
							indexSudoku = i * 36 + j * 4;
							if(!sudokuJogador[indexSudoku +: 4]) begin
								leds[i] <= 1'b1;
							end
		
						end
					end
				end // end recebeLinha case
				
				recebeColuna: begin
					j = 0;
					while(j < 9) begin
					
						indexSudoku = (regLinha - 1) * 36 + j * 4;
						
						if(!sudokuJogador[indexSudoku +: 4])
							leds[j] <= 1'b1;
						else 
							leds[j] <= 1'b0;
						
						j = j + 1;			
		
					end
				end // recebeColuna case
				
				recebeValor: begin
					leds <= {9{1'b1}};
					
					for(k = 0; k<9; k = k + 1) begin
						jogadaValida <= 1'b1;
						
						// *************************************************
						
						i = 0;
						while(i < 9 && jogadaValida) begin 
						
							if(i != (regColuna - 1)) begin // desconsiderar pos novo valor
								
								indexSudoku = (regLinha  - 1) * 36 + i * 4; // index temporario (busca na linha)
								
								if( (k + 1) == sudokuJogador[indexSudoku +: 4]) begin
									// encontrou valor repetido na linha
									leds[k] <= 1'b0;
									jogadaValida <= 1'b0;	
								end
								else begin
									jogadaValida <= 1'b1;
								end
								
							end
							i = i + 1;
						end // end while (verifica linha)
						
						// *************************************************
						
						i = 0;
						while(i < 9 && jogadaValida) begin 
							
							if(i != (regLinha - 1)) begin // desconsiderar pos novo valor
								
								indexSudoku = i * 36 + (regColuna - 1) * 4; // index temporario (busca na coluna)
								
								if((k + 1) == sudokuJogador[indexSudoku +: 4]) begin
									// encontrou valor repetido na coluna
									leds[k] <= 1'b0;
									jogadaValida <= 1'b0;	
								end
								else begin
									jogadaValida <= 1'b1;
								end
								
							end
							i = i + 1;
						end
						
						// *************************************************
						
						linhaIniciaBloco = (regLinha - 1) - ((regLinha - 1) % 3);
						colunaIniciaBloco = (regColuna - 1) - ((regColuna - 1) % 3);
						
						indexSudoku = (regLinha  - 1) * 36 + (regColuna  - 1) * 4; // index fixo (posicao ultimo valor inserido)
						
						i = 0;
						while(i < 9 && jogadaValida) begin
						
							linhaAtualBloco = linhaIniciaBloco + i/3;
							colunaAtualBloco = colunaIniciaBloco + i % 3;
						
							indexBloco = linhaAtualBloco * 36 + colunaAtualBloco * 4; // index temporario (busca no bloco)
							
							if(indexSudoku != indexBloco) begin // desconsiderar pos novo valor
								
								if((k + 1) == sudokuJogador[indexBloco +: 4]) begin
									// encontrou valor repetido na coluna
									leds[k] <= 1'b0;
									jogadaValida <= 1'b0;	
								end
								else begin
									jogadaValida <= 1'b1;
								end
							end
							i = i + 1;
						end
						
					
					end // end for leds (k)

				end // end recebeValor case
				
				default:
					leds <= {10{1'b0}};
				
			endcase
			
			saidaLeds <= {1'b1, leds};
		end
		else
			saidaLeds <= {10{1'b0}};
	
	end

endmodule 