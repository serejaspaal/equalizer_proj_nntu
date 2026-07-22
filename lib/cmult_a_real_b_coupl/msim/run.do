transcript on
vlib work

vlog -sv ../src/cmult_a_real_b_coupl.sv

vlog -sv ../tb/cmult_a_real_b_coupl_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_a_real_b_coupl_tb

do wave.do

view wave
view structure
view signals

run 300ns