# Práctica 3 — Reloj 000–999 con PAUSA, RESET, INCREMENTO y DECREMENTO (kit del alumno)

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Práctica **semiguiada**, jueves 15 de octubre de 2026 (Semana 9): demostración en la tarjeta en clase
y entrega del PDF ese mismo día a las 23:59. Sigue la guía de la Práctica 3 (PDF en Classroom).
Continúa el TC06 (carpeta `../tc6`).

**Tarjeta:** Terasic DE10-Lite · FPGA (*Field-Programmable Gate Array*) MAX 10 `10M50DAF484C7G` ·
reloj `MAX10_CLK1_50` (50 MHz).

> Este es un **kit**, no la solución: `p3_top.v` y `contador_bcd_ud.v` son esqueletos con bloques
> `// TODO`. Tal como vienen **compilan** y la tarjeta muestra `000` fijo (y `LEDR1` parpadea cada
> segundo). Tu trabajo es completar los TODO hasta que la tarjeta cumpla todas las reglas.

## Entradas y reglas

| Entrada | Pin | Función | Tipo |
|---|---|---|---|
| `KEY[0]` | PIN_B8 | **INCREMENTO**: +1 por pulsación | botón, activo en bajo |
| `KEY[1]` | PIN_A7 | **DECREMENTO**: −1 por pulsación | botón, activo en bajo |
| `SW[0]` | PIN_C10 | **PAUSA**: 1 = pausado, 0 = corre | switch |
| `SW[9]` | PIN_F15 | **RESET**: 1 = 000 y se queda ahí | switch |

1. **RESET = 1**: la cuenta vale 000, el segundo en curso se reinicia y se ignoran tick, INC y DEC.
2. **INC / DEC** funcionan siempre (corriendo o en pausa): exactamente ±1 por pulsación; mantener el
   botón **no** repite. INC y DEC en el mismo ciclo se cancelan.
3. **Tick de 1 Hz** solo si PAUSA = 0. En pausa el divisor se congela (al reanudar se completa el segundo).
4. Da la vuelta en ambos sentidos: 999 + 1 = 000 y 000 − 1 = 999.

Las 4 entradas pasan por **sincronizador de 2 FF (flip-flops) + antirrebote de 20 ms**; INC y DEC además por
un **detector de flanco**. Salidas: `HEX2:HEX1:HEX0` = centenas, decenas, unidades (HEX3–HEX5 apagados);
`LEDR0` pausa, `LEDR1` latido, `LEDR2`/`LEDR3` INC/DEC oprimido, `LEDR9` reset.

## Archivos del kit

| Archivo | Estado | Contenido |
|---|---|---|
| `p3_top.v` | **esqueleto (TODO 4–8)** | Nivel superior: POR, un antirrebote y un detector de ejemplo, displays y LEDs ya dados |
| `contador_bcd_ud.v` | **esqueleto (TODO 1–3)** | Dígito BCD up/down con `clr`, acarreo `co` y préstamo `bo` |
| `antirrebote.v` | completo | Sincronizador 2 FF + filtro antirrebote parametrizable (`N`) |
| `detector_flanco.v` | completo | Pulso de un ciclo en el flanco 0→1 |
| `tick_gen.v`, `dec7seg.v` | completos | Los mismos del TC06 |
| `p3.qpf`, `p3.qsf`, `p3.sdc` | completos | Proyecto de Quartus con los pines de la DE10-Lite y el reloj de 50 MHz |
| `p3-diagrama-bloques.pdf` | — | Diagrama a bloques de la solución que debes construir |

**No cambies** el nombre del módulo `p3_top`, sus parámetros (`TICK_N`, `DEB_N`) ni sus puertos: el
`.qsf` depende de ellos.

## Compilar y programar (Quartus Prime Lite)

1. Descarga la carpeta completa a una ruta sin espacios ni acentos (por ejemplo `C:\fpga\practica3`).
2. `File > Open Project…` → `p3.qpf` → `Processing > Start Compilation`.
3. `Tools > Programmer` → *USB-Blaster* → `output_files/p3.sof` → *Start*.
4. Revisa el reporte (*Flow Summary*: elementos lógicos y registros; *Timing Analyzer*: Fmax) y el
   *RTL Viewer* (`Tools > Netlist Viewers`).

Truco para probar las vueltas sin esperar: compila temporalmente con `TICK_N = 5_000_000` (0.1 s por
cuenta) y regresa a 50 000 000 para la demostración.
Avisos esperados de Quartus: `SW[1]`–`SW[8]` sin usar y salidas fijas.
