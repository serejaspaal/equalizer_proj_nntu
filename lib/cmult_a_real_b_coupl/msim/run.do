transcript on
vlib work

vlog -sv ../src/cmult_a_real_b_coupl.sv ../mdl/cmult_a_real_b_coupl.c
vlog -sv ../tb/cmult_a_real_b_coupl_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_a_real_b_coupl_tb

do wave.do

view wave
view structure
view signals

run 400ns
