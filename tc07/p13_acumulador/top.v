// Acumulador: cada pulsacion de btn_suma agrega dato al valor guardado
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn_suma,
    input  wire [3:0] dato,
    output wire [6:0] seg,
    output wire       acarreo
);
    wire       p_suma;
    wire [3:0] suma;
    wire [3:0] acum;
    wire       c_out;

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_suma),
        .pulso (p_suma)
    );

    sumador4 u_sum (
        .a    (acum),
        .b    (dato),
        .cin  (1'b0),
        .s    (suma),
        .cout (c_out)
    );

    registro4 u_acum (
        .clk (clk),
        .rst (rst),
        .en  (p_suma),
        .d   (suma),
        .q   (acum)
    );

    ff_d_en u_acarreo (
        .clk (clk),
        .rst (rst),
        .en  (p_suma),
        .d   (c_out),
        .q   (acarreo)
    );

    deco_7seg u_deco (
        .dato (acum),
        .seg  (seg)
    );
endmodule
