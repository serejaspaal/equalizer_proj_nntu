transcript on
vlib work

vlog -sv ../src/round.sv

vlog -sv ../tb/round_tb.sv

vsim -t 1ns -voptargs="+acc" round_tb

do wave.do

view wave
view structure
view signals

# set required simulation time here
run 100us