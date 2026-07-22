transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv

vlog -sv ../src/example.sv

vlog -sv ../tb/example_tb.sv

vsim -t 1ns -voptargs="+acc" example_tb

do wave.do

view wave
view structure
view signals

run 300ns
