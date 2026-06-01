transcript on
vlib work

vlog -sv ../src/cmult.sv

vlog -sv ../tb/cmult_tb.sv

vsim -t 1ns -voptargs="+acc" cmult_tb

do wave.do

view wave
view structure
view signals

run 100ns