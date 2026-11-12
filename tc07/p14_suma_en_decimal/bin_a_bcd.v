// Convierte un binario de 5 bits (0-31) a dos digitos BCD
module bin_a_bcd (
    input  wire [4:0] bin,
    output wire [3:0] decenas,
    output wire [3:0] unidades
);
    assign decenas  = (bin >= 5'd30) ? 4'd3 :
                      (bin >= 5'd20) ? 4'd2 :
                      (bin >= 5'd10) ? 4'd1 : 4'd0;
    assign unidades = bin - decenas * 4'd10;
endmodule
