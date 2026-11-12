// Contador binario de 2 bits con reset sincrono y habilitacion
module contador2 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [1:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 2'd0;
        else if (en)
            q <= q + 2'd1;
    end
endmodule
