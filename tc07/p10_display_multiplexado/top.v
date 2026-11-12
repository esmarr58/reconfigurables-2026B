// Barrido de cuatro displays que comparten las lineas de segmentos
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,
    input  wire [3:0] d3,
    output wire [6:0] seg,
    output wire [3:0] anodos
);
    wire       tick;
    wire [1:0] sel;
    wire [3:0] dato;

    divisor_frec #(.N(50000)) u_div (
        .clk  (clk),
        .rst  (rst),
        .tick (tick)
    );

    contador2 u_sel (
        .clk (clk),
        .rst (rst),
        .en  (tick),
        .q   (sel)
    );

    mux4_4 u_mux (
        .d0  (d0),
        .d1  (d1),
        .d2  (d2),
        .d3  (d3),
        .sel (sel),
        .y   (dato)
    );

    deco2a4 u_anodos (
        .sel (sel),
        .en  (1'b1),
        .y   (anodos)
    );

    deco_7seg u_deco (
        .dato (dato),
        .seg  (seg)
    );
endmodule
