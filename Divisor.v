module Divisor
#(
	parameter NUM_BITS = 26,
	parameter MOD = 50_000_000
)
(
	input wire clock_in, reset_n, enable,
	output reg clock_out
);
	reg [NUM_BITS - 1:0] count;
	
	always@(posedge clock_in, negedge reset_n) begin
		
		if(reset_n == 0) begin
			count <= {NUM_BITS{1'b0}};
			clock_out <= 1'b0;
		end
		
		else if(enable == 1) begin
			count <= (count < (MOD) - 1) ? count + 1'b1 : {NUM_BITS{1'b0}};
			clock_out <= (count < MOD/2) ? 1'b1 : 1'b0;
		end
		
	end
endmodule