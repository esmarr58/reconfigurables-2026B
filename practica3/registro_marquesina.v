// =====================================================================
//  registro_marquesina.v  --  Registro de desplazamiento CIRCULAR de caracteres
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3 (marquesina)
//  *** ESQUELETO DEL KIT: completa el TODO 4 ***
//
//  Guarda el mensaje completo como LEN caracteres ASCII de 8 bits y lo
//  ROTA un caracter (8 bits) en cada pulso de 'tick':
//
//      r = { c0, c1, c2, ... , c(LEN-1) }        c0 en r[8*LEN-1 -: 8]
//
//      dir = 0 (izquierda):  { c1, c2, ... , c(LEN-1), c0 }   (c0 da la vuelta)
//      dir = 1 (derecha)  :  { c(LEN-1), c0, c1, ... , c(LEN-2) }
//
//  Es un registro de desplazamiento de 8*LEN bits cuya salida serie se
//  realimenta a su entrada serie: nunca se pierde un caracter y tras LEN
//  ticks el mensaje vuelve a su posicion inicial.
//
//  Por que 8 bits por caracter (codigo ASCII) y no 7 (los segmentos):
//    * el mensaje se escribe como TEXTO: MSG = "RUBEN      ";
//    * el decodificador char_a_7seg es el de la P1 y queda en un solo lugar;
//    * cuesta poco mas: 8*LEN FF en lugar de 7*LEN (88 contra 77 con LEN = 11,
//      menos del 0.2 % del 10M50). En MAYUSCULAS y espacio el bit 7 vale
//      siempre 0, pero Quartus Prime Lite 25.1 conserva esos 11 FF: no
//      demuestra que un anillo de FF que arranca en 0 se queda en 0.
//
//  El reset CARGA el mensaje (MSG es el valor inicial del registro).
//  Si el texto es mas corto que LEN, Verilog rellena con 8'h00 a la
//  IZQUIERDA y esos caracteres se ven como guion: cuenta bien los espacios.
// =====================================================================
`timescale 1ns/1ps
module registro_marquesina #(
    parameter LEN = 11,                           // caracteres (>= 6)
    parameter [8*LEN-1:0] MSG = "RUBEN      "
) (
    input  wire            clk,
    input  wire            rst_n,                 // KEY0, activo en bajo
    input  wire            tick,                  // habilitacion: 1 ciclo = 1 caracter
    input  wire            dir,                   // 0 = izquierda, 1 = derecha
    output reg [8*LEN-1:0] r                      // r[8*LEN-1 -: 8] = 1er caracter
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            r <= MSG;                                     // carga el nombre
        else if (tick) begin
            if (!dir) r <= {r[8*LEN-9:0], r[8*LEN-1 -: 8]};  // izquierda
            else      r <= r;   // TODO 4: rota 8 bits a la DERECHA (el ultimo caracter
                                //         entra por arriba): espejo de la linea anterior
        end
        // sin 'else' final: si tick = 0, r se conserva (registro, no latch)
    end
endmodule
