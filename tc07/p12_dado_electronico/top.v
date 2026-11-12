// Al pulsar btn se captura el valor de un generador pseudoaleatorio
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn,
    output wire [3:0] numero,
    output wire [6:0] seg
);
    wire       btn_sync;
    wire       p_btn;
    wire [3:0] aleatorio;

    sincroniza_2ff u_sync (
        .clk (clk),
        .d   (btn),
        .q   (btn_sync)
    );

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_sync),
        .pulso (p_btn)
    );

    lfsr4 u_lfsr (
        .clk (clk),
        .rst (rst),
        .en  (1'b1),
        .q   (aleatorio)
    );

    registro4 u_reg (
        .clk (clk),
        .rst (rst),
        .en  (p_btn),
        .d   (aleatorio),
        .q   (numero)
    );

    deco_7seg u_deco (
        .dato (numero),
        .seg  (seg)
    );
endmodule
