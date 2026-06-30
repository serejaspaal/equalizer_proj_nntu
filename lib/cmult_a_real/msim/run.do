transcript on
vlib work

vlog -sv ../src/cmult_a_real.sv

vlog -sv ../tb/cmult_a_real_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_a_real_tb

do wave.do

view wave
view structure
view signals

run 300ns