transcript on
vlib work

vlog -sv ../src/neg.sv

vlog -sv ../tb/neg_tb.sv

vsim -t 1ns -voptargs="+acc" neg_tb

do wave.do

view wave
view structure
view signals

run 150ns