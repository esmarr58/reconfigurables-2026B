module vga(
    input clk,

    output reg [3:0] rojo,
    output reg [3:0] verde,
    output reg [3:0] azul,

    output reg hsync,
    output reg vsync
);

// Parametros VGA 640x480
localparam [9:0] H_VISIBLE = 640;
localparam [9:0] H_FRONT   = 16;
localparam [9:0] H_SYNC    = 96;
localparam [9:0] H_BACK    = 48;
localparam [9:0] H_TOTAL   = 800;

localparam [9:0] V_VISIBLE = 480;
localparam [9:0] V_FRONT   = 10;
localparam [9:0] V_SYNC    = 2;
localparam [9:0] V_BACK    = 33;
localparam [9:0] V_TOTAL   = 525;

reg [9:0] contadorH = 0;
reg [9:0] contadorV = 0;

// Contadores horizontal y vertical
always @(posedge clk)
begin
    if (contadorH == H_TOTAL - 1'b1)
    begin
        contadorH <= 0;

        if (contadorV == V_TOTAL - 1'b1)
            contadorV <= 0;
        else
            contadorV <= contadorV + 1'b1;
    end
    else
        contadorH <= contadorH + 1'b1;
end

// Sincronizacion horizontal
always @(*)
begin
    if ((contadorH >= H_VISIBLE + H_FRONT) &&
        (contadorH <  H_VISIBLE + H_FRONT + H_SYNC))
        hsync = 0;
    else
        hsync = 1;
end

// Sincronizacion vertical
always @(*)
begin
    if ((contadorV >= V_VISIBLE + V_FRONT) &&
        (contadorV <  V_VISIBLE + V_FRONT + V_SYNC))
        vsync = 0;
    else
        vsync = 1;
end

// Pantalla roja dentro del area visible
always @(*)
begin
    if ((contadorH < H_VISIBLE) && (contadorV < V_VISIBLE))
    begin
        rojo  = 4'b1111;
        verde = 4'b0000;
        azul  = 4'b0000;
    end
    else
    begin
        rojo  = 4'b0000;
        verde = 4'b0000;
        azul  = 4'b0000;
    end
end

endmodule
