// cero = 1 cuando los 4 bits de d valen 0
module detector_cero4 (
    input  wire [3:0] d,
    output wire       cero
);
    assign cero = (d == 4'b0000);
endmodule
