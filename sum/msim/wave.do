onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sum_tb/A_WIDTH
add wave -noupdate /sum_tb/B_WIDTH
add wave -noupdate /sum_tb/MAX_W
add wave -noupdate /sum_tb/clk
add wave -noupdate /sum_tb/rst
add wave -noupdate /sum_tb/sub
add wave -noupdate /sum_tb/A
add wave -noupdate /sum_tb/B
add wave -noupdate /sum_tb/S
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75 ns} 0}
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
WaveRestoreZoom {0 ns} {92 ns}
