transcript on
vlib work

vlog -sv ../src/cmodule.sv

vlog -sv ../tb/tb_cmodule.sv

vsim -t 1ns -voptargs="+acc" tb_cmodule

do wave.do

view wave
view structure
view signals

run 300ns