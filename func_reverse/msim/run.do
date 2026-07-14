transcript on
vlib work

vlog -sv ../src/func_reverse.sv

vlog -sv ../tb/func_reverse_tb.sv

vsim -t 1ns -voptargs="+acc" func_reverse_tb

do wave.do

view wave
view structure
view signals

run 300ns