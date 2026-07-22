transcript on
vlib work

vlog -sv ../src/dline.sv

vlog -sv ../tb/dline_tb.sv

vsim -t 1ns -voptargs="+acc" dline_tb

do wave.do

view wave
view structure
view signals

run 300ns