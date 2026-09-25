transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv
vlog -sv ../../lib/round/src/round.sv
vlog -sv ../../lib/sum/src/sum.sv

vlog -sv ../src/a_main_diag.sv

vlog -sv ../tb/a_main_diag_tb.sv

vsim -t 1ns -voptargs="+acc" a_main_diag_tb

do wave.do

view wave
view structure
view signals

run 300ns
