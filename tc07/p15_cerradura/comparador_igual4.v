// igual = 1 cuando a y b son iguales
module comparador_igual4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire       igual
);
    assign igual = (a == b);
endmodule
