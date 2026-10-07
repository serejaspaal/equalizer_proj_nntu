transcript on
vlib work

vlog -sv ../src/cmult_b_coupl.sv ../mdl/cmult_b_coupl.c

vlog -sv ../tb/cmult_b_coupl_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_b_coupl_tb

do wave.do

view wave
view structure
view signals

run 300ns