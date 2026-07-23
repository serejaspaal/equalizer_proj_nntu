transcript on
vlib work

vlog -sv ../../lib/sum/src/sum.sv
vlog -sv ../../lib/mult/src/mult.sv
vlog -sv ../../lib/round/src/round.sv
vlog -sv ../../lib/dline/src/dline.sv
vlog -sv ../../lib/cmodule/src/cmodule.sv
vlog -sv ../../lib/cmult_a_real_b_coupl/src/cmult_a_real_b_coupl.sv
vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv
vlog -sv ../../lib/cmult_both_coupl/src/cmult_both_coupl.sv
vlog -sv ../../lib/cmult_a_real/src/cmult_a_real.sv

vlog -sv ../../func_reverse/src/func_reverse.sv

vlog -sv ../../func_reverse/src/block_ram.sv

vlog -sv ../../cmult_matrix_on_real/src/cmult_matrix_on_real.sv

vlog -sv ../../a_det/src/a_det.sv

vlog -sv ../../m_matrix/src/bot_block_m_matrix.sv

vlog -sv ../../m_matrix/src/top_block_m_matrix.sv

vlog -sv ../../m_matrix/src/m_matrix.sv

vlog -sv ../src/w_matrix.sv

vlog -sv ../tb/w_matrix_tb.sv

vsim -t 1ns -voptargs="+acc" w_matrix_tb

do wave.do

view wave
view structure
view signals

run  1000ns
