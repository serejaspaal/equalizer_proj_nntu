transcript on
vlib work

vlog -sv ../src/sum.sv

vlog -sv ../tb/sum_tb.sv

vsim -t 1ns -voptargs="+acc" sum_tb

do wave.do

view wave
view structure
view signals

run 300ns