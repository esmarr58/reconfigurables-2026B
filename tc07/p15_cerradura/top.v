// Cerradura: btn_guardar memoriza la clave y btn_probar la compara con codigo
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       btn_guardar,
    input  wire       btn_probar,
    input  wire [3:0] codigo,
    output wire       abierto,
    output wire       cerrado
);
    wire       p_guardar;
    wire       p_probar;
    wire [3:0] clave;
    wire       coincide;

    detector_subida u_flanco_g (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_guardar),
        .pulso (p_guardar)
    );

    detector_subida u_flanco_p (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_probar),
        .pulso (p_probar)
    );

    registro4 u_clave (
        .clk (clk),
        .rst (rst),
        .en  (p_guardar),
        .d   (codigo),
        .q   (clave)
    );

    comparador_igual4 u_cmp (
        .a     (codigo),
        .b     (clave),
        .igual (coincide)
    );

    ff_d_en u_estado (
        .clk (clk),
        .rst (rst),
        .en  (p_probar),
        .d   (coincide),
        .q   (abierto)
    );

    compuerta_not u_not (
        .a (abierto),
        .y (cerrado)
    );
endmodule
