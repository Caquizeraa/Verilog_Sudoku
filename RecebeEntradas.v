module RecebeEntradas(
	input wire clk, enable, keyEnter,
	input wire [8:0] switch, 
	input wire [2:0] estadoJogo,
	output wire [3:0] saidaEntrada,
	output reg enableLinha, enableColuna, enableValor
);
	 
	CodificadorSwitch(
		.clk(clk),
		.switch(switch),
		.switchCod(saidaEntrada)
	);
	
	always @ (posedge clk) begin
		if(enable) begin	
			
			if(keyEnter) begin
				// demux  registradores
						
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
			else begin
				enableLinha = 0;
				enableColuna = 0;
				enableValor = 0;
			end
			
		end
	end
endmodule