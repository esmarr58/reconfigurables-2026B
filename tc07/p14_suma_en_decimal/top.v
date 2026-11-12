// Suma dos numeros de 4 bits y muestra el resultado (0-30) en decimal
module top (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [6:0] seg_dec,
    output wire [6:0] seg_uni
);
    wire [3:0] suma;
    wire       c_out;
    wire [3:0] decenas;
    wire [3:0] unidades;

    sumador4 u_sum (
        .a    (a),
        .b    (b),
        .cin  (1'b0),
        .s    (suma),
        .cout (c_out)
    );

    bin_a_bcd u_bcd (
        .bin      ({c_out, suma}),
        .decenas  (decenas),
        .unidades (unidades)
    );

    deco_7seg u_deco_dec (
        .dato (decenas),
        .seg  (seg_dec)
    );

    deco_7seg u_deco_uni (
        .dato (unidades),
        .seg  (seg_uni)
    );
endmodule
