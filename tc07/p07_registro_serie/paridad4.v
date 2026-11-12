// par = 1 cuando d tiene un numero impar de unos
module paridad4 (
    input  wire [3:0] d,
    output wire       par
);
    assign par = ^d;
endmodule
