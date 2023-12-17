module FimJogo(
	input wire clk, enable,
	input wire keyPressed,
	input wire [1:0] registradores, // 01: ganhou, 10: perdeu
	output reg rstnGlobal
);

	always@ (posedge clk) begin
	
		if(enable) begin
		
			if(registradores == 2'b10) 
				rstnGlobal <= 1'b0;
			else if(registradores == 2'b01 && keyPressed)
				rstnGlobal <= 1'b0;
			else
				rstnGlobal <= 1'b1;
			
		end
		else
			rstnGlobal <= 1'b1;
	end

endmodule