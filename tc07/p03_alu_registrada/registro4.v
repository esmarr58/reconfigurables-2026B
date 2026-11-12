// Registro de 4 bits con reset sincrono y habilitacion
module registro4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [3:0] d,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (en)
            q <= d;
    end
endmodule
