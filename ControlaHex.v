module ControlaHex 
	#(
		parameter meuEstado = 3'b000
	)
	(	
		input wire clk,
		input wire [2:0] estadoJogo, 
		input wire [3:0] switchCod,
		input wire [3:0] registrador,
		output reg [3:0] hex
	);
	
	reg enable = 1'b0;
	reg [3:0] valorHex = 4'h0;
	wire saidaDivisor;
	
	Divisor #(.NUM_BITS(28), .MOD(50_000_000)) (
		.clock_in (clk),
		.reset_n(1),
		.enable(1),
		.clock_out(saidaDivisor)
	); // divisor (2 Hz)
	
	always @ (posedge clk) begin
	
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
		
		if(enable)
			hex <= valorHex;
		else
			hex <= 4'he;
	end
endmodule