module EdgeDetector(
	input wire clk, rstn, trigger,
	output reg pulse
);

	reg [1:0] ffs;
	wire rising_edge;

	// Rising edge detector	
	always@(posedge clk, negedge rstn)
	begin
		if(rstn == 0)
			ffs <= 2'b00;
		else
		begin
			ffs[0] <= trigger;
			ffs[1] <= ffs[0];
		end
	end
	assign rising_edge = ~ffs[1] & ffs[0];
	
	// No glitches at the output pulse using DFF
	always@(posedge clk, negedge rstn)
		pulse <= (rstn == 0) ? 1'b0 : rising_edge;
		
endmodule 