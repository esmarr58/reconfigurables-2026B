// Contador decimal de un digito que avanza cada segundo; btn lo arranca o lo pausa
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn,
    output wire [6:0] seg,
    output wire       tc
);
    wire       tick_1hz;
    wire       p_btn;
    wire       corriendo;
    wire       en_cnt;
    wire [3:0] cuenta;

    divisor_frec #(.N(50000000)) u_div (
        .clk  (clk),
        .rst  (rst),
        .tick (tick_1hz)
    );

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn),
        .pulso (p_btn)
    );

    ff_t u_pausa (
        .clk (clk),
        .rst (rst),
        .t   (p_btn),
        .q   (corriendo)
    );

    compuerta_and u_and (
        .a (tick_1hz),
        .b (corriendo),
        .y (en_cnt)
    );

    contador_mod10 u_cnt (
        .clk (clk),
        .rst (rst),
        .en  (en_cnt),
        .q   (cuenta),
        .tc  (tc)
    );

    deco_7seg u_deco (
        .dato (cuenta),
        .seg  (seg)
    );
endmodule
