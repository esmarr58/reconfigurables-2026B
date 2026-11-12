// Contador decimal 0-9 con habilitacion; tc = 1 cuando va a pasar de 9 a 0
module contador_mod10 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q,
    output wire       tc
);
    always @(posedge clk) begin
        if (rst)
            q <= 4'd0;
        else if (en) begin
            if (q == 4'd9)
                q <= 4'd0;
            else
                q <= q + 4'd1;
        end
    end

    assign tc = en & (q == 4'd9);
endmodule
