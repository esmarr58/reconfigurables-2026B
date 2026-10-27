# Práctica 3 — Marquesina con tu nombre en HEX5..HEX0 (kit del alumno)

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Práctica **guiada** paso a paso (sin simulación): teoría y planteamiento el martes 27 de octubre de 2026
(Sesión 20); trabajo guiado el jueves 29 de octubre (Sesión 21); demostración en la tarjeta y entrega del PDF el
martes 3 de noviembre de 2026 (Sesión 22) a las 23:59. Sigue la guía `Practica3-Marquesina-Guia-v5` y llena el
documento de evidencia `Practica3-Marquesina-Evidencia-v3.docx` (los dos en Classroom). Teoría: deck de la Clase 18
(*Marquesina en los seis displays: registros de desplazamiento*). Continúa la Práctica 2 (carpeta `../practica2`).

**Tarjeta:** Terasic DE10-Lite · FPGA MAX 10 `10M50DAF484C7G` · reloj `MAX10_CLK1_50` (50 MHz) · displays de
ánodo común (segmento **encendido con 0**).

> Este es un **kit**, no la solución: `char_a_7seg.v`, `registro_marquesina.v` y `marquesina_top.v` son
> esqueletos con bloques `// TODO`. Tal como viene **compila** y la tarjeta muestra `HOLA C` corriendo a la
> izquierda, un carácter por segundo, con un **guion** donde va la `I` de `CUCEI` (esa letra aún no está en la
> tabla). Tu trabajo es completar los cinco TODO, uno por paso de la guía, hasta que la marquesina muestre
> **tu nombre** en ambos sentidos, a cuatro velocidades y con pausa.

## Descarga el kit

1. Botón verde **Code → Download ZIP** de este repositorio (GitHub no descarga carpetas sueltas).
2. Descomprime y copia **solo** la carpeta `practica3` a una ruta **sin espacios ni acentos** cuya
   carpeta final lleve **tu código**: `C:\fpga\p3_tucódigo` (por ejemplo `C:\fpga\p3_219876543`).
   Esa ruta se ve en la barra de título de Quartus: es parte de la evidencia.
3. Verifica que la carpeta tenga los **11 archivos** de la tabla de abajo.

## Entradas y comportamiento

| Entrada | Pin | Función |
|---|---|---|
| `MAX10_CLK1_50` | P11 | reloj de 50 MHz (el único reloj del diseño) |
| `KEY[0]` | B8 | **RESET**, activo en bajo: carga `MSG` en su posición inicial |
| `KEY[1]` | A7 | **PAUSA**: cada pulsación congela o reanuda (antirrebote 20 ms + detector de flanco) |
| `SW[0]` | C10 | **DIRECCIÓN**: 0 = el texto corre a la izquierda, 1 = a la derecha |
| `SW[2:1]` | D12, C11 | **VELOCIDAD**: 00 = 8·N_BASE ciclos por carácter (lenta) … 11 = N_BASE (rápida) |

Salidas: `HEX5..HEX0` = ventana de 6 caracteres (HEX5 a la izquierda); `LEDR[9]` pausa, `LEDR[2:1]` velocidad,
`LEDR[0]` dirección.

**Personalización (antiplagio):** `MSG` = tu nombre en MAYÚSCULAS, sin acentos (Ñ → N), más espacios hasta
tener **exactamente** `LEN` caracteres (deja al menos 3 espacios al final). `DIGITO` = último dígito de tu
código → `N_BASE = 4 000 000 + 250 000·DIGITO` (velocidad lenta: 0.64 + 0.04·DIGITO s por carácter).

## Archivos del kit

| Archivo | Estado | Contenido |
|---|---|---|
| `char_a_7seg.v` | **esqueleto (TODO 1)** | ASCII → 7 segmentos activos en bajo; faltan letras (K, X → H; M → n; V, W → U; Z → 2); `default` = guion |
| `marquesina_top.v` | **esqueleto (TODO 2, 3 y 5)** | Nivel superior: tu `DIGITO`, `LEN` y `MSG`; MUX de 4 velocidades; PAUSA con KEY1 |
| `registro_marquesina.v` | **esqueleto (TODO 4)** | Registro circular de `LEN` caracteres ASCII; rota a la izquierda (dada) y a la derecha (tuya) con `tick` |
| `sincronizador.v` | completo | 2 FF para `SW[2:0]` |
| `antirrebote.v`, `detector_flanco.v` | completos | Los mismos de la P2 (para KEY1) |
| `divisor_tick.v` | completo | Habilitación de 1 ciclo cada `limite + 1` ciclos; compara con `>=`; `en` = ~pausa |
| `p3.qpf`, `p3.qsf`, `p3.sdc` | completos | Proyecto de Quartus con los pines de la DE10-Lite y `create_clock -period 20` |
| `p3-diagrama-bloques.pdf` (y `.tex`) | — | Diagrama a bloques de lo que vas a construir |

Orden de los pasos de la guía y sus TODO: Paso 2 → TODO 1 (glifos) · Paso 3 → TODO 2 (tu nombre) ·
Paso 4 → TODO 5 (pausa) · Paso 5 → TODO 4 (rotación a la derecha) · Paso 6 → TODO 3 (velocidades).
Cada paso dice qué modificar, qué debes ver en la tarjeta y qué foto o tabla va en la evidencia.

**No cambies** el nombre del módulo `marquesina_top` ni sus puertos: el `.qsf` (pines) depende de ellos.
**Prohibido** usar `tick`, un botón o un switch como reloj: todo es `always @(posedge clk ...)` con `if (tick)`.

## Compilar y programar (Quartus Prime Lite)

1. `File > Open Project…` → `p3.qpf` → `Processing > Start Compilation` (0 errores; los avisos de
   *truncated value* en el `case` de `limite` y de pines sin usar son esperados).
2. `Tools > Programmer` → *USB-Blaster* → `output_files/p3.sof` → *Start*.
3. Al final (Paso 7 de la guía): *Compilation Report → Flow Summary* (elementos lógicos, registros, pines) y
   *Timing Analyzer → Slow 1200mV 85C Model → Fmax Summary*, con la ventana completa de Quartus a cuadro.
   Referencia con `LEN = 11`: 341 LE, 146 registros, 71 pines, Fmax ≈ 128 MHz.
