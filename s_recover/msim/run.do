transcript on
vlib work

vlog -sv ../../lib/cmult/src/cmult.sv ../../lib/cmult/mdl/cmult.c
vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c
vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c
vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../src/one_block_s_recover.sv
vlog -sv ../src/s_recover.sv ../mdl/s_recover.c

vlog -sv ../tb/s_recover_tb.sv

vsim -t 1ns -voptargs="+acc" s_recover_tb
do wave.do

view wave
view structure
view signals

run 300ns