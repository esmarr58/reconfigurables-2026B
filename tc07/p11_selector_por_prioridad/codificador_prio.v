// Codificador de prioridad 4 a 2: gana el bit mas significativo en 1
module codificador_prio (
    input  wire [3:0] d,
    output reg  [1:0] y,
    output wire       valido
);
    always @(*) begin
        if (d[3])
            y = 2'd3;
        else if (d[2])
            y = 2'd2;
        else if (d[1])
            y = 2'd1;
        else
            y = 2'd0;
    end

    assign valido = |d;
endmodule
