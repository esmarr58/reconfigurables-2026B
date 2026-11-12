// Muestra el mayor y el menor de dos numeros de 4 bits
module top (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [6:0] seg_max,
    output wire [6:0] seg_min,
    output wire       a_mayor,
    output wire       iguales,
    output wire       a_menor
);
    wire [3:0] maximo;
    wire [3:0] minimo;

    comparador4 u_cmp (
        .a     (a),
        .b     (b),
        .mayor (a_mayor),
        .igual (iguales),
        .menor (a_menor)
    );

    mux2_4 u_mux_max (
        .d0  (b),
        .d1  (a),
        .sel (a_mayor),
        .y   (maximo)
    );

    mux2_4 u_mux_min (
        .d0  (a),
        .d1  (b),
        .sel (a_mayor),
        .y   (minimo)
    );

    deco_7seg u_deco_max (
        .dato (maximo),
        .seg  (seg_max)
    );

    deco_7seg u_deco_min (
        .dato (minimo),
        .seg  (seg_min)
    );
endmodule
