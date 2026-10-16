transcript on
vlib work

vlog -sv ../../dline/src/dline.sv

vlog -sv ../src/cmodule.sv ../mdl/cmodule.c

vlog -sv ../tb/cmodule_tb.sv

vsim -t 1ns -voptargs="+acc" cmodule_tb

do wave.do

view wave
view structure
view signals

run 600ns
