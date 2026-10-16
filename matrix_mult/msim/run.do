transcript on
vlib work

vlog -sv ../../lib/sum/src/sum.sv
vlog -sv ../../lib/cmult/src/cmult.sv
vlog -sv ../../lib/round/src/round.sv

vlog -sv ../src/matrix_mult.sv

vlog -sv ../src/one_block_matrix_mult.sv

vlog -sv ../tb/matrix_mult_tb.sv

vsim -t 1ns -voptargs="+acc" matrix_mult_tb

do wave.do

view wave
view structure
view signals

run  420ns
