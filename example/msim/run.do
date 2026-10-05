transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv ../../lib/cmodule/mdl/cmodule.c

vlog -sv ../src/example.sv ../mdl/example.c

vlog -sv ../tb/example_tb.sv

vsim -t 1ns -voptargs="+acc" example_tb

do wave.do

view wave
view structure
view signals

run 500ns
