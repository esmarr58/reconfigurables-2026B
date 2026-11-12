// Flip-flop T: cambia de estado cuando t = 1
module ff_t (
    input  wire clk,
    input  wire rst,
    input  wire t,
    output reg  q
);
    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule
