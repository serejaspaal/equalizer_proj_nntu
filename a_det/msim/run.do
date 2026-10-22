transcript on
vlib work

vlog -sv ../../lib/cmodule/src/cmodule.sv ../../lib/cmodule/mdl/cmodule.c

vlog -sv ../../lib/sum/src/sum.sv ../../lib/sum/mdl/sum.c

vlog -sv ../../lib/mult/src/mult.sv ../../lib/mult/mdl/mult.c

vlog -sv ../../lib/dline/src/dline.sv

vlog -sv ../../lib/round/src/round.sv ../../lib/round/mdl/round.c

vlog -sv ../src/a_det.sv ../mdl/a_det.c

vlog -sv ../tb/a_det_tb.sv

vsim -t 1ns -voptargs="+acc" a_det_tb

do wave.do

view wave
view structure
view signals

# set required simulation time here
run 700ns