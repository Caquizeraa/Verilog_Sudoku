module Registrador
	#(
		parameter N = 4, valorInicial = {N{1'b0}}
	)
	(
		input wire clk, rstn, enable,
		input [N-1:0] dadoEntrada,
		output reg [N-1:0] dadoSaida 
	);

	reg [N-1:0] valorSalvo = valorInicial;
	
	
	always@(posedge clk, negedge rstn) begin
		if(!rstn)
			valorSalvo <= valorInicial;
		else begin
			if(enable)
				valorSalvo <= dadoEntrada;
			else
				valorSalvo <= valorSalvo;
		end
		dadoSaida <= valorSalvo;
	end

endmodule