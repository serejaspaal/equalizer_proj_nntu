transcript on
vlib work

vlog -sv ../../lib/cmult_a_real_b_coupl/src/cmult_a_real_b_coupl.sv

vlog -sv ../../lib/cmult_b_coupl/src/cmult_b_coupl.sv

vlog -sv ../../lib/cmult_both_coupl/src/cmult_both_coupl.sv

vlog -sv ../../lib/sum/src/sum.sv

vlog -sv ../../lib/round/src/round.sv

vlog -sv ../src/m_matrix.sv

vlog -sv ../tb/m_matrix_tb.sv

vsim -t 1ns -voptargs="+acc" m_matrix_tb

do wave.do

view wave
view structure
view signals

run 1500ns