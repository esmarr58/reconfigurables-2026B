// p5_top.v -- Practica 5: la ALU registrada (P03 del TC07) en la DE10-Lite. ESQUELETO del alumno.
// Envoltura de tarjeta: instancia el modulo top de la P03 SIN modificarlo y lo conecta a la tarjeta.
// No cambies el nombre del modulo ni sus puertos: p5.qsf asigna los pines con esos nombres.
//   KEY[1] = reset    KEY[0] = cargar      (los botones son activos en bajo: oprimido = 0)
//   SW[9:8] = op (00 suma, 01 resta, 10 AND, 11 OR)      SW[7:4] = A      SW[3:0] = B
//   De izquierda a derecha en la tarjeta: switches op, A, B; displays A, B ... resultado.
//   HEX5 = A   HEX4 = B   HEX0 = resultado guardado   LEDR[3:0] = resultado   LEDR[9] = cero
// Tal como viene COMPILA, pero la tarjeta se ve mal a proposito: HEX0 muestra un guion, HEX1 a HEX3
// muestran 8 con punto, HEX5 y HEX4 estan apagados y el resultado no sale de 0. Son los 4 TODO.
module p5_top(
	input  wire       MAX10_CLK1_50,
	input  wire [1:0] KEY,
	input  wire [9:0] SW,
	output wire [9:0] LEDR,
	output wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	wire       rst;
	wire       cargar;
	wire [3:0] resultado;
	wire       cero;
	wire [6:0] seg_r;            // segmentos del resultado, activos en ALTO (asi los entrega deco_7seg)
	wire [6:0] seg_a;            // segmentos de A, activos en alto
	wire [6:0] seg_b;            // segmentos de B, activos en alto

	// ===== TODO 1: los botones son activos en bajo ======================================================
	// Asi como esta, rst vale 1 con el boton SUELTO: el registro vive en reset. Niega los dos botones (~).
	assign rst    = KEY[1];      // TODO 1
	assign cargar = KEY[0];      // TODO 1

	// ===== La P03 completa, sin tocarla (esto ya esta hecho) ===========================================
	top u_p03(
		.clk       (MAX10_CLK1_50),
		.rst       (rst),
		.cargar    (cargar),
		.a         (SW[7:4]),
		.b         (SW[3:0]),
		.op        (SW[9:8]),
		.resultado (resultado),
		.seg       (seg_r),
		.cero      (cero)
	);

	// LEDR[9] = cero, LEDR[8:4] apagados, LEDR[3:0] = resultado guardado
	assign LEDR = {cero, 5'b00000, resultado};

	// ===== TODO 2: los displays son activos en bajo (bit 7 = punto decimal, apagado con 1) ==============
	// deco_7seg entrega 1 = segmento encendido; la tarjeta enciende con 0. Niega seg_r.
	assign HEX0 = {1'b1, seg_r}; // TODO 2

	// ===== TODO 3: A en HEX5 y B en HEX4 ===============================================================
	// Instancia deco_7seg dos veces mas: u_deco_a (dato = SW[7:4], seg = seg_a) y
	// u_deco_b (dato = SW[3:0], seg = seg_b). Luego SUSTITUYE las dos lineas de abajo por
	// {1'b1, ~seg_a} y {1'b1, ~seg_b}.
	// deco_7seg u_deco_a( ... );
	// deco_7seg u_deco_b( ... );
	assign HEX5 = 8'hFF;         // TODO 3
	assign HEX4 = 8'hFF;         // TODO 3

	// ===== TODO 4: displays sin uso, apagados ==========================================================
	// Con 8'h00 los ocho segmentos se encienden (0 = encendido). Apagalos.
	assign HEX1 = 8'h00;         // TODO 4
	assign HEX2 = 8'h00;         // TODO 4
	assign HEX3 = 8'h00;         // TODO 4
endmodule
