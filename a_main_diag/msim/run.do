transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv
vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c
vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c
vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../src/a_main_diag.sv ../mdl/a_main_diag.c

vlog -sv ../tb/a_main_diag_tb.sv

vsim -t 1ns -voptargs="+acc" a_main_diag_tb

do wave.do

view wave
view structure
view signals

run -all