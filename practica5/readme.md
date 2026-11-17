# Práctica 5 — ALU registrada de 4 bits en la DE10-Lite con displays de 7 segmentos (kit del alumno)

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Se explica el martes 17 de noviembre de 2026 (Sesión 26). La evidencia se recaba en la tarjeta y **se entrega el
jueves 19 de noviembre de 2026, en la Sesión 27** (Classroom, UN solo PDF). Sigue y llena la guía
`Practica5-ALU-Registrada-7seg-Guia-v1` (en Classroom): **15 minutos antes del jueves, sin tarjeta** (Paso 1) y
**30 minutos en la sesión, con tarjeta**. Lleva a la tarjeta la **P03**, uno de los 15 programas del TC07
(carpeta `../tc07/p03_alu_registrada`).

**Adelanta el Paso 1 antes del jueves** (en tu casa o al salir de la clase del martes): descargar el kit, completar
los cuatro TODO, compilar y tomar la captura **no necesita la tarjeta**. El jueves solo programas y tomas tus fotos.

**Tarjeta:** Terasic DE10-Lite · FPGA MAX 10 `10M50DAF484C7G` · reloj `MAX10_CLK1_50` (50 MHz) · displays
**activos en bajo** (segmento encendido con 0) · botones **activos en bajo** (oprimido = 0).

> Este es un **kit**, no la solución: `p5_top.v` trae cuatro bloques `// TODO`. Tal como viene **compila**, pero
> la tarjeta se ve mal a propósito: `HEX0` muestra un guion, `HEX3`–`HEX1` muestran `8.`, `HEX5` y `HEX4` están
> apagados y el resultado no sale de 0. Tu trabajo es completar los cuatro TODO (10 líneas, vienen en la guía)
> hasta ver A, B y el resultado en los displays. Los cinco archivos de la P03 **no se modifican**.

## Descarga el kit

1. Botón verde **Code → Download ZIP** de este repositorio (GitHub no descarga carpetas sueltas).
2. Descomprime y copia **solo** la carpeta `practica5` a una ruta **sin espacios ni acentos** cuya
   carpeta final lleve **tu código**: `C:\fpga\p5_tucódigo` (por ejemplo `C:\fpga\p5_219876543`).
   Esa ruta se ve en la barra de título de Quartus: es parte de la evidencia E1.
3. Verifica que la carpeta tenga los **9 archivos** de la tabla de abajo (más este `readme.md` y el diagrama).

## Entradas y comportamiento

Tú eres la unidad de control: los switches son la instrucción (operación y operandos) y `KEY0` es la orden de guardar.

| Entrada | Pin | Función |
|---|---|---|
| `MAX10_CLK1_50` | P11 | reloj de 50 MHz (el único reloj del diseño) |
| `KEY[1]` | A7 | **RESET**, activo en bajo (reset síncrono): el registro vuelve a 0 |
| `KEY[0]` | B8 | **CARGAR**, activo en bajo: mientras está oprimido, el registro copia el resultado de la ALU |
| `SW[9:8]` | F15, B14 | **operación**: 00 suma (A + B) · 01 resta (A − B) · 10 AND · 11 OR |
| `SW[7:4]` | A14, A13, B12, A12 | operando **A** (se ve en `HEX5`) |
| `SW[3:0]` | C12, D12, C11, C10 | operando **B** (se ve en `HEX4`) |

Salidas: `HEX0` = resultado **guardado** en hexadecimal (0–9, A, b, C, d, E, F); `LEDR[3:0]` = el mismo resultado en
binario; `LEDR[9]` = `cero` (enciende cuando el resultado guardado es 0); `HEX5` = A; `HEX4` = B; `HEX3`–`HEX1`
apagados. De izquierda a derecha, en la tarjeta: switches `op`, A, B; displays A, B … resultado.

## Archivos del kit

| Archivo | Estado | Contenido |
|---|---|---|
| `p5_top.v` | **esqueleto (TODO 1 a 4)** | Envoltura de tarjeta: instancia `top` (la P03) y la conecta a botones, switches, LEDs y displays |
| `top.v` | completo, **no se modifica** | La P03: une `alu4`, `registro4`, `detector_cero4` y `deco_7seg` |
| `alu4.v` | completo, no se modifica | ALU combinacional de 4 bits (suma, resta, AND, OR); sin acarreo de salida |
| `registro4.v` | completo, no se modifica | Registro de 4 bits con reset síncrono y habilitación `en` |
| `detector_cero4.v` | completo, no se modifica | `cero` = 1 cuando el dato guardado es 0000 |
| `deco_7seg.v` | completo, no se modifica | Hexadecimal a 7 segmentos, **activo en alto**, `seg = {g,f,e,d,c,b,a}` |
| `p5.qpf`, `p5.qsf`, `p5.sdc` | completos | Proyecto de Quartus con los pines de la DE10-Lite y `create_clock -period 20` |
| `p5-diagrama-bloques.pdf` | — | Diagrama a bloques de `p5_top` ya resuelto (lo que vas a construir) |

Los cuatro TODO de `p5_top.v` (todos en el Paso 1 de la guía):

| TODO | Qué completas | Si falta, en la tarjeta ves |
|---|---|---|
| 1 | negar los botones: `rst = ~KEY[1]`, `cargar = ~KEY[0]` | el resultado nunca sale de 0 y `LEDR9` no se apaga |
| 2 | negar `seg_r` para `HEX0` (display activo en bajo) | un guion (o segmentos invertidos) en `HEX0` |
| 3 | instanciar `deco_7seg` dos veces más: A (`SW[7:4]`) en `HEX5`, B (`SW[3:0]`) en `HEX4` | `HEX5` y `HEX4` apagados |
| 4 | apagar `HEX1`, `HEX2` y `HEX3` con `8'hFF` | tres `8.` encendidos |

**Sustituye** las líneas marcadas `// TODO n`; no las dupliques (cada `assign` debe quedar una sola vez): si Quartus
dice que una señal tiene más de un valor, dejaste la línea vieja junto a la nueva.
**No cambies** el nombre del módulo `p5_top` ni sus puertos: el `.qsf` (pines) depende de ellos.
En esta práctica **no se usa simulador**: todo se comprueba en la tarjeta.

## Compilar y programar (Quartus Prime Lite)

1. `File > Open Project…` → `p5.qpf` → `Processing > Start Compilation` (no necesita la tarjeta; 0 errores; los avisos de pines fijos a
   VCC o GND y de pines sin usar son esperados).
2. `Tools > Programmer` → *USB-Blaster* → `output_files/p5.sof` → *Start*.
3. Evidencia E1: *Compilation Report → Flow Summary* (*Flow Status: Successful*) con la ventana completa de Quartus
   a cuadro y tu carpeta `p5_tucódigo` en la barra de título.

## Reto opcional (+10)

Muestra el resultado guardado en **decimal** de dos dígitos (00 a 15) en `HEX1 HEX0`: escribe un módulo `bin_a_bcd`
(entrada de 4 bits; salidas `decenas` y `unidades`) y un decodificador BCD a 7 segmentos, y conéctalos en `p5_top.v`.
