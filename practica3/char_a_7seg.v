// =====================================================================
//  char_a_7seg.v  --  Caracter ASCII (8 bits) -> 7 segmentos (DE10-Lite)
//  Sistemas Reconfigurables (V3737) - 2026B - Practica 3 (marquesina)
//  *** ESQUELETO DEL KIT: completa el TODO 1 ***
//
//  Es el decodificador de letras de la Practica 1, ahora con el CODIGO
//  ASCII del caracter como entrada ("R" = 8'h52). La tabla de glifos es la
//  del deck de la Clase 18 y es la especificacion de este modulo.
//
//  Los 6 displays de la DE10-Lite son de ANODO COMUN: un segmento ENCIENDE
//  con 0 (activo en bajo). Orden de bits: {g,f,e,d,c,b,a}; el punto decimal
//  (DP) es HEX?[7] y se maneja en el top.
//           a
//         f   b
//           g
//         e   c
//           d
//
//  Letras que se ven en MAYUSCULA: A C E F G H I J L O P S U
//  Letras que se escriben en MINUSCULA: b d n q r t y
//  Letras SIN forma propia y SUSTITUCION convenida (documentala si tu
//  nombre las usa):  K, X -> H    M -> n    V, W -> U    Z -> 2
//  La enie no existe en ASCII de 7 bits: en el mensaje se escribe N.
//  El mensaje va en MAYUSCULAS y sin acentos: cualquier otro caracter
//  (minuscula, acento, digito, relleno 8'h00) cae en el default y se ve
//  como un GUION, que delata el error.
// =====================================================================
`timescale 1ns/1ps
module char_a_7seg (
    input  wire [7:0] c,              // codigo ASCII
    output reg  [6:0] seg             // {g,f,e,d,c,b,a}, ACTIVO EN BAJO
);
    // TODO 1: completa los renglones comentados con el patron de cada letra
    //         (ACTIVO EN BAJO, orden g f e d c b a) usando la tabla de glifos
    //         de la guia y quita el comentario. Mientras falte una letra, se
    //         vera como GUION (el default): asi sabes que te falta.
    always @(*) begin
        case (c)                      //      gfedcba   (0 = encendido)
            "A":         seg = 7'b0001000;
         // "B":         seg = 7'b_______;   // b   <- TODO 1
            "C":         seg = 7'b1000110;
         // "D":         seg = 7'b_______;   // d   <- TODO 1
            "E":         seg = 7'b0000110;
         // "F":         seg = 7'b_______;   <- TODO 1
         // "G":         seg = 7'b_______;   <- TODO 1
            "H","K","X": seg = 7'b0001001;   // K, X -> H
         // "I":         seg = 7'b_______;   // e y f (no se confunde con el 1)   <- TODO 1
         // "J":         seg = 7'b_______;   <- TODO 1
            "L":         seg = 7'b1000111;
         // "M","N":     seg = 7'b_______;   // n (M -> n)   <- TODO 1
            "O":         seg = 7'b1000000;
            "P":         seg = 7'b0001100;
         // "Q":         seg = 7'b_______;   // q   <- TODO 1
         // "R":         seg = 7'b_______;   // r   <- TODO 1
         // "S":         seg = 7'b_______;   <- TODO 1
         // "T":         seg = 7'b_______;   // t   <- TODO 1
            "U","V","W": seg = 7'b1000001;   // V, W -> U
         // "Y":         seg = 7'b_______;   // y   <- TODO 1
         // "Z":         seg = 7'b_______;   // como 2   <- TODO 1
            " ":         seg = 7'b1111111;   // apagado
            default:     seg = 7'b0111111;   // guion: caracter no soportado
        endcase
    end
endmodule
