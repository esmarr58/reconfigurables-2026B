// =====================================================================
//  dec7seg.v  --  Decodificador BCD -> 7 segmentos (DE10-Lite)
//  Sistemas Reconfigurables (V3737) - 2026B - TC06 y Practica 2
//
//  Los 6 displays de la DE10-Lite (HEX0..HEX5) son de ANODO COMUN:
//  un segmento ENCIENDE con 0 (activo en bajo).
//  Orden de bits (igual que la Practica 1 y el manual de Terasic):
//      seg[0]=a  seg[1]=b  seg[2]=c  seg[3]=d  seg[4]=e  seg[5]=f  seg[6]=g
//  El punto decimal (DP) es HEX?[7] y se maneja aparte en el top.
//           a
//         f   b
//           g
//         e   c
//           d
//  Valores 10..15 no son BCD validos: se muestra un guion (solo g).
// =====================================================================
`timescale 1ns/1ps
module dec7seg (
    input  wire [3:0] bcd,            // digito 0..9
    output reg  [6:0] seg             // {g,f,e,d,c,b,a}, ACTIVO EN BAJO
);
    always @(*) begin
        case (bcd)                    //   gfedcba   (0 = encendido)
            4'd0:    seg = 7'b1000000;
            4'd1:    seg = 7'b1111001;
            4'd2:    seg = 7'b0100100;
            4'd3:    seg = 7'b0110000;
            4'd4:    seg = 7'b0011001;
            4'd5:    seg = 7'b0010010;
            4'd6:    seg = 7'b0000010;
            4'd7:    seg = 7'b1111000;
            4'd8:    seg = 7'b0000000;
            4'd9:    seg = 7'b0010000;
            default: seg = 7'b0111111;  // guion: no es BCD valido
        endcase
    end
endmodule
