module ResetaEntrada(
	input wire clk,
	input wire keyReset, 
	input wire [2:0] estadoJogo,
	output reg saidaResetEntrada
);

	localparam [2:0] recebeLinha = 3'b000, 
	                 recebeColuna = 3'b001, 
						  verificaPos = 3'b010,
						  recebeValor = 3'b011, 
						  verificaJogo = 3'b100,
						  fimJogo = 3'b101;

	always@ (posedge clk) begin
	
		saidaResetEntrada <= !(keyReset && (estadoJogo <= recebeValor));
	
	end
						  
endmodule