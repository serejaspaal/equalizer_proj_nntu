transcript on
vlib work

vlog -sv ../src/sum_pipeline.sv

vlog -sv ../tb/sum_pipeline_tb.sv

vsim -t 1ns -voptargs="+acc" sum_pipeline_tb

do wave.do

view wave
view structure
view signals

run 300ns