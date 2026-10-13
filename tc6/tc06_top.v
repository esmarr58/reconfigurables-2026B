// =====================================================================
//  tc06_top.v  --  TC06: contador 00..99 en dos displays de 7 segmentos
//  Sistemas Reconfigurables (V3737) - 2026B - Trabajo en clase 6
//  Tarjeta: Terasic DE10-Lite (MAX 10 10M50DAF484C7G)
//
//  MAX10_CLK1_50 (50 MHz) -> tick_gen (1 Hz) -> unidades (BCD) --co--> decenas (BCD)
//                                                |                      |
//                                             dec7seg -> HEX0        dec7seg -> HEX1
//  KEY[0] = reset (activo en bajo, como en el TC05): al presionarlo vuelve a 00.
//  LEDR[3:0] = unidades en binario, LEDR[7:4] = decenas, LEDR[9] cambia de estado en cada tick (1 s encendido, 1 s apagado).
//  HEX2..HEX5 se apagan (todos sus segmentos en 1 = apagado).
//
//  Parametro TICK_N: 50_000_000 en la tarjeta (1 s). Si lo bajas (p. ej.
//  5_000_000 = 0.1 s) ves la cuenta 10 veces mas rapido en la tarjeta.
// =====================================================================
`timescale 1ns/1ps
module tc06_top #(
    parameter TICK_N = 50_000_000
) (
    input  wire       MAX10_CLK1_50,  // reloj de 50 MHz (PIN_P11)
    input  wire [1:0] KEY,            // botones, ACTIVOS EN BAJO
    output wire [9:0] LEDR,           // LEDs rojos (activos en alto)
    output wire [7:0] HEX0,           // display de unidades  {DP,g,f,e,d,c,b,a}
    output wire [7:0] HEX1,           // display de decenas
    output wire [7:0] HEX2,           // displays no usados: apagados
    output wire [7:0] HEX3,
    output wire [7:0] HEX4,
    output wire [7:0] HEX5
);
    wire clk   = MAX10_CLK1_50;
    wire rst_n = KEY[0];              // sin presionar = 1 (normal); presionado = 0 (reset)

    // ---- 1) tick de 1 Hz -------------------------------------------------
    wire tick;
    tick_gen #(.N(TICK_N)) u_tick (
        .clk(clk), .rst_n(rst_n), .clr(1'b0), .en(1'b1), .tick(tick)
    );

    // ---- 2) unidades: avanzan con cada tick ------------------------------
    wire [3:0] unidades;
    wire       co_u;                  // acarreo de unidades (9 -> 0)
    contador_bcd u_unid (
        .clk(clk), .rst_n(rst_n), .en(tick), .q(unidades), .co(co_u)
    );

    // ---- 3) decenas: avanzan SOLO cuando las unidades pasan de 9 a 0 -----
    wire [3:0] decenas;
    wire       co_d;                  // 99 -> 00 (no se usa: el contador da la vuelta)
    contador_bcd u_dec (
        .clk(clk), .rst_n(rst_n), .en(co_u), .q(decenas), .co(co_d)
    );

    // ---- 4) decodificadores a 7 segmentos (anodo comun: 0 = encendido) ---
    wire [6:0] seg_u, seg_d;
    dec7seg u_seg_u (.bcd(unidades), .seg(seg_u));
    dec7seg u_seg_d (.bcd(decenas),  .seg(seg_d));

    assign HEX0 = {1'b1, seg_u};      // DP apagado (1) + segmentos
    assign HEX1 = {1'b1, seg_d};
    assign HEX2 = 8'hFF;              // apagados
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;

    // ---- 5) LEDs de apoyo: el conteo en binario y el "latido" del tick ------
    reg latido;                       // cambia en cada tick: ves "el segundo"
    always @(posedge clk or negedge rst_n)
        if (!rst_n)    latido <= 1'b0;
        else if (tick) latido <= ~latido;

    assign LEDR[3:0] = unidades;
    assign LEDR[7:4] = decenas;
    assign LEDR[8]   = 1'b0;
    assign LEDR[9]   = latido;
endmodule
