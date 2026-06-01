transcript on
vlib work

vlog -sv ../src/mult.sv

vlog -sv ../tb/mult_tb.sv

vsim -t 1ns -voptargs="+acc" mult_tb

do wave.do

view wave
view structure
view signals

run 300ns