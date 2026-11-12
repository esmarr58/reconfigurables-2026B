// Generador pseudoaleatorio LFSR de 4 bits (x^4 + x^3 + 1), nunca vale 0
module lfsr4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'b0001;
        else if (en)
            q <= {q[2:0], q[3] ^ q[2]};
    end
endmodule
