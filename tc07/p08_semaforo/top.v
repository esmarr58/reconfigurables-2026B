// Semaforo: la maquina de estados reinicia el contador de segundos en cada cambio
module top (
    input  wire       clk,
    input  wire       rst,
    output wire       rojo,
    output wire       amarillo,
    output wire       verde,
    output wire [6:0] seg
);
    wire       tick;
    wire       reinicia;
    wire       rst_cnt;
    wire [3:0] tiempo;

    divisor_frec #(.N(50000000)) u_div (
        .clk  (clk),
        .rst  (rst),
        .tick (tick)
    );

    fsm_semaforo u_fsm (
        .clk      (clk),
        .rst      (rst),
        .tick     (tick),
        .tiempo   (tiempo),
        .reinicia (reinicia),
        .rojo     (rojo),
        .amarillo (amarillo),
        .verde    (verde)
    );

    compuerta_or u_or (
        .a (rst),
        .b (reinicia),
        .y (rst_cnt)
    );

    contador4 u_tiempo (
        .clk (clk),
        .rst (rst_cnt),
        .en  (tick),
        .q   (tiempo)
    );

    deco_7seg u_deco (
        .dato (tiempo),
        .seg  (seg)
    );
endmodule
