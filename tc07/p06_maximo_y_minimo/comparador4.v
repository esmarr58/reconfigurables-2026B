// Comparador de magnitud de 4 bits
module comparador4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire       mayor,
    output wire       igual,
    output wire       menor
);
    assign mayor = (a > b);
    assign igual = (a == b);
    assign menor = (a < b);
endmodule
