transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv
vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv ../../lib/cmult_b_coupl/mdl/cmult_b_coupl.c
vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c
vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c
vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../src/a_side_diag.sv ../mdl/a_side_diag.c

vlog -sv ../tb/a_side_diag_tb.sv

vsim -t 1ns -voptargs="+acc" a_side_diag_tb

do wave.do

view wave
view structure
view signals

run 300ns