module CodificadorSwitch(
	input wire clk,
	input wire [8:0] switch,
	output reg [3:0] switchCod
);

	always @ (posedge clk) begin
		// codificador switchs (com ordem de prioridade)
		casex (switch)
			9'b1xxxxxxxx: switchCod = 4'd9;
			9'b01xxxxxxx: switchCod = 4'd8;
			9'b001xxxxxx: switchCod = 4'd7;
			9'b0001xxxxx: switchCod = 4'd6;
			9'b00001xxxx: switchCod = 4'd5;
			9'b000001xxx: switchCod = 4'd4;
			9'b0000001xx: switchCod = 4'd3;
			9'b00000001x: switchCod = 4'd2;
			9'b000000001: switchCod = 4'd1;
			default: switchCod = 4'd0;
		endcase
	end

endmodule