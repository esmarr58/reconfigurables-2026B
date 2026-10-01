module top(
    input MAX10_CLK1_50,

    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,

    output VGA_HS,
    output VGA_VS
);

wire clk25;

// Instancia del divisor: 50 MHz / 2 = 25 MHz
clockgenerico #(
    .limite(0)
) relojVGA (
    .fin(MAX10_CLK1_50),
    .fout(clk25)
);

// Instancia del generador VGA
vga pantalla (
    .clk(clk25),

    .rojo(VGA_R),
    .verde(VGA_G),
    .azul(VGA_B),

    .hsync(VGA_HS),
    .vsync(VGA_VS)
);

endmodule
