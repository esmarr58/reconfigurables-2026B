# p3.sdc -- restricciones de tiempo (SDC: Synopsys Design Constraints)
# Reloj de 50 MHz de la DE10-Lite: periodo 20 ns.
create_clock -name MAX10_CLK1_50 -period 20.000 [get_ports {MAX10_CLK1_50}]
derive_clock_uncertainty
# Botones y switches son asincronos (humanos) y pasan por sincronizadores;
# LEDs y displays no tienen requisito de tiempo: se excluyen del analisis.
set_false_path -from [get_ports {KEY[*] SW[*]}]
set_false_path -to   [get_ports {LEDR[*] HEX0[*] HEX1[*] HEX2[*] HEX3[*] HEX4[*] HEX5[*]}]
