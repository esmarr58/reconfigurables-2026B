module enigma(SelA, SalidaA);
	input wire [3:0] SelA;
	output reg [3:0] SalidaA;
	
	always @(*)
		begin
			if(SelA == 0) 			SalidaA = 3;
			else if(SelA == 1) 	SalidaA = 2;
			else if(SelA == 2)	SalidaA = 5;
			else if(SelA == 3)	SalidaA = 0;
			else if(SelA == 4)	SalidaA = 0;
			else if(SelA == 5)	SalidaA = 1;
			else if(SelA == 6) 	SalidaA = 3;
			else if(SelA == 7)	SalidaA = 9;
			else if(SelA == 8)	SalidaA = 7;
			else 						SalidaA = 15;
		end

endmodule
