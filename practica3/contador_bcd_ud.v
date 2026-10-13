// =====================================================================
//  contador_bcd_ud.v  --  Digito BCD ascendente/descendente (up/down)
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3
//  *** ESQUELETO DEL ALUMNO: completa los bloques marcados con TODO ***
//
//  Es el contador_bcd del TC06 con tres cosas nuevas:
//    * down: cuenta hacia ABAJO (de 0 pasa a 9 "pidiendo prestado")
//    * clr : borrado SINCRONO a 0 (para el RESET de la practica)
//    * bo  : salida de prestamo (borrow) hacia el digito siguiente
//
//  COMPORTAMIENTO REQUERIDO (en cada flanco de subida de clk):
//    rst_n = 0            -> q = 0 (asincrono, reset de encendido)
//    clr   = 1            -> q = 0 (prioridad maxima; ignora up y down)
//    up = 1 y down = 1    -> q no cambia (se cancelan), co = bo = 0
//    solo up = 1          -> q + 1; de 9 pasa a 0
//    solo down = 1        -> q - 1; de 0 pasa a 9
//    up = down = 0        -> q no cambia
//
//  co = acarreo  (carry):  vale 1 en el MISMO ciclo en que el digito
//                          va a pasar de 9 a 0 al subir.
//  bo = prestamo (borrow): vale 1 en el MISMO ciclo en que el digito
//                          va a pasar de 0 a 9 al bajar.
//  co y bo son combinacionales (assign) y nunca valen 1 si clr = 1.
//  Encadenando co -> up y bo -> down de tres digitos se forma 000..999
//  que da la vuelta en ambos sentidos: 999 + 1 = 000 y 000 - 1 = 999.
// =====================================================================
`timescale 1ns/1ps
module contador_bcd_ud (
    input  wire       clk,
    input  wire       rst_n,          // reset asincrono, activo en bajo
    input  wire       clr,            // borrado sincrono (prioridad maxima)
    input  wire       up,             // sumar 1 (pulso de 1 ciclo)
    input  wire       down,           // restar 1 (pulso de 1 ciclo)
    output reg  [3:0] q,              // digito 0..9
    output wire       co,             // acarreo hacia el digito siguiente
    output wire       bo              // prestamo hacia el digito siguiente
);
    // TODO 1: define cuando el digito realmente SUBE y cuando realmente BAJA
    //         (recuerda: up y down a la vez se cancelan; clr manda).
    wire sube = 1'b0;                 // TODO 1: reemplaza 1'b0
    wire baja = 1'b0;                 // TODO 1: reemplaza 1'b0

    // TODO 2: acarreo y prestamo (combinacionales).
    assign co = 1'b0;                 // TODO 2: reemplaza 1'b0
    assign bo = 1'b0;                 // TODO 2: reemplaza 1'b0

    // TODO 3: registro del digito. Ya trae el reset asincrono; agrega
    //         clr, la subida (9 -> 0) y la bajada (0 -> 9).
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 4'd0;
        else        q <= q;           // TODO 3: reemplaza esta rama
    end
endmodule
