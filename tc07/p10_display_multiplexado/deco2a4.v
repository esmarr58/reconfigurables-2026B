// Decodificador 2 a 4 con habilitacion (salidas activas en alto)
module deco2a4 (
    input  wire [1:0] sel,
    input  wire       en,
    output reg  [3:0] y
);
    always @(*) begin
        if (!en)
            y = 4'b0000;
        else begin
            case (sel)
                2'b00:   y = 4'b0001;
                2'b01:   y = 4'b0010;
                2'b10:   y = 4'b0100;
                default: y = 4'b1000;
            endcase
        end
    end
endmodule
