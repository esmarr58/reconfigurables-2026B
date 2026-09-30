module decBCDa7SegmentosRevB(Sel, Salida);
	input wire [3:0] Sel;
	output reg [6:0] Salida;

	localparam [6:0] cero   = 7'b0000001;
	localparam [6:0] uno    = 7'b1001111;
	localparam [6:0] dos    = 7'b0010010;
	localparam [6:0] tres   = 7'b0000110;
	localparam [6:0] cuatro = 7'b1001100;
	localparam [6:0] cinco  = 7'b0100100;
	localparam [6:0] seis   = 7'b0100000;
	localparam [6:0] siete  = 7'b0001111;
	localparam [6:0] ocho   = 7'b0000000;
	localparam [6:0] nueve  = 7'b0001100;
	
	always @(*)
		begin
			if(Sel == 0) 			Salida = cero;
			else if( Sel == 1) 	Salida = uno;
			else if( Sel == 2)	Salida = dos;
			else if( Sel == 3)	Salida = tres;
			else if( Sel == 4)	Salida = cuatro;
			else if( Sel == 5) 	Salida = cinco;
			else if( Sel == 6)   Salida = seis;
			else if( Sel == 7)   Salida = siete;
			else if( Sel == 8)   Salida = ocho;
			else if( Sel == 9)   Salida = nueve;
			else	Salida = 7'b1111110;
		end
	
endmodule