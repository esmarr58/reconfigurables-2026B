// =====================================================================
//  marquesina_top.v  --  Practica 3: marquesina con tu nombre en HEX5..HEX0
//  Sistemas Reconfigurables (V3737) - 2026B
//  *** ESQUELETO DEL KIT: completa los TODO 2, 3 y 5 ***
//  Tarjeta: Terasic DE10-Lite (MAX 10 10M50DAF484C7G), reloj de 50 MHz
//
//  ENTRADAS
//    KEY[0]   RESET (activo en bajo): carga el mensaje en su posicion inicial
//    KEY[1]   PAUSA: cada pulsacion congela / reanuda el desplazamiento
//    SW[0]    DIRECCION: 0 = el texto corre a la izquierda, 1 = a la derecha
//    SW[2:1]  VELOCIDAD: 00 = 8*N_BASE ciclos por caracter (lenta) ...
//                        11 = N_BASE ciclos por caracter (rapida)
//
//  SALIDAS
//    HEX5..HEX0  ventana de 6 caracteres (HEX5 = el de la izquierda)
//    LEDR[9] pausa activa · LEDR[2:1] velocidad · LEDR[0] direccion
//
//  ARQUITECTURA (un solo reloj; 'tick' es una habilitacion, NO un reloj)
//    KEY1 -> antirrebote (2 FF + 20 ms) -> detector_flanco -> alterna PAUSA
//    SW[2:0] -> sincronizador (2 FF) -> dir y velocidad
//    MUX de velocidad -> limite -> divisor_tick -> tick
//    tick -> registro_marquesina (rota 1 caracter ASCII de 8 bits)
//    ventana = 6 caracteres de arriba -> 6 x char_a_7seg -> HEX5..HEX0
//
//  PERSONALIZACION (antiplagio)
//    MSG    = tu nombre en MAYUSCULAS, sin acentos (la enie se escribe N),
//             + espacios hasta tener EXACTAMENTE LEN caracteres
//    DIGITO = ultimo digito de tu codigo de alumno. N_BASE = 4 000 000 +
//             250 000 * DIGITO: la velocidad lenta (SW[2:1] = 00) da un
//             caracter cada 0.64 + 0.04 * DIGITO segundos.
//             (DIGITO = 9 da N_BASE = 6 250 000, el valor del deck: 8 car/s)
//
//  Interfaz que el testbench espera: parametros N_BASE, DEB_N, LEN y MSG, y
//  las senales internas 'tick', 'dir', 'r' y 'ventana' (no les cambies el nombre).
// =====================================================================
`timescale 1ns/1ps
module marquesina_top #(
    // TODO 2: el ultimo digito de tu codigo, tu LEN y tu MSG (MAYUSCULAS, sin
    //         acentos, enie = N, + espacios hasta EXACTAMENTE LEN caracteres)
    parameter DIGITO = 9,                         // ultimo digito de tu codigo
    parameter N_BASE = 4_000_000 + 250_000 * DIGITO,  // ciclos por car. en SW[2:1] = 11
    parameter DEB_N  = 1_000_000,                 // 20 ms de antirrebote
    parameter LEN    = 11,
    parameter [8*LEN-1:0] MSG = "HOLA CUCEI "     // TU nombre + espacios
) (
    input  wire       MAX10_CLK1_50,
    input  wire [1:0] KEY,                        // activos en bajo
    input  wire [9:0] SW,                         // 1 = arriba (hacia los LEDs)
    output wire [9:0] LEDR,
    output wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    wire clk   = MAX10_CLK1_50;
    wire rst_n = KEY[0];          // KEY0 = reset (los KEY ya traen Schmitt trigger)

    // ---- 1) entradas: switches sincronizados; KEY1 con antirrebote + flanco
    wire [2:0] sw_s;                              // {SW[2], SW[1], SW[0]} sincronos
    sincronizador #(.W(3)) u_sw (.clk(clk), .d(SW[2:0]), .q(sw_s));
    wire       dir   = sw_s[0];
    wire [1:0] nivel = sw_s[2:1];

    // TODO 5: PAUSA con KEY1, como el INC de la P2:
    //   1) wire k1, k1_p;
    //   2) antirrebote u_db con N = DEB_N y entrada ~KEY[1] (oprimido = 1) -> k1
    //   3) detector_flanco u_fl: nivel k1 -> pulso k1_p
    //   4) cambia la linea provisional por un 'reg pausa' que se borre con
    //      rst_n y ALTERNE (pausa <= ~pausa) con cada pulso k1_p.
    wire pausa = 1'b0;                            // provisional: nunca pausa

    // ---- 2) velocidad: MUX de 4 limites (N - 1) ----------------------------
    reg [25:0] limite;
    always @(*)
        case (nivel)
            2'd0: limite = 8*N_BASE - 1;          // lenta
            // TODO 3: agrega 2'd1, 2'd2 y 2'd3 (4, 2 y 1 veces N_BASE)
            default: limite = 8*N_BASE - 1;       // provisional
        endcase

    wire tick;
    divisor_tick u_div (.clk(clk), .rst_n(rst_n), .en(~pausa),
                        .limite(limite), .tick(tick));

    // ---- 3) registro circular con el mensaje --------------------------------
    wire [8*LEN-1:0] r;
    registro_marquesina #(.LEN(LEN), .MSG(MSG)) u_reg (
        .clk(clk), .rst_n(rst_n), .tick(tick), .dir(dir), .r(r));

    // ---- 4) ventana: los 6 primeros caracteres -> HEX5..HEX0 ----------------
    wire [47:0] ventana = r[8*LEN-1 -: 48];
    wire [6:0] s5, s4, s3, s2, s1, s0;
    char_a_7seg d5 (.c(ventana[47:40]), .seg(s5));
    char_a_7seg d4 (.c(ventana[39:32]), .seg(s4));
    char_a_7seg d3 (.c(ventana[31:24]), .seg(s3));
    char_a_7seg d2 (.c(ventana[23:16]), .seg(s2));
    char_a_7seg d1 (.c(ventana[15: 8]), .seg(s1));
    char_a_7seg d0 (.c(ventana[ 7: 0]), .seg(s0));
    assign HEX5 = {1'b1, s5};  assign HEX4 = {1'b1, s4};   // DP apagado (1)
    assign HEX3 = {1'b1, s3};  assign HEX2 = {1'b1, s2};
    assign HEX1 = {1'b1, s1};  assign HEX0 = {1'b1, s0};

    // ---- 5) LEDs de estado ----------------------------------------------------
    assign LEDR = {pausa, 6'b0, nivel, dir};
endmodule
