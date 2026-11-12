// Multiplexor 4 a 1 de 4 bits
module mux4_4 (
    input  wire [3:0] d0,
    input  wire [3:0] d1,
    input  wire [3:0] d2,
    input  wire [3:0] d3,
    input  wire [1:0] sel,
    output reg  [3:0] y
);
    always @(*) begin
        case (sel)
            2'b00:   y = d0;
            2'b01:   y = d1;
            2'b10:   y = d2;
            default: y = d3;
        endcase
    end
endmodule
