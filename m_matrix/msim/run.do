transcript on
vlib work

vlog -sv ../../lib/cmult_a_real_b_coupl/src/cmult_a_real_b_coupl.sv ../../lib/cmult_a_real_b_coupl/mdl/cmult_a_real_b_coupl.c

vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv ../../lib/cmult_b_coupl/mdl/cmult_b_coupl.c

vlog -sv ../../lib/cmult_both_coupl/src/cmult_both_coupl.sv ../../lib/cmult_both_coupl/mdl/cmult_both_coupl.c

vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c

vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c

vlog -sv ../src/bot_block_m_matrix.sv

vlog -sv ../src/top_block_m_matrix.sv

vlog -sv ../src/m_matrix.sv ../mdl/m_matrix.c

vlog -sv ../tb/m_matrix_tb.sv

vsim -t 1ns -voptargs="+acc" m_matrix_tb

do wave.do

view wave
view structure
view signals

run 700ns