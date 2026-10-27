// =====================================================================
//  divisor_tick.v  --  Base de tiempo: un pulso de habilitacion cada N ciclos
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3 (marquesina)
//
//  Es el tick_gen del TC06 / Practica 2 con un cambio: N ya no es un
//  parameter fijo; llega por el puerto 'limite' (= N - 1) porque los
//  switches SW[2:1] lo cambian en marcha (4 velocidades).
//
//  NO genera un reloj: 'tick' es un pulso de UN ciclo de clk que el resto
//  del diseno usa como HABILITACION (if (tick) ...). Todo el sistema sigue
//  con un solo reloj de 50 MHz y el .sdc solo declara ese reloj.
//
//  Se compara con '>=' y no con '==': si el usuario sube la velocidad
//  cuando cnt ya paso del nuevo limite, con '==' el contador tendria que
//  dar la vuelta completa (2^26 ciclos = 1.3 s) y la marquesina se
//  "colgaria" en ese cambio.
//
//  en = 0 congela el conteo (PAUSA) y no emite ticks.
// =====================================================================
`timescale 1ns/1ps
module divisor_tick (
    input  wire        clk,
    input  wire        rst_n,         // reset asincrono, activo en bajo
    input  wire        en,            // 0 = pausa
    input  wire [25:0] limite,        // N - 1   (2^26 = 67 108 864 > 50 000 000)
    output reg         tick           // 1 ciclo cada N
);
    reg [25:0] cnt;

    always @(posedge clk or negedge rst_n)
        if (!rst_n)             begin cnt <= 26'd0; tick <= 1'b0; end
        else if (!en)           tick <= 1'b0;                     // congelado
        else if (cnt >= limite) begin cnt <= 26'd0; tick <= 1'b1; end
        else                    begin cnt <= cnt + 1'b1; tick <= 1'b0; end
endmodule
