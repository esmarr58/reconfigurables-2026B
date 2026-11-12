// Registro de desplazamiento cargado en serie con un boton
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       dato_serie,
    input  wire       btn_desplaza,
    output wire [3:0] q,
    output wire       sout,
    output wire       paridad
);
    wire btn_sync;
    wire desplaza;

    sincroniza_2ff u_sync (
        .clk (clk),
        .d   (btn_desplaza),
        .q   (btn_sync)
    );

    detector_subida u_flanco (
        .clk   (clk),
        .rst   (rst),
        .in    (btn_sync),
        .pulso (desplaza)
    );

    reg_desplazamiento4 u_sr (
        .clk  (clk),
        .rst  (rst),
        .en   (desplaza),
        .sin  (dato_serie),
        .q    (q),
        .sout (sout)
    );

    paridad4 u_par (
        .d   (q),
        .par (paridad)
    );
endmodule
