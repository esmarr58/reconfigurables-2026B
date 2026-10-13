// =====================================================================
//  detector_flanco.v  --  Detector de flanco de subida (pulso unico)
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3
//
//  Recuerda el valor del ciclo anterior ('previo') y genera 'pulso' = 1
//  durante UN solo ciclo cuando la entrada pasa de 0 a 1:
//
//      nivel :  0 0 1 1 1 1 1 1 0 0
//      previo:  0 0 0 1 1 1 1 1 1 0
//      pulso :  0 0 1 0 0 0 0 0 0 0      pulso = nivel & ~previo
//
//  Sin este modulo, mantener presionado un boton 0.3 s sumaria
//  15 000 000 cuentas (una por ciclo de 50 MHz) en vez de una sola.
// =====================================================================
`timescale 1ns/1ps
module detector_flanco (
    input  wire clk,
    input  wire rst_n,
    input  wire nivel,                // entrada YA sin rebotes, activa en alto
    output wire pulso                 // 1 ciclo en cada flanco 0 -> 1
);
    reg previo;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) previo <= 1'b0;
        else        previo <= nivel;

    assign pulso = nivel & ~previo;
endmodule
