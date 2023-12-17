module MostraEntradas(
	input wire clk,
	input wire [8:0] switch,
	input wire [3:0] regLinha, regColuna, regValor,
	input wire [2:0] estadoJogo,
	output [7:0] h5, h4, h3, h2, h1, h0
);

	wire [3:0] saidaHexLinha, saidaHexColuna, saidaHexValor, switchCod;
	
	CodificadorSwitch(
		.clk(clk),
		.switch(switch),
		.switchCod(switchCod)
	);

	SEG7_LUT v5(.iDIG(4'ha), .oSEG(h5));
	SEG7_LUT v3(.iDIG(4'hb), .oSEG(h3));
	SEG7_LUT v1(.iDIG(4'hc), .oSEG(h1));
	
	
	ControlaHex #(.meuEstado(3'b000)) hexLinha(
		.clk(clk),
		.estadoJogo(estadoJogo), 
		.switchCod(switchCod),
		.registrador(regLinha),
		.hex(saidaHexLinha)
	);
	
	ControlaHex #(.meuEstado(3'b001)) hexColuna(
		.clk(clk),
		.estadoJogo(estadoJogo), 
		.switchCod(switchCod),
		.registrador(regColuna),
		.hex(saidaHexColuna)
	);
	
	ControlaHex #(.meuEstado(3'b011)) hexValor(
		.clk(clk),
		.estadoJogo(estadoJogo), 
		.switchCod(switchCod),
		.registrador(regValor),
		.hex(saidaHexValor)
	);
	
	
	SEG7_LUT v4(.iDIG(saidaHexLinha), .oSEG(h4));
	SEG7_LUT v2(.iDIG(saidaHexColuna), .oSEG(h2));
	SEG7_LUT v0(.iDIG(saidaHexValor), .oSEG(h0));
endmodule