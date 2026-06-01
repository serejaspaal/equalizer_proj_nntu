onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sum_pipeline_tb/clk
add wave -noupdate /sum_pipeline_tb/rst
add wave -noupdate /sum_pipeline_tb/valid_in
add wave -noupdate /sum_pipeline_tb/a
add wave -noupdate /sum_pipeline_tb/b
add wave -noupdate /sum_pipeline_tb/sub
add wave -noupdate /sum_pipeline_tb/valid_out
add wave -noupdate /sum_pipeline_tb/s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1228 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2936 ns}
