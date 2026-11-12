// Sumador de 4 bits con acarreo en cascada
module top (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] s,
    output wire       cout
);
    wire c1;
    wire c2;
    wire c3;
    wire s0;
    wire s1;
    wire s2;
    wire s3;

    sumador_completo u_fa0 (.a(a[0]), .b(b[0]), .cin(cin), .s(s0), .cout(c1));
    sumador_completo u_fa1 (.a(a[1]), .b(b[1]), .cin(c1),  .s(s1), .cout(c2));
    sumador_completo u_fa2 (.a(a[2]), .b(b[2]), .cin(c2),  .s(s2), .cout(c3));
    sumador_completo u_fa3 (.a(a[3]), .b(b[3]), .cin(c3),  .s(s3), .cout(cout));

    assign s = {s3, s2, s1, s0};
endmodule
