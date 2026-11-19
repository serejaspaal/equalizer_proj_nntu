transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv ../../lib/cmodule/mdl/cmodule.c
vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv ../../lib/cmult_b_coupl/mdl/cmult_b_coupl.c
vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c
vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c
vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../../a_main_diag/src/a_main_diag.sv
vlog -sv ../../a_side_diag/src/a_side_diag.sv
vlog -sv ../src/a_matrix.sv

vlog -sv ../tb/a_matrix_tb.sv ../mdl/a_matrix.c ../mdl/gen_stimulus.c

vsim -t 1ns -voptargs="+acc" a_matrix_tb

do wave.do

view wave
view structure
view signals

run -all