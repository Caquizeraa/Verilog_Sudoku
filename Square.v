module Square (
	input wire clk, rstn, 
	input wire refr_tick,
	input wire turn_r, turn_l,
	input wire [9:0] x, y,
	output wire [11:0] square_rgb,
	output wire square_on
);
	// x, y coordinates (0,0) to (639,479)
	localparam MAX_X = 640;
	localparam MAX_Y = 480;
	
	// square attributes
	localparam SQUARE_SIZE = 8;
	localparam SQUARE_X = 100;
	localparam SQUARE_Y = 150;
	localparam SQUARE_COLOR = 12'h5AF;
	localparam SQUARE_STEP = 1;
	
	integer x_count;
	integer y_count;
	
	wire x_updown, x_en, y_updown, y_en;
	
	assign square_rgb = SQUARE_COLOR;
	//assign square_on = (x_count < x) && (x < x_count + SQUARE_SIZE) && (y_count < y) && (y < y_count + SQUARE_SIZE);
	
	
	wire [2:0] rom_addr, rom_col;
	reg [7:0] rom_data;
	wire rom_bit, sq_ball_on;
	// round ball image ROM
	always@*
	case (rom_addr)
	3'h0: rom_data = 8'b00111100; // ****
	3'h1: rom_data = 8'b01111110; // ******
	3'h2: rom_data = 8'b11111111; // ********
	3'h3: rom_data = 8'b11111111; // ********
	3'h4: rom_data = 8'b11111111; // ********
	3'h5: rom_data = 8'b11111111; // ********
	3'h6: rom_data = 8'b01111110; // ******
	3'h7: rom_data = 8'b00111100; // ****
	endcase
	// pixel within ball
	assign sq_ball_on = (x_count <= x) && (x < x_count + SQUARE_SIZE) &&
	 (y_count <= y) && (y < y_count + SQUARE_SIZE);
	// map current pixel location to ROM addr/col
	assign rom_addr = y[2:0] - y_count[2:0];
	assign rom_col = x[2:0] - x_count[2:0];
	assign rom_bit = rom_data[rom_col];
	// pixel within ball
	assign square_on = sq_ball_on & rom_bit;
	
	// Control for x counter
	always @(posedge clk, negedge rstn)
	begin
		if(rstn == 0)
			x_count <= SQUARE_X;
		else if(x_en == 1 && refr_tick == 1'b1)
			if(x_updown == 1)
				x_count <= (x_count < MAX_X - 1 - SQUARE_STEP) ? x_count + SQUARE_STEP : 0;
			else if(x_updown == 0)
				x_count <= (x_count > SQUARE_STEP) ? x_count - SQUARE_STEP : MAX_X - 1;

	end
	
	// Control for y counter
	always @(posedge clk, negedge rstn)
	begin
		if(rstn == 0)
			y_count <= SQUARE_Y;
		else if(y_en == 1 && refr_tick == 1'b1)
			if(y_updown == 1)
				y_count <= (y_count < MAX_Y - 1 - SQUARE_STEP) ? y_count + SQUARE_STEP : 0;
			else if(y_updown == 0)
				y_count <= (y_count > SQUARE_STEP)? y_count - SQUARE_STEP : MAX_Y - 1;
				
	end
	
	// state machine to control the direction of motion
	DirectionController (.clk(clk), 
	                     .rstn(rstn), 
	                     .turn_right(turn_r), 
							   .turn_left(turn_l), 
							   .data_out({y_updown,y_en,x_updown,x_en}));
							 	
endmodule 