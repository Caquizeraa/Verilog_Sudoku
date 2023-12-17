module VerificaPosicao(
	input wire clk, enable,
	input wire [3:0] regLinha, regColuna,
	input wire [0:323] sudokuJogador,
	output reg [1:0] saidaPosicao,
	output reg rstnRegistradores // reset posicao (linha e coluna)
);
	
	integer indexSudoku;
	reg jaVerificou = 1'b0, ehValida = 1'b0;


	always @ (posedge clk) begin // clock?
		if(enable) begin
			// verificar posicao
			if(!jaVerificou) begin
				
				// ainda nao verificou
				indexSudoku = (regLinha  - 1) * 36 + (regColuna  - 1) * 4;
				
				if(!sudokuJogador[indexSudoku +:4]) begin
					// pos valida
					rstnRegistradores <= 1'b1; // nao limpará registradores
					saidaPosicao <= 2'b11; // troca de estado no proximo clock
					ehValida <= 1'b1;
					jaVerificou <= 1'b1;
				end
				else begin
					saidaPosicao <= 2'b00; // limpa reg e aguarda para mudar de estado
					rstnRegistradores <= 1'b1;
					ehValida <= 1'b0;
					jaVerificou <= 1'b1;
				end
				
			end
			else begin
				 // garantir que os reg serao resetados antes de trocar estado
				 
				if(ehValida) begin
					rstnRegistradores <= 1'b1;
					saidaPosicao <= 2'b11;
					jaVerificou <= 1'b1;
					ehValida <= 1'b1;
				end
				else begin
				
					if(!regLinha && !regColuna) begin
						saidaPosicao <= 2'b10; // // troca de estado no proximo clock
						rstnRegistradores <= 1'b1;
						jaVerificou <= 1'b1;
						ehValida <= 1'b0;
					end
					
					else begin
						saidaPosicao <= 2'b00;
						rstnRegistradores <= 1'b0; // resetar registradores
						jaVerificou <= 1'b1;
						ehValida <= 1'b0;
					end	
				
				end				
			end
			
		end
		else begin
			rstnRegistradores <= 1'b1;
			saidaPosicao <= 2'b00; // nao impacta reg (depende do mesmo enable)
			jaVerificou <= 1'b0;
			ehValida <= 1'b0;
		end
	end

endmodule