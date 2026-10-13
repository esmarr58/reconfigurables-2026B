// =====================================================================
//  antirrebote.v  --  Sincronizador (2 FF) + filtro antirrebote
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3
//
//  1) Sincronizador de dos flip-flops (FF): la entrada viene de un humano
//     (boton o switch) y cambia cuando quiere, no al ritmo del reloj.
//     Dos FF en cadena evitan la metaestabilidad (Clase 14, modulo sync2).
//  2) Antirrebote (debounce): un contacto mecanico "rebota" varios
//     milisegundos (0-1-0-1...) al cambiar. La salida 'limpia' solo cambia
//     cuando la entrada sincronizada se mantuvo IGUAL durante N ciclos
//     seguidos.  N = 1_000_000 ciclos = 20 ms a 50 MHz.
//
//  La salida es un NIVEL limpio (no un pulso). Para obtener un solo pulso
//  por pulsacion se conecta despues el modulo detector_flanco.
//  Los botones KEY de la DE10-Lite ya traen un Schmitt trigger, pero los
//  switches SW no: se filtran las 4 entradas por igual.
// =====================================================================
`timescale 1ns/1ps
module antirrebote #(
    parameter N = 1_000_000,          // ciclos estables requeridos (20 ms)
    parameter INICIAL = 1'b0          // valor tras reset (1 para un KEY suelto)
) (
    input  wire clk,
    input  wire rst_n,
    input  wire entrada,              // senal cruda del boton / switch
    output reg  limpia                // nivel sin rebotes
);
    // ---- 1) sincronizador de 2 FF ----
    reg meta, sinc;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin meta <= INICIAL; sinc <= INICIAL; end
        else        begin meta <= entrada; sinc <= meta;    end

    // ---- 2) filtro: cuenta cuanto tiempo lleva 'sinc' distinto de 'limpia' ----
    reg [19:0] cnt;                   // 2^20 = 1 048 576 > 1 000 000
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt    <= 20'd0;
            limpia <= INICIAL;
        end else if (sinc == limpia) begin
            cnt    <= 20'd0;          // no hay cambio (o fue un rebote): reinicia
        end else if (cnt == N-1) begin
            cnt    <= 20'd0;
            limpia <= sinc;           // estuvo estable N ciclos: acepta el cambio
        end else begin
            cnt    <= cnt + 1'b1;
        end
    end
endmodule
