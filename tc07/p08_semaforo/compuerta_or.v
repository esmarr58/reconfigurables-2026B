// Compuerta OR de 2 entradas
module compuerta_or (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule
