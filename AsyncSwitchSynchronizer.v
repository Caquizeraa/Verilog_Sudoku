module AsyncSwitchSynchronizer (
	input wire clk, // system clock
	input wire [9:0] asyncn, // Asynchronous input (reset or preset)
	output wire [9:0] syncn // Synchronous reset or preset output
);

	AsyncInputSynchronizer s9(
		.clk(clk),
		.asyncn(asyncn[9]),
		.syncn(syncn[9])
	);

	AsyncInputSynchronizer s8(
		.clk(clk),
		.asyncn(asyncn[8]),
		.syncn(syncn[8])
	);
	
	AsyncInputSynchronizer s7(
		.clk(clk),
		.asyncn(asyncn[7]),
		.syncn(syncn[7])
	);
	
	AsyncInputSynchronizer s6(
		.clk(clk),
		.asyncn(asyncn[6]),
		.syncn(syncn[6])
	);
	
	AsyncInputSynchronizer s5(
		.clk(clk),
		.asyncn(asyncn[5]),
		.syncn(syncn[5])
	);
	
	AsyncInputSynchronizer s4(
		.clk(clk),
		.asyncn(asyncn[4]),
		.syncn(syncn[4])
	);
	
	AsyncInputSynchronizer s3(
		.clk(clk),
		.asyncn(asyncn[3]),
		.syncn(syncn[3])
	);
	
	AsyncInputSynchronizer s2(
		.clk(clk),
		.asyncn(asyncn[2]),
		.syncn(syncn[2])
	);
	
	AsyncInputSynchronizer s1(
		.clk(clk),
		.asyncn(asyncn[1]),
		.syncn(syncn[1])
	);
	
	AsyncInputSynchronizer s0(
		.clk(clk),
		.asyncn(asyncn[0]),
		.syncn(syncn[0])
	);
	

endmodule 