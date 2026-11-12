// Sumador/restador de 4 bits: modo = 0 suma, modo = 1 resta (a - b)
module top (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       modo,
    output wire [6:0] seg,
    output wire       cout,
    output wire       cero
);
    wire [3:0] b_x;
    wire [3:0] resultado;

    inversor_cond4 u_inv (
        .d        (b),
        .invertir (modo),
        .y        (b_x)
    );

    sumador4 u_sum (
        .a    (a),
        .b    (b_x),
        .cin  (modo),
        .s    (resultado),
        .cout (cout)
    );

    detector_cero4 u_cero (
        .d    (resultado),
        .cero (cero)
    );

    deco_7seg u_deco (
        .dato (resultado),
        .seg  (seg)
    );
endmodule
