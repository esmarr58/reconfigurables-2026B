// Multiplexor 2 a 1 de 4 bits
module mux2_4 (
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire       sel,
    output wire [3:0] y
);
    assign y = sel ? d1 : d0;
endmodule
