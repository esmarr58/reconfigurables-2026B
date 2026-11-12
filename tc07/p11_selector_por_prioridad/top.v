// La peticion activa de mayor prioridad elige el dato que se guarda y se muestra
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] peticion,
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,
    input  wire [3:0] d3,
    output wire [6:0] seg,
    output wire       valido
);
    wire [1:0] sel;
    wire [3:0] dato;
    wire [3:0] dato_reg;

    codificador_prio u_cod (
        .d      (peticion),
        .y      (sel),
        .valido (valido)
    );

    mux4_4 u_mux (
        .d0  (d0),
        .d1  (d1),
        .d2  (d2),
        .d3  (d3),
        .sel (sel),
        .y   (dato)
    );

    registro4 u_reg (
        .clk (clk),
        .rst (rst),
        .en  (valido),
        .d   (dato),
        .q   (dato_reg)
    );

    deco_7seg u_deco (
        .dato (dato_reg),
        .seg  (seg)
    );
endmodule
