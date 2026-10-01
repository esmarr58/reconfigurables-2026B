module clockgenerico #(
    parameter [24:0] limite = 0
)(
    input fin,
    output reg fout = 0
);

reg [24:0] contador = 0;

always @(posedge fin)
begin
    if (contador == limite)
    begin
        contador <= 0;
        fout <= ~fout;
    end
    else
    begin
        contador <= contador + 1'b1;
    end
end

endmodule
