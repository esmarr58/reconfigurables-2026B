// Pulso de un ciclo de reloj en cada flanco de subida de in
module detector_subida (
    input  wire clk,
    input  wire rst,
    input  wire in,
    output wire pulso
);
    reg anterior;

    always @(posedge clk) begin
        if (rst)
            anterior <= 1'b0;
        else
            anterior <= in;
    end

    assign pulso = in & ~anterior;
endmodule
