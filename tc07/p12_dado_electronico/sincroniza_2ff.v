// Sincronizador de dos flip-flops para una entrada asincrona
module sincroniza_2ff (
    input  wire clk,
    input  wire d,
    output reg  q
);
    reg etapa1;

    always @(posedge clk) begin
        etapa1 <= d;
        q      <= etapa1;
    end
endmodule
