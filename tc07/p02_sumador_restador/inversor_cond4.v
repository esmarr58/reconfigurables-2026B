// Invierte los 4 bits de d cuando invertir = 1 (XOR con la senal de control)
module inversor_cond4 (
    input  wire [3:0] d,
    input  wire       invertir,
    output wire [3:0] y
);
    assign y = d ^ {4{invertir}};
endmodule
