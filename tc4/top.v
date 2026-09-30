module top(Sel, Codigo);
	input wire [3:0] Sel;
	output wire [6:0] Codigo;
	 
	wire [3:0] w1;
	
	enigma inst1(.SelA(Sel),.SalidaA(w1));
	decBCDa7SegmentosRevB inst2(.Sel(w1),.Salida(Codigo));

endmodule
