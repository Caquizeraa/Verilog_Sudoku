module DesenhaNumeros(
	input wire enable,
	input wire [3:0] num,
	input wire [3:0] posX, posY,
	output reg num_on
);
	wire [0:63] numUm = 64'b0001100000101000010010000000100000001000000010000000100011111111;
	wire [0:63] numDois = 64'b0111111010000001000000010000011000011000001000000100000011111111;
	wire [0:63] numTres = 64'b0111111010000001000000010000000100011110000000011000000101111110;
	wire [0:63] numQuatro = 64'b0000110000010100001001000100010010000100111111110000010000000100;
	wire [0:63] numCinco = 64'b1111111110000000100000001111111000000001000000011000000101111110;
	wire [0:63] numSeis = 64'b0111111010000001100000001111111010000001100000011000000101111110;
	wire [0:63] numSete = 64'b1111111110000001000000110000010000001000000010000000100000001000;
	wire [0:63] numOito = 64'b0111111010000001100000010111111010000001100000011000000101111110;
	wire [0:63] numNove = 64'b0111111010000001100000011000000101111111000000011000000101111110;
	
	reg [0:63] numeroAtual;
	reg [3:0] margemQuadrado = 4'd2;
	
	always@* begin
	
		if(enable) begin
			
			case (num)
				4'd1:
					numeroAtual <= numUm;
				4'd2:
					numeroAtual <= numDois;
				4'd3:
					numeroAtual <= numTres;
				4'd4:
					numeroAtual <= numQuatro;
				4'd5:
					numeroAtual <= numCinco;
				4'd6:
					numeroAtual <= numSeis;
				4'd7:
					numeroAtual <= numSete;
				4'd8:
					numeroAtual <= numOito;
				4'd9:
					numeroAtual <= numNove;	
				default: begin
					numeroAtual <= {64{1'b0}};
				end
				
			endcase
			
			if(3 <= posX && posX <= 10 && 3 <= posY && posY <= 10) begin
				num_on <= numeroAtual[(posX - 3) + ( (posY - 3) * 8)];
			end
			else
				num_on <= 0;
		
		end
		else
			num_on <= 0;
	
	end
		
	
endmodule