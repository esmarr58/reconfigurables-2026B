// =====================================================================
//  tb_marquesina.v  --  Testbench AUTOVERIFICABLE de la Practica 3
//  Sistemas Reconfigurables (V3737) - 2026B
//  *** ESQUELETO DEL KIT: completa los TODO 0, A (prueba T3) y B (prueba T4) ***
//
//  Parametros reducidos para simular en microsegundos lo que en la tarjeta
//  tarda segundos:  N_BASE = 2  (tick cada 2, 4, 8 o 16 ciclos)
//                   DEB_N  = 4  (antirrebote de 4 ciclos)
//  LEN y MSG deben ser LOS MISMOS de tu marquesina_top (tu nombre).
//
//  MODELO DE REFERENCIA: el testbench no copia el registro del DUT; lleva su
//  propia cuenta 'desp' (caracteres rotados a la izquierda, modulo LEN) y
//  calcula con MSG el registro que DEBE haber. En cada flanco en que el DUT
//  ve tick = 1, el modelo rota a la izquierda o a la derecha segun dut.dir.
//
//  Pruebas:  T1 reset: r = MSG, DP apagados, espacios apagados
//            T2 izquierda: 1 caracter por tick y vuelta completa (LEN ticks)
//            T3 derecha: SW0 = 1 en marcha; LEN + 3 ticks
//            T4 pausa con KEY1 (con rebotes): no hay ticks ni cambios; reanuda
//            T5 velocidad: periodo del tick = 8, 4, 2 y 1 veces N_BASE
//            T6 reset con KEY0 a media rotacion
//            En todas: ningun display muestra guion (caracter no soportado).
//  Imprime la ventana como TEXTO tras cada tick y al final PASS o FAIL.
//
//  Questa/ModelSim:  do sim_marquesina.do
// =====================================================================
`timescale 1ns/1ps
module tb_marquesina;
    // TODO 0: copia aqui el MISMO LEN y el MISMO MSG de tu marquesina_top
    localparam LEN    = 11;                       // = LEN de tu marquesina_top
    localparam [8*LEN-1:0] MSG = "HOLA CUCEI ";   // = MSG de tu marquesina_top
    localparam N_BASE = 2;
    localparam DEB_N  = 4;

    reg        clk = 1'b0;
    reg  [1:0] KEY = 2'b10;           // KEY0 oprimido (reset) al arrancar
    reg  [9:0] SW  = 10'b0;           // SW0 = 0 izquierda, SW[2:1] = 00 lenta
    wire [9:0] LEDR;
    wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    marquesina_top #(.N_BASE(N_BASE), .DEB_N(DEB_N), .LEN(LEN), .MSG(MSG)) dut (
        .MAX10_CLK1_50(clk), .KEY(KEY), .SW(SW), .LEDR(LEDR),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5)
    );

    always #10 clk = ~clk;            // 50 MHz

    integer errores = 0;
    integer desp    = 0;              // modelo: caracteres rotados a la izquierda
    integer i, n, ticks;

    // ---------- registro que DEBE haber tras rotar d caracteres a la izquierda ----------
    function [8*LEN-1:0] esperado(input integer d);
        integer k;
        begin
            for (k = 0; k < LEN; k = k + 1)        // caracter k de la pantalla = MSG[(k+d) mod LEN]
                esperado[8*(LEN-1-k) +: 8] = MSG[8*(LEN-1-((k + d) % LEN)) +: 8];
        end
    endfunction

    // ---------- MODELO: rota cuando el DUT ve tick = 1 (valores previos al flanco) ----------
    always @(posedge clk)
        if (!dut.rst_n)    desp <= 0;
        else if (dut.tick) desp <= dut.dir ? (desp + LEN - 1) % LEN : (desp + 1) % LEN;

    reg [8*LEN-1:0] tmp_r;
    task revisa(input [8*20-1:0] prueba);
        begin
            tmp_r = esperado(desp);
            if (dut.r !== tmp_r) begin
                errores = errores + 1;
                $display("  ERROR [%0s] t=%0t: r = \"%s\", esperado \"%s\"", prueba, $time, dut.r, tmp_r);
            end
            if (dut.ventana !== tmp_r[8*LEN-1 -: 48]) begin
                errores = errores + 1;
                $display("  ERROR [%0s]: ventana = \"%s\", deben ser los 6 primeros caracteres de r", prueba, dut.ventana);
            end
            if ({HEX5[7],HEX4[7],HEX3[7],HEX2[7],HEX1[7],HEX0[7]} !== 6'b111111) begin
                errores = errores + 1; $display("  ERROR [%0s]: punto decimal encendido", prueba);
            end
            if (HEX5[6:0] == 7'b0111111 || HEX4[6:0] == 7'b0111111 || HEX3[6:0] == 7'b0111111 ||
                HEX2[6:0] == 7'b0111111 || HEX1[6:0] == 7'b0111111 || HEX0[6:0] == 7'b0111111) begin
                errores = errores + 1;
                $display("  ERROR [%0s]: un display muestra GUION: caracter no soportado en MSG (minuscula, acento, 8'h00 por LEN mal contado?)", prueba);
            end
        end
    endtask

    task ciclos(input integer k); begin repeat (k) @(posedge clk); #1; end endtask

    // espera el siguiente tick y el flanco en que el registro ya roto
    task espera_tick;
        begin
            @(posedge clk); #1;
            while (dut.tick !== 1'b1) begin @(posedge clk); #1; end
            @(posedge clk); #1;
        end
    endtask

    // pulsar KEY1 con rebotes
    task pulsa_k1;
        begin
            KEY[1] = 1'b0; ciclos(1); KEY[1] = 1'b1; ciclos(1);
            KEY[1] = 1'b0; ciclos(3*DEB_N);
            KEY[1] = 1'b1; ciclos(1); KEY[1] = 1'b0; ciclos(1);
            KEY[1] = 1'b1; ciclos(3*DEB_N);
        end
    endtask

    // monitor: cuenta ticks en una ventana de tiempo
    reg contar = 1'b0;
    always @(posedge clk) if (contar && dut.tick) ticks = ticks + 1;

    initial begin
        $timeformat(-9, 0, " ns", 0);
        $display("=== Practica 3: marquesina \"%s\" (LEN=%0d, N_BASE=%0d, DEB_N=%0d) ===",
                 MSG, LEN, N_BASE, DEB_N);

        // ---------------- T1: reset con KEY0 ----------------
        ciclos(3);
        KEY[0] = 1'b1; ciclos(4);                 // suelta el reset
        revisa("T1 reset");
        if (HEX5 === 8'hFF) begin errores = errores + 1; $display("  ERROR [T1]: HEX5 apagado tras el reset"); end
        $display("%t reset [%s]", $time, dut.ventana);

        // ---------------- T2: izquierda, vuelta completa ----------------
        for (i = 0; i < LEN; i = i + 1) begin
            espera_tick; revisa("T2 izquierda");
            $display("%t izq   [%s]", $time, dut.ventana);
        end
        if (dut.r !== MSG) begin
            errores = errores + 1; $display("  ERROR [T2]: tras LEN ticks el mensaje no volvio al inicio");
        end
        espera_tick; espera_tick; espera_tick;
        revisa("T2 tres ticks mas");

        // ---------------- T3: derecha (SW0 = 1) en marcha ----------------
        // TODO A: 1) SW[0] = 1'b1; ciclos(3);   (2 FF del sincronizador)
        //         2) un for de LEN + 3 vueltas: espera_tick; revisa("T3 derecha");
        //            y $display de la ventana con "der   [%s]" (copia el de T2);
        //         3) si LEDR[0] !== 1, suma un error y explicalo con $display;
        //         4) SW[0] = 1'b0; ciclos(3);

        // ---------------- T4: pausa con KEY1 ----------------
        // TODO B: 1) pulsa_k1; y exige LEDR[9] = 1 (si no, error);
        //         2) ticks = 0; contar = 1'b1; ciclos(3*8*N_BASE); contar = 1'b0;
        //            y exige ticks == 0 (en pausa no hay ticks);
        //         3) revisa("T4 pausa congela");
        //         4) pulsa_k1; exige LEDR[9] = 0; espera_tick; revisa("T4 reanuda");

        // ---------------- T5: periodo del tick en los 4 niveles ----------------
        for (i = 0; i < 4; i = i + 1) begin
            SW[2:1] = i; ciclos(3);
            espera_tick;                          // primer tick tras el cambio: se descarta
            n = 1;                                // ya paso 1 ciclo desde ese tick
            while (dut.tick !== 1'b1) begin @(posedge clk); #1; n = n + 1; end
            if (n !== (8 >> i) * N_BASE) begin
                errores = errores + 1;
                $display("  ERROR [T5]: SW[2:1] = %0d, periodo = %0d ciclos, esperado %0d", i, n, (8 >> i) * N_BASE);
            end
            ciclos(1); revisa("T5 velocidad");
        end
        SW[2:1] = 2'b00; ciclos(3);

        // ---------------- T6: reset con KEY0 a media rotacion ----------------
        espera_tick; espera_tick;
        KEY[0] = 1'b0; ciclos(3);
        revisa("T6 reset KEY0");
        if (dut.r !== MSG) begin errores = errores + 1; $display("  ERROR [T6]: KEY0 no recargo el mensaje"); end
        KEY[0] = 1'b1; ciclos(2);
        espera_tick; revisa("T6 corre de nuevo");

        if (errores == 0) $display("PASS: marquesina_top cumple las 6 pruebas (rotacion izq/der, vuelta completa, pausa, 4 velocidades, reset)");
        else              $display("FAIL: %0d errores", errores);
        $finish;
    end

    initial begin
        #1_000_000;
        $display("FAIL: tiempo agotado");
        $finish;
    end
endmodule
