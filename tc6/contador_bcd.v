// =====================================================================
//  contador_bcd.v  --  Un digito BCD (0..9) con habilitacion y acarreo
//  Sistemas Reconfigurables (V3737) - 2026B - TC06
//
//  BCD = Binary-Coded Decimal (decimal codificado en binario): 4 bits
//  que solo toman los valores 0..9.
//
//  en = 1 -> el digito avanza una cuenta en este flanco (9 -> 0, wrap)
//  co = "carry out" (acarreo): vale 1 cuando el digito esta en 9 Y se le
//       pide avanzar; es decir, en el MISMO ciclo en que pasa de 9 a 0.
//       Conectando co de las unidades al en de las decenas se encadenan
//       los digitos: 09 -> 10, 19 -> 20, ..., 99 -> 00.
// =====================================================================
`timescale 1ns/1ps
module contador_bcd (
    input  wire       clk,
    input  wire       rst_n,          // reset asincrono, activo en bajo
    input  wire       en,             // avanzar una cuenta (pulso de 1 ciclo)
    output reg  [3:0] q,              // digito actual 0..9
    output wire       co              // acarreo hacia el siguiente digito
);
    assign co = en & (q == 4'd9);     // combinacional: "voy a pasar de 9 a 0"

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'd0;
        else if (en)
            q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
        // en = 0: q se mantiene (memoria)
    end
endmodule
