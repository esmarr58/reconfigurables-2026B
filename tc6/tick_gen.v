// =====================================================================
//  tick_gen.v  --  Generador de tick (divisor de frecuencia / prescaler)
//  Sistemas Reconfigurables (V3737) - 2026B - TC06 y Practica 2
//  Tarjeta: Terasic DE10-Lite (MAX 10 10M50DAF484C7G), reloj de 50 MHz
//
//  Emite un pulso 'tick' de UN solo ciclo de reloj cada N ciclos.
//    N = f_clk / f_tick  ->  1 Hz desde 50 MHz: N = 50_000_000
//    Se compara contra N-1 (49_999_999) porque el conteo empieza en 0.
//
//  en  = 1 cuenta; en = 0 congela el conteo (la Practica 2 lo usa para PAUSA)
//  clr = 1 regresa el conteo a 0 (sincrono; la Practica 2 lo usa con RESET)
//  En el TC06 se conectan en = 1'b1 y clr = 1'b0.
// =====================================================================
`timescale 1ns/1ps
module tick_gen #(
    parameter N = 50_000_000          // ciclos de reloj por tick (1 s a 50 MHz)
) (
    input  wire clk,                  // MAX10_CLK1_50 (50 MHz)
    input  wire rst_n,                // reset asincrono, activo en bajo
    input  wire clr,                  // borrado sincrono del conteo
    input  wire en,                   // habilita el conteo
    output reg  tick                  // 1 durante UN ciclo cada N ciclos
);
    reg [25:0] cnt;                   // 2^26 = 67 108 864 > 50 000 000

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 26'd0;
            tick <= 1'b0;
        end else if (clr) begin
            cnt  <= 26'd0;
            tick <= 1'b0;
        end else if (!en) begin
            tick <= 1'b0;             // congelado: no avanza ni emite tick
        end else if (cnt == N-1) begin
            cnt  <= 26'd0;            // auto-reload
            tick <= 1'b1;             // pulso de un ciclo
        end else begin
            cnt  <= cnt + 1'b1;
            tick <= 1'b0;
        end
    end
endmodule
