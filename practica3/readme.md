# Práctica 3 — Marquesina con tu nombre en HEX5..HEX0 (kit del alumno)

Sistemas Reconfigurables (V3737) · Ciclo 2026B · Dr. Rubén Estrada Marmolejo · CUCEI–UDG
Práctica **guiada** con **simulación obligatoria en ModelSim/Questa**: trabajo guiado el jueves 22 de
octubre de 2026 (Sesión 19); demostración en la tarjeta y entrega del PDF el martes 27 de octubre de 2026
(Sesión 20) a las 23:59. Sigue la guía `Practica3-Marquesina-Guia` y llena el documento de evidencia
`Practica3-Marquesina-Evidencia.docx` (los dos en Classroom). Teoría: deck de la Clase 18
(*Marquesina en los seis displays: registros de desplazamiento*). Continúa la Práctica 2 (carpeta `../practica2`).

**Tarjeta:** Terasic DE10-Lite · FPGA MAX 10 `10M50DAF484C7G` · reloj `MAX10_CLK1_50` (50 MHz) · displays de
ánodo común (segmento **encendido con 0**).

> Este es un **kit**, no la solución: `char_a_7seg.v`, `registro_marquesina.v`, `marquesina_top.v` y
> `tb_marquesina.v` son esqueletos con bloques `// TODO`. Tal como viene **compila** y la tarjeta muestra
> `HOLA C` corriendo a la izquierda, un carácter por segundo, con un **guion** donde va la `I` de `CUCEI`
> (esa letra aún no está en la tabla). Tu trabajo es completar los TODO hasta que la marquesina muestre
> **tu nombre** en ambos sentidos, a cuatro velocidades y con pausa, y el testbench imprima
> `PASS: marquesina_top cumple las 6 pruebas`.

## Descarga el kit

1. Botón verde **Code → Download ZIP** de este repositorio (GitHub no descarga carpetas sueltas).
2. Descomprime y copia **solo** la carpeta `practica3` a una ruta **sin espacios ni acentos** cuya
   carpeta final lleve **tu código**: `C:\fpga\p3_tucódigo` (por ejemplo `C:\fpga\p3_219876543`).
   Esa ruta se ve en la barra de título de Quartus y en el *Transcript* de ModelSim: es parte de la evidencia.
3. Verifica que la carpeta tenga los **13 archivos** de la tabla de abajo.

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
| `tb_marquesina.v` | **esqueleto (TODO 0, A y B)** | Testbench autoverificable: trae T1, T2, T5 y T6; tú escribes T3 (dirección) y T4 (pausa) |
| `sincronizador.v` | completo | 2 FF para `SW[2:0]` |
| `antirrebote.v`, `detector_flanco.v` | completos | Los mismos de la P2 (para KEY1) |
| `divisor_tick.v` | completo | Habilitación de 1 ciclo cada `limite + 1` ciclos; compara con `>=`; `en` = ~pausa |
| `sim_marquesina.do` | completo | Script de Questa/ModelSim: compila los 8 archivos, arma el cronograma (ventana con *radix ASCII*) y corre |
| `p3.qpf`, `p3.qsf`, `p3.sdc` | completos | Proyecto de Quartus con los pines de la DE10-Lite y `create_clock -period 20` |
| `p3-diagrama-bloques.pdf` (y `.tex`) | — | Diagrama a bloques de lo que vas a construir |

Orden de los TODO (la guía los explica paso a paso): 1, 2, 4, 3, 5 y al final 0, A y B.

**No cambies** el nombre del módulo `marquesina_top`, sus parámetros (`N_BASE`, `DEB_N`, `LEN`, `MSG`) ni las
señales internas `tick`, `dir`, `r` y `ventana`: el testbench y el `.qsf` dependen de ellos. **Prohibido** usar
`tick`, un botón o un switch como reloj: todo es `always @(posedge clk ...)` con `if (tick)`.

## Simular (Questa / ModelSim, obligatorio)

1. `File > Change Directory…` → tu carpeta `p3_tucódigo`.
2. En el *Transcript* escribe `pwd` y `echo P3 ApellidoNombre CODIGO` (con tus datos) y después
   `do sim_marquesina.do`.
3. Debe imprimir tu nombre rotando y terminar con `PASS: marquesina_top cumple las 6 pruebas`.
   Si sale `FAIL`, lee el primer `ERROR`: dice qué prueba, cuándo y qué esperaba.
   Con el kit sin completar el testbench da `FAIL` (faltan velocidades y letras): es lo esperado.

### Si Questa / ModelSim no abre (licencia)

Se acepta **Icarus Verilog + GTKWave** con el mismo testbench (instalador de Windows en
<https://bleyer.org/icarus/>, incluye GTKWave). En una consola (`cmd`), dentro de tu carpeta `p3_tucódigo`:

```
echo P3 ApellidoNombre CODIGO
iverilog -o p3 sincronizador.v antirrebote.v detector_flanco.v divisor_tick.v registro_marquesina.v char_a_7seg.v marquesina_top.v tb_marquesina.v
vvp p3
gtkwave p3.vcd
```

La consola de `vvp` hace de *Transcript* (captura con la ruta del prompt, tu `echo` y el `PASS`). El testbench ya
escribe `p3.vcd`: en GTKWave agrega `tick`, `dir` y `ventana` (clic derecho → *Data Format* → *ASCII*).

## Compilar y programar (Quartus Prime Lite)

1. `File > Open Project…` → `p3.qpf` → `Processing > Start Compilation` (0 errores; los avisos de
   *truncated value* en el `case` de `limite` y de pines sin usar son esperados).
2. `Tools > Programmer` → *USB-Blaster* → `output_files/p3.sof` → *Start*.
3. Revisa el reporte (*Flow Summary*: elementos lógicos y registros; *Timing Analyzer → Slow 1200mV 85C Model*:
   Fmax y holgura) y el *RTL Viewer* (`Tools > Netlist Viewers`). Referencia con `LEN = 11`: 341 LE,
   146 registros, 71 pines, Fmax ≈ 128 MHz.
