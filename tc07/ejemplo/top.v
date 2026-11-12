// Ejemplo resuelto del TC07: cuenta las pulsaciones de un boton y las muestra en un display
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn,
    output wire [3:0] cuenta,
    output wire [6:0] seg
);
    wire       pulso;
    wire [3:0] q_cnt;

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn),
        .pulso (pulso)
    );

    contador4 u_cnt (
        .clk (clk),
        .rst (rst),
        .en  (pulso),
        .q   (q_cnt)
    );

    deco_7seg u_deco (
        .dato (q_cnt),
        .seg  (seg)
    );

    assign cuenta = q_cnt;
endmodule
