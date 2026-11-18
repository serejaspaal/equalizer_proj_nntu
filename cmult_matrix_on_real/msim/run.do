transcript on
vlib work

vlog -sv ../../lib/cmult_a_real/src/cmult_a_real.sv ../../lib/cmult_a_real/mdl/cmult_a_real.c
vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c

vlog -sv ../src/cmult_matrix_on_real.sv ../mdl/cmult_matrix_on_real.c

vlog -sv ../tb/cmult_matrix_on_real_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_matrix_on_real_tb

do wave.do

view wave
view structure
view signals

run 250ns
