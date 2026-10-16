transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv
vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv
vlog -sv ../../lib/round/src/round.sv
vlog -sv ../../lib/sum/src/sum.sv
vlog -sv ../../lib/dline/src/dline.sv
vlog -sv ../../a_side_diag/src/a_side_diag.sv
vlog -sv ../../a_main_diag/src/a_main_diag.sv

vlog -sv ../src/a_matrix.sv ../mdl/gen_stimulus.c

vlog -sv ../tb/a_matrix_tb.sv

vsim -t 1ns -voptargs="+acc" a_matrix_tb

do wave.do

view wave
view structure
view signals

run 1us