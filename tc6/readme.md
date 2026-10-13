# TC06 — Contador 00–99 en dos displays de 7 segmentos

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Trabajo en clase 6 (auto-guiado), jueves 15 de octubre de 2026. Sigue la guía del TC06 (PDF en Classroom).

**Tarjeta:** Terasic DE10-Lite · FPGA (*Field-Programmable Gate Array*) MAX 10 `10M50DAF484C7G` ·
reloj `MAX10_CLK1_50` (50 MHz).

## Qué hace

Un divisor de frecuencia genera un *tick* de 1 Hz (50 000 000 ciclos; compara contra 49 999 999).
Cada tick avanza el dígito de **unidades** (BCD, *Binary-Coded Decimal*); cuando pasa de 9 a 0, su
acarreo `co` avanza las **decenas**. Cada dígito pasa por un decodificador a 7 segmentos y se muestra
en `HEX1:HEX0` (displays de ánodo común: 0 = segmento encendido). `KEY[0]` es el reset (activo en bajo,
igual que en el TC05). Diagrama a bloques: `tc06-diagrama-bloques.pdf`.

| Archivo | Contenido |
|---|---|
| `tc06_top.v` | Módulo de nivel superior: conecta todo y maneja HEX0–HEX5 y LEDR |
| `tick_gen.v` | Divisor de frecuencia / *tick* parametrizable (`N`), con `en` y `clr` (los usa la Práctica 2) |
| `contador_bcd.v` | Un dígito BCD 0–9 con habilitación `en` y acarreo `co` |
| `dec7seg.v` | Decodificador BCD → 7 segmentos, activo en bajo, orden `{g,f,e,d,c,b,a}` |
| `tc06.qpf`, `tc06.qsf`, `tc06.sdc` | Proyecto de Quartus con los pines de la DE10-Lite y el reloj de 50 MHz |
| `tc06-diagrama-bloques.tex/.pdf` | Diagrama a bloques (TikZ) |

## Pines (DE10-Lite User Manual, Terasic)

| Señal | Pin | Uso |
|---|---|---|
| `MAX10_CLK1_50` | PIN_P11 | reloj de 50 MHz |
| `KEY[0]` | PIN_B8 | reset (activo en bajo) |
| `HEX0[7:0]` | C14 E15 C15 C16 E16 D17 C17 D15 | unidades (`[0]`=a … `[6]`=g, `[7]`=DP) |
| `HEX1[7:0]` | C18 D18 E18 B16 A17 A18 B17 A16 | decenas |
| `LEDR[3:0]` / `LEDR[7:4]` | A8 A9 A10 B10 / D13 C13 E14 D14 | unidades / decenas en binario |
| `LEDR[9]` | B11 | cambia de estado en cada tick |

## Compilar y programar (Quartus Prime Lite)

1. Descarga la carpeta completa a una ruta sin espacios ni acentos (por ejemplo `C:\fpga\tc6`).
2. `File > Open Project…` → `tc06.qpf`. Los pines ya vienen en `tc06.qsf` (revísalos en *Pin Planner*).
3. `Processing > Start Compilation`.
4. `Tools > Programmer` → *USB-Blaster* → `output_files/tc06.sof` → *Start*.
5. Verifica en la tarjeta: `HEX1:HEX0` cuentan 00…99 una vez por segundo y `KEY[0]` regresa a 00.

Compilado con Quartus Prime Lite 25.1std sin errores (73 elementos lógicos, 36 registros, Fmax ≈ 223 MHz).
Avisos esperados: `KEY[1]` sin usar y salidas fijas (HEX2–HEX5 apagados, `LEDR[8]`).
