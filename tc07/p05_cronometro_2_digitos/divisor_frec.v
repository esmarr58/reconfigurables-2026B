// Genera un pulso de un ciclo de reloj cada N ciclos
module divisor_frec #(
    parameter N = 50000000
) (
    input  wire clk,
    input  wire rst,
    output reg  tick
);
    reg [31:0] cuenta;

    always @(posedge clk) begin
        if (rst) begin
            cuenta <= 32'd0;
            tick   <= 1'b0;
        end else if (cuenta == N - 1) begin
            cuenta <= 32'd0;
            tick   <= 1'b1;
        end else begin
            cuenta <= cuenta + 32'd1;
            tick   <= 1'b0;
        end
    end
endmodule
