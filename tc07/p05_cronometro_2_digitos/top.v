// Cronometro 00-99: unidades y decenas en cascada
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output wire [6:0] seg_uni,
    output wire [6:0] seg_dec,
    output wire       fin
);
    wire       tick;
    wire       en_uni;
    wire       tc_uni;
    wire [3:0] unidades;
    wire [3:0] decenas;

    divisor_frec #(.N(50000000)) u_div (
        .clk  (clk),
        .rst  (rst),
        .tick (tick)
    );

    compuerta_and u_and (
        .a (tick),
        .b (en),
        .y (en_uni)
    );

    contador_mod10 u_uni (
        .clk (clk),
        .rst (rst),
        .en  (en_uni),
        .q   (unidades),
        .tc  (tc_uni)
    );

    contador_mod10 u_dec (
        .clk (clk),
        .rst (rst),
        .en  (tc_uni),
        .q   (decenas),
        .tc  (fin)
    );

    deco_7seg u_deco_uni (
        .dato (unidades),
        .seg  (seg_uni)
    );

    deco_7seg u_deco_dec (
        .dato (decenas),
        .seg  (seg_dec)
    );
endmodule
