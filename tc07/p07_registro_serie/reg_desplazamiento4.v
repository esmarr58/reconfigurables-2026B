// Registro de desplazamiento de 4 bits: entra por q[0], sale por q[3]
module reg_desplazamiento4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire       sin,
    output reg  [3:0] q,
    output wire       sout
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (en)
            q <= {q[2:0], sin};
    end

    assign sout = q[3];
endmodule
