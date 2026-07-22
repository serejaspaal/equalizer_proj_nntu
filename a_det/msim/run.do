transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv

vlog -sv ../../lib/sum/src/sum.sv

vlog -sv ../../lib/mult/src/mult.sv

vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../../lib/round/src/round.sv

vlog -sv ../src/a_det.sv

vlog -sv ../tb/a_det_tb.sv

vsim -t 1ns -voptargs="+acc" a_det_tb

do wave.do

view wave
view structure
view signals

run  700ns
