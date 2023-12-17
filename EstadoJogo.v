module EstadoJogo(
	input wire clk, rstn,
	input wire [16:0] registradores, // linha (4 bits), coluna (4 bits), valor (4 bits), posicaoValida (2 bits), verificaJogo (3 bits)
	output reg [2:0] outputEstado
);

	// 2 bits para verifica posicao (MSB: 0 - 1 verificou ou nao; LSB: 0 - 1 valido ou nao)
	// 3 bits para verifica jogo (MSB: 0 - 1 verificou ou nao; 00, 01, 10 possiveis estados do jogo)

	localparam [2:0] recebeLinha = 3'b000, 
	                 recebeColuna = 3'b001, 
						  verificaPos = 3'b010,
						  recebeValor = 3'b011, 
						  verificaJogo = 3'b100,
						  fimJogo = 3'b101; // reset maquina estado e limpa os registradores e sudoku usuario (saida conecta rstn da maquina de estado)
												 // key[1] ativa circuito limpa os registradores (saida conecta rstn da maquina de estado) -> se estado next atual condizente
	
	reg [2:0] state_reg = recebeLinha, state_next;
	
						  
	// state register
	always@(posedge clk, negedge rstn)
		if(!rstn)
			state_reg <= recebeLinha;
		else
			state_reg <= state_next;
	
	// Moore Output depends only on the state
	always @ (state_reg) 
	begin
		outputEstado = state_reg;
	end
	
	always @ (registradores)
	begin
		case(state_reg)
			recebeLinha:
				if(registradores[16:13]) state_next = recebeColuna;
				else state_next = recebeLinha;
			recebeColuna:
				if(registradores[12:9]) state_next = verificaPos;
				else state_next = recebeColuna;
			recebeValor:
				if(registradores[8:5]) state_next = verificaJogo;
				else state_next = recebeValor;
			verificaPos:
				if(registradores[4]) begin
					if(registradores[3])
						state_next = recebeValor;
					else
						state_next = recebeLinha;
				end
				else state_next = verificaPos;
			verificaJogo:
				if(registradores[2]) begin
					case (registradores[1:0])
						2'b00:
							state_next = recebeLinha; // jogada valida e jogo em andamento
						2'b01:
							state_next = fimJogo; // jogada valida e jogo completo
						2'b10:
							state_next = fimJogo; // jogada invalida (fim jogo)
						default:
							state_next = verificaJogo;
					endcase
				end
				else state_next = verificaJogo;
			default:
				state_next = fimJogo;
		endcase
	end
endmodule