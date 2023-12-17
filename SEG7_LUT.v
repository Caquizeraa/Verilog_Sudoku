module SEG7_LUT	(
	input wire [3:0] iDIG,
	output reg [7:0] oSEG
);

	always @(iDIG)
	begin
		case(iDIG)
			4'h0: oSEG = 8'b11000000;
			4'h1: oSEG = 8'b11111001;	// ---a----
			4'h2: oSEG = 8'b10100100; 	// |	  |
			4'h3: oSEG = 8'b10110000; 	// f	  b
			4'h4: oSEG = 8'b10011001; 	// |	  |
			4'h5: oSEG = 8'b10010010; 	// ---g----
			4'h6: oSEG = 8'b10000010; 	// |	  |
			4'h7: oSEG = 8'b11111000; 	// e	  c
			4'h8: oSEG = 8'b10000000; 	// |	  |
			4'h9: oSEG = 8'b10011000; 	// ---d----
			4'ha: oSEG = 8'b11000111;
			4'hb: oSEG = 8'b11000110;
			4'hc: oSEG = 8'b10110110;
			default: oSEG = 8'b11111111;
		endcase
	end

endmodule
