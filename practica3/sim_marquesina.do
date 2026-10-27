# =====================================================================
#  sim_marquesina.do  --  Simulacion de la Practica 3 en Questa (Intel FPGA Starter) / ModelSim
#  Uso (en la consola "Transcript", ya ubicado en esta carpeta con
#  File > Change Directory):      do sim_marquesina.do
#  Debe terminar con:  PASS: marquesina_top cumple las 6 pruebas ...
# =====================================================================
if {[file exists work]} { vdel -lib work -all }
vlib work
vlog -work work sincronizador.v antirrebote.v detector_flanco.v divisor_tick.v \
                registro_marquesina.v char_a_7seg.v marquesina_top.v tb_marquesina.v
vsim -voptargs=+acc work.tb_marquesina

# Senales para el cronograma (waveform)
add wave -divider "Entradas"
add wave           sim:/tb_marquesina/KEY
add wave           sim:/tb_marquesina/SW(0)
add wave           sim:/tb_marquesina/SW(2)
add wave           sim:/tb_marquesina/SW(1)
add wave -divider "Control"
add wave           sim:/tb_marquesina/dut/rst_n
add wave           sim:/tb_marquesina/dut/dir
add wave -unsigned sim:/tb_marquesina/dut/nivel
add wave           sim:/tb_marquesina/dut/pausa
add wave -unsigned sim:/tb_marquesina/dut/limite
add wave           sim:/tb_marquesina/dut/tick
add wave -divider "Marquesina: la ventana se ve como TEXTO (radix ASCII)"
add wave -radix ascii sim:/tb_marquesina/dut/ventana
add wave -radix ascii sim:/tb_marquesina/dut/r
add wave -divider "Displays (activos en bajo)"
add wave -hex      sim:/tb_marquesina/HEX5
add wave -hex      sim:/tb_marquesina/HEX0
add wave -divider "Modelo del testbench"
add wave -unsigned sim:/tb_marquesina/desp
add wave -unsigned sim:/tb_marquesina/errores

run -all
wave zoom full
