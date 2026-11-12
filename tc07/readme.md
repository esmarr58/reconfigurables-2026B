# TC07 — Del código al diagrama a bloques (kit del alumno)

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Trabajo en clase 7: Semana 13, Sesión 25, jueves 12 de noviembre de 2026. Entrega del PDF el mismo día al
terminar la clase (Classroom, a más tardar 23:59). Sigue la guía `TC07-Codigo-a-Diagrama-Guia` (Word/PDF en
Classroom).

> Este es un **kit**, no la solución: cada carpeta trae solo el código (`top.v` y un `.v` por cada módulo
> instanciado). Los diagramas a bloques los **dibujas tú**, a mano o colocando tú cada bloque en una
> herramienta de dibujo. No se vale generarlos automáticamente (importar el Verilog en un sitio de diagramas o
> copiar el RTL Viewer de Quartus).

## Qué haces

El profesor te asigna **dos** programas distintos de la tabla. Para cada uno lees `top.v` y dibujas su diagrama
a bloques con:

- el marco `module top` con sus **entradas** (izquierda) y **salidas** (derecha), con nombre y ancho (`a[3:0]`);
- **cada instancia** como un bloque titulado `nombre_instancia · módulo` (por ejemplo `u_div · divisor_frec`),
  con sus parámetros `#(N=…)` si los tiene;
- los **puertos** de cada bloque con el nombre del módulo (entradas a la izquierda, salidas a la derecha);
- **cada wire interno** como cable rotulado con su nombre y, si es bus, su ancho;
- constantes (`1'b0`) junto al pin, rebanadas (`a[0]`) en el cable, concatenaciones (`{c_out, suma}`) y
  realimentaciones dibujadas completas.

La carpeta `ejemplo/` trae un ejemplo resuelto (contador de pulsaciones) con su diagrama en PDF; no forma parte
de la lista de programas.

## Descarga el kit

1. Botón verde **Code → Download ZIP** de este repositorio (GitHub no descarga carpetas sueltas).
2. Descomprime y copia **solo** la carpeta `tc07` a una ruta sin espacios ni acentos (por ejemplo `C:\fpga\tc07`).
3. Abre los `.v` con cualquier editor de texto (Bloc de notas, VS Code o el editor de Quartus).

## Programas

| Código | Carpeta | Tema | Instancias | Archivos |
|---|---|---|---|---|
| P01 | [`p01_sumador_ripple`](p01_sumador_ripple) | Sumador de 4 bits con acarreo en cascada | 4 | `top.v`, `sumador_completo.v` |
| P02 | [`p02_sumador_restador`](p02_sumador_restador) | Sumador/restador de 4 bits con display | 4 | `top.v`, `inversor_cond4.v`, `sumador4.v`, `detector_cero4.v`, `deco_7seg.v` |
| P03 | [`p03_alu_registrada`](p03_alu_registrada) | ALU de 4 bits con registro de resultado | 4 | `top.v`, `alu4.v`, `registro4.v`, `detector_cero4.v`, `deco_7seg.v` |
| P04 | [`p04_contador_con_pausa`](p04_contador_con_pausa) | Contador decimal de 1 Hz con pausa | 6 | `top.v`, `divisor_frec.v`, `detector_subida.v`, `ff_t.v`, `compuerta_and.v`, `contador_mod10.v`, `deco_7seg.v` |
| P05 | [`p05_cronometro_2_digitos`](p05_cronometro_2_digitos) | Cronómetro de dos dígitos (00–99) | 6 | `top.v`, `divisor_frec.v`, `compuerta_and.v`, `contador_mod10.v`, `deco_7seg.v` |
| P06 | [`p06_maximo_y_minimo`](p06_maximo_y_minimo) | Máximo y mínimo de dos números | 5 | `top.v`, `comparador4.v`, `mux2_4.v`, `deco_7seg.v` |
| P07 | [`p07_registro_serie`](p07_registro_serie) | Registro de desplazamiento con paridad | 4 | `top.v`, `sincroniza_2ff.v`, `detector_subida.v`, `reg_desplazamiento4.v`, `paridad4.v` |
| P08 | [`p08_semaforo`](p08_semaforo) | Semáforo con temporizador | 5 | `top.v`, `divisor_frec.v`, `fsm_semaforo.v`, `compuerta_or.v`, `contador4.v`, `deco_7seg.v` |
| P09 | [`p09_pwm_ajustable`](p09_pwm_ajustable) | PWM con ciclo de trabajo ajustable | 5 | `top.v`, `divisor_frec.v`, `detector_subida.v`, `contador4.v`, `pwm4.v`, `deco_7seg.v` |
| P10 | [`p10_display_multiplexado`](p10_display_multiplexado) | Barrido de cuatro displays | 5 | `top.v`, `divisor_frec.v`, `contador2.v`, `mux4_4.v`, `deco2a4.v`, `deco_7seg.v` |
| P11 | [`p11_selector_por_prioridad`](p11_selector_por_prioridad) | Selector de datos por prioridad | 4 | `top.v`, `codificador_prio.v`, `mux4_4.v`, `registro4.v`, `deco_7seg.v` |
| P12 | [`p12_dado_electronico`](p12_dado_electronico) | Número aleatorio con botón | 5 | `top.v`, `sincroniza_2ff.v`, `detector_subida.v`, `lfsr4.v`, `registro4.v`, `deco_7seg.v` |
| P13 | [`p13_acumulador`](p13_acumulador) | Acumulador de 4 bits | 5 | `top.v`, `detector_subida.v`, `sumador4.v`, `registro4.v`, `ff_d_en.v`, `deco_7seg.v` |
| P14 | [`p14_suma_en_decimal`](p14_suma_en_decimal) | Suma mostrada en decimal | 4 | `top.v`, `sumador4.v`, `bin_a_bcd.v`, `deco_7seg.v` |
| P15 | [`p15_cerradura`](p15_cerradura) | Cerradura con clave de 4 bits | 6 | `top.v`, `detector_subida.v`, `registro4.v`, `comparador_igual4.v`, `ff_d_en.v`, `compuerta_not.v` |

Todos están en Verilog-2001; el módulo superior se llama siempre `top`.

## Si quieres compilarlo (opcional)

No hace falta programar la tarjeta. Si quieres comprobar que el código es válido o comparar tu dibujo **después**
de terminarlo:

1. Quartus Prime Lite: `File > New Project Wizard`, carpeta del programa, top-level entity `top`, dispositivo
   `10M50DAF484C7G` (DE10-Lite); agrega todos los `.v` de la carpeta.
2. `Processing > Start > Start Analysis & Elaboration`.
3. `Tools > Netlist Viewers > RTL Viewer` para ver cómo lo interpretó Quartus.

Con Icarus Verilog (desde la carpeta del programa): `iverilog -g2001 -Wall -s top -o top.out *.v`.
Los 15 programas compilan sin avisos con Icarus Verilog 12.
