transcript on
vlib work

vlog -sv ../src/mult.sv ../mdl/mult.c

vlog -sv ../tb/mult_tb.sv

vsim -t 1ns -voptargs="+acc" mult_tb

do wave.do

view wave
view structure
view signals

run 70ns
