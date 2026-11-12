// ALU de 4 bits: op = 00 suma, 01 resta, 10 AND, 11 OR
module alu4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [1:0] op,
    output reg  [3:0] r
);
    always @(*) begin
        case (op)
            2'b00:   r = a + b;
            2'b01:   r = a - b;
            2'b10:   r = a & b;
            default: r = a | b;
        endcase
    end
endmodule
