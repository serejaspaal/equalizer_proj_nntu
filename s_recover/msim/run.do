transcript on
vlib work

vlog -sv ../../lib/cmult/src/cmult.sv
vlog -sv ../../lib/sum/src/sum.sv
vlog -sv ../../lib/round/src/round.sv
vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../src/one_block_s_recover.sv
vlog -sv ../src/s_recover.sv

vlog -sv ../tb/s_recover_tb.sv

vsim -t 1ns -voptargs="+acc" s_recover_tb
do wave.do

view wave
view structure
view signals

run 1us