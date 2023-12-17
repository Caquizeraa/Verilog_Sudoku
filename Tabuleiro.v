module Tabuleiro(
	input wire clk, 
	input wire refr_tick,
	input wire [9:0] x, y,
	input wire [0:323] sudoku,
	output wire [11:0] output_rgb,
	output wire tabuleiro_on
);


	localparam x_inicio = 80;
	localparam y_inicio = 0;
	localparam largura_tab = 480;
	localparam altura_tab = 480;
	localparam proporcao = 4;
	localparam cor_tab = 12'h000;
	
	assign output_rgb = cor_tab;
	reg tab_on, enableNum = 0;
	reg [3:0] numMatriz;
	wire num_on;
	
	wire [6:0] linhasSudoku [0:11];
	
	assign linhasSudoku[0] = 7'd0;
	assign linhasSudoku[1] = 7'd13;
	assign linhasSudoku[2] = 7'd26;
	
	assign linhasSudoku[3] = 7'd39;
	
	integer i, larguraBloco = 40;
	integer x_matriz, y_matriz;
	integer x_relativo, y_relativo, blocoX, blocoY;
	integer linhaMatriz, colunaMatriz;
	integer indexSudoku;
	
	reg [3:0] x_quadrado, y_quadrado;
	
	DesenhaNumeros(
		.enable(enableNum),
		.num(numMatriz),
		.posX(x_quadrado), 
		.posY(y_quadrado),
		.num_on(num_on)
	);
	
	always@*
	
		if(x_inicio <= x && x < x_inicio + largura_tab && y_inicio <= y && y < y_inicio + altura_tab) begin
			
			// 120 x 120
			x_matriz = (x - (x % proporcao) - x_inicio)/proporcao;
			y_matriz = (y - (y % proporcao) - y_inicio)/proporcao;
			
			blocoX = x_matriz / larguraBloco; // 0, 1, 2
			x_relativo = x_matriz % larguraBloco; // 0 - 39
			
			blocoY = y_matriz / larguraBloco; // 0, 1 , 2
			y_relativo = y_matriz % larguraBloco; // 0 - 39
			
			tab_on = 0;
			enableNum = 0;
			i = 0;
			
			while(i<4 && !tab_on) begin
			
				if(x_relativo == linhasSudoku[i] || y_relativo == linhasSudoku[i]) begin
					tab_on = 1;
				end
				i = i + 1;
			end
			
			if(!tab_on) begin
			
				linhaMatriz = y_relativo/13 + 3*blocoY; // 0 - 8 (linhas)
				colunaMatriz = x_relativo/13 + 3*blocoX; // 0 - 8 (colunas)
			
				x_quadrado <= (x_relativo % 13); // 1 - 12
				y_quadrado <= (y_relativo % 13); // 1 - 12
				
				indexSudoku = linhaMatriz * 36 + colunaMatriz * 4;
				numMatriz <= sudoku[indexSudoku +: 4];
				enableNum = 1;
				
			end
			else begin
				enableNum = 0;
			end
			
		end
		
		else begin
			tab_on = 0;
			enableNum = 0;
		end	
			
		assign tabuleiro_on = tab_on || num_on;
	
endmodule