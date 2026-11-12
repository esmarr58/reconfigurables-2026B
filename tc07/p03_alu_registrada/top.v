// ALU de 4 bits con el resultado guardado en un registro
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       cargar,
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [1:0] op,
    output wire [3:0] resultado,
    output wire [6:0] seg,
    output wire       cero
);
    wire [3:0] r_alu;

    alu4 u_alu (
        .a  (a),
        .b  (b),
        .op (op),
        .r  (r_alu)
    );

    registro4 u_reg (
        .clk (clk),
        .rst (rst),
        .en  (cargar),
        .d   (r_alu),
        .q   (resultado)
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
