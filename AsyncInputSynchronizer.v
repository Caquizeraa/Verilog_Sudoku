module AsyncInputSynchronizer (
	input wire clk, // system clock
	input wire asyncn, // Asynchronous input (reset or preset)
	output wire syncn // Synchronous reset or preset output
);

	reg first_ff, second_ff; 

	always@(posedge clk, negedge asyncn) 
	begin
		if(asyncn == 0)
		begin
			first_ff <= 0;
			second_ff <= 0;
		end
		else
		begin
			first_ff <= 1;
			second_ff <= first_ff;
		end	
	end
	
	assign syncn = second_ff;

endmodule 