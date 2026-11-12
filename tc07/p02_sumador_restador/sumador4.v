// Sumador de 4 bits con acarreo de entrada y de salida
module sumador4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] s,
    output wire       cout
);
    assign {cout, s} = a + b + cin;
endmodule
