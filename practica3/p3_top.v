// =====================================================================
//  p3_top.v  --  Practica 3: reloj/temporizador 000..999 con 4 entradas
//  Sistemas Reconfigurables (V3737) - 2026B
//  Tarjeta: Terasic DE10-Lite (MAX 10 10M50DAF484C7G), reloj de 50 MHz
//  *** ESQUELETO DEL ALUMNO: completa los bloques marcados con TODO ***
//  Tal como esta, compila y muestra 000 fijo en HEX2:HEX0.
//
//  ENTRADAS (todas pasan por sincronizador + antirrebote de 20 ms):
//    KEY[0]  INCREMENTO  boton (activo en bajo) -> +1 por pulsacion (flanco)
//    KEY[1]  DECREMENTO  boton (activo en bajo) -> -1 por pulsacion (flanco)
//    SW[0]   PAUSA       switch: 1 = pausado (no avanza solo), 0 = corre
//    SW[9]   RESET       switch: 1 = muestra 000 y se queda ahi; 0 = libre
//
//  REGLAS (prioridad de mayor a menor):
//    1. RESET = 1 : cuenta = 000, el segundo en curso se reinicia y se
//                   ignoran tick, INC y DEC. Al bajar RESET cuenta desde 000
//                   y el primer tick llega 1 s completo despues.
//    2. INC / DEC : funcionan SIEMPRE (corriendo o en pausa): +1 / -1 por
//                   pulsacion; mantener el boton NO repite. Si INC y DEC
//                   llegan en el mismo ciclo, se cancelan.
//    3. tick 1 Hz : solo si PAUSA = 0. En pausa el divisor se congela, asi
//                   que al reanudar se completa el segundo que iba en curso.
//    Da la vuelta en ambos sentidos: 999 + 1 = 000 y 000 - 1 = 999.
//
//  SALIDAS: HEX2 HEX1 HEX0 = centenas decenas unidades; HEX3..HEX5 apagados.
//    LEDR[0] = PAUSA activa   LEDR[1] = latido (cambia en cada tick)
//    LEDR[2] = INC presionado LEDR[3] = DEC presionado  LEDR[9] = RESET activo
//
//  NO cambies la interfaz (nombres de modulo, parametros y puertos): el
//  archivo de pines p3.qsf depende de ella. Conserva el nombre de la
//  senal interna 'tick' (salida de tick_gen).
//  Parametros: TICK_N (ciclos por segundo) y DEB_N (ciclos de antirrebote).
//  Bajar TICK_N acelera la cuenta para probar las vueltas en la tarjeta.
// =====================================================================
`timescale 1ns/1ps
module p3_top #(
    parameter TICK_N = 50_000_000,    // 1 s a 50 MHz
    parameter DEB_N  = 1_000_000      // 20 ms a 50 MHz
) (
    input  wire       MAX10_CLK1_50,
    input  wire [1:0] KEY,            // activos en bajo
    input  wire [9:0] SW,             // 1 = arriba (hacia los LEDs)
    output wire [9:0] LEDR,
    output wire [7:0] HEX0,           // unidades  {DP,g,f,e,d,c,b,a}, activo en bajo
    output wire [7:0] HEX1,           // decenas
    output wire [7:0] HEX2,           // centenas
    output wire [7:0] HEX3,
    output wire [7:0] HEX4,
    output wire [7:0] HEX5
);
    wire clk = MAX10_CLK1_50;

    // ---- 0) reset de encendido (POR, power-on reset) -- COMPLETO ----------
    // Ningun boton queda libre para reset global: al configurarse la FPGA,
    // por_cnt arranca en 0 y mantiene rst_n = 0 durante 8 ciclos.
    reg [3:0] por_cnt = 4'd0;
    wire      rst_n   = por_cnt[3];
    always @(posedge clk)
        if (!por_cnt[3]) por_cnt <= por_cnt + 4'd1;

    // ---- 1) acondicionamiento de las 4 entradas ---------------------------
    wire inc_nivel, dec_nivel, pausa, reset_sw;

    // INCREMENTO: ejemplo completo. KEY es activo en bajo -> se invierte.
    antirrebote #(.N(DEB_N)) u_db_inc (.clk(clk), .rst_n(rst_n), .entrada(~KEY[0]), .limpia(inc_nivel));

    // TODO 4: instancia u_db_dec (KEY[1]), u_db_pau (SW[0]) y u_db_rst (SW[9])
    //         igual que u_db_inc y BORRA las tres lineas assign de abajo.
    assign dec_nivel = 1'b0;          // TODO 4: borrar al instanciar u_db_dec
    assign pausa     = 1'b0;          // TODO 4: borrar al instanciar u_db_pau
    assign reset_sw  = 1'b0;          // TODO 4: borrar al instanciar u_db_rst

    wire inc_p, dec_p;                // un pulso de 1 ciclo por pulsacion
    detector_flanco u_fl_inc (.clk(clk), .rst_n(rst_n), .nivel(inc_nivel), .pulso(inc_p));
    // TODO 5: instancia u_fl_dec (de dec_nivel a dec_p) y BORRA la linea assign.
    assign dec_p = 1'b0;              // TODO 5: borrar al instanciar u_fl_dec

    // ---- 2) base de tiempo de 1 s -----------------------------------------
    // TODO 6: conecta clr y en para cumplir las reglas 1 y 3
    //         (RESET borra el segundo en curso; PAUSA congela el divisor).
    wire tick;
    tick_gen #(.N(TICK_N)) u_tick (
        .clk(clk), .rst_n(rst_n),
        .clr(1'b0),                   // TODO 6
        .en(1'b1),                    // TODO 6
        .tick(tick)
    );

    // ---- 3) tres digitos BCD up/down encadenados --------------------------
    wire [3:0] unid, dece, cent;      // unidades, decenas, centenas

    // TODO 7: define que hace SUMAR y que hace RESTAR a las unidades.
    wire up   = 1'b0;                 // TODO 7
    wire down = 1'b0;                 // TODO 7

    // TODO 8: instancia tres contador_bcd_ud (u_unid, u_dece, u_cent) y
    //         encadenalos con sus salidas co / bo. Todos usan .clr(reset_sw).
    //         Al terminar BORRA las tres lineas assign de abajo.
    assign unid = 4'd0;               // TODO 8: borrar
    assign dece = 4'd0;               // TODO 8: borrar
    assign cent = 4'd0;               // TODO 8: borrar

    // ---- 4) displays (los mismos dec7seg del TC06) -- COMPLETO -------------
    wire [6:0] s_u, s_d, s_c;
    dec7seg u_seg_u (.bcd(unid), .seg(s_u));
    dec7seg u_seg_d (.bcd(dece), .seg(s_d));
    dec7seg u_seg_c (.bcd(cent), .seg(s_c));

    assign HEX0 = {1'b1, s_u};        // DP apagado
    assign HEX1 = {1'b1, s_d};
    assign HEX2 = {1'b1, s_c};
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;

    // ---- 5) LEDs de estado ------------------------------------------------
    reg latido;
    always @(posedge clk or negedge rst_n)
        if (!rst_n)    latido <= 1'b0;
        else if (tick) latido <= ~latido;

    assign LEDR[0]   = pausa;
    assign LEDR[1]   = latido;
    assign LEDR[2]   = inc_nivel;
    assign LEDR[3]   = dec_nivel;
    assign LEDR[8:4] = 5'b0;
    assign LEDR[9]   = reset_sw;
endmodule
