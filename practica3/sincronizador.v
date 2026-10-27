// =====================================================================
//  sincronizador.v  --  Sincronizador de 2 flip-flops para W senales
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3 (marquesina)
//
//  Es la primera mitad del antirrebote de la Practica 2, separada en su
//  propio modulo (meta <= entrada; sinc <= meta). Sirve para entradas que
//  NO necesitan filtro de rebotes porque un rebote de unos milisegundos no
//  causa un error visible:
//    SW[0]    direccion   (si rebota, la marquesina "duda" 1-2 ms: no se ve)
//    SW[2:1]  velocidad   (igual)
//  Las entradas vienen de un humano y cambian cuando quieren, no al ritmo
//  del reloj: dos FF en cadena dan un ciclo completo para que se resuelva
//  una posible metaestabilidad (Clase 14). Latencia: 2 ciclos.
//
//  Sin reset: los FF arrancan en 0 al configurarse la FPGA (valor de
//  encendido, "power-up value").
// =====================================================================
`timescale 1ns/1ps
module sincronizador #(
    parameter W = 1                   // numero de senales
) (
    input  wire         clk,
    input  wire [W-1:0] d,            // senales asincronas (pines)
    output wire [W-1:0] q             // senales ya sincronas a clk
);
    reg [W-1:0] meta = {W{1'b0}};
    reg [W-1:0] sinc = {W{1'b0}};

    always @(posedge clk) begin
        meta <= d;                    // 1er FF: puede quedar metaestable
        sinc <= meta;                 // 2o FF: tiene un ciclo para resolverse
    end

    assign q = sinc;
endmodule
