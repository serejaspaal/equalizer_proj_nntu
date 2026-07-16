transcript on
vlib work

vlog -sv ../src/cmult_both_coupl.sv

vlog -sv ../tb/cmult_both_coupl_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_both_coupl_tb

do wave.do

view wave
view structure
view signals

run 300ns