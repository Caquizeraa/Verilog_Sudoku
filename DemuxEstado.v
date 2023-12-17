module DemuxEstado(
	input wire clk,
	input wire [2:0] estadoJogo,
	output reg enableRecebeEntrada, enableVerificaPos, enableVerificaJogo, enableFimJogo
);

	localparam [2:0] recebeLinha = 3'b000, 
	                 recebeColuna = 3'b001, 
						  verificaPos = 3'b010,
						  recebeValor = 3'b011, 
						  verificaJogo = 3'b100,
						  fimJogo = 3'b101;

	always @ * begin
						  
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
		
	end
			
endmodule 