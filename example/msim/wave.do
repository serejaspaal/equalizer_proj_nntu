onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /example_tb/WIDTH
add wave -noupdate /example_tb/clk
add wave -noupdate /example_tb/rst
add wave -noupdate /example_tb/valid_in
add wave -noupdate /example_tb/Re
add wave -noupdate /example_tb/Im
add wave -noupdate /example_tb/valid_out
add wave -noupdate -radix unsigned /example_tb/MagSq
add wave -noupdate -radix unsigned /example_tb/exp1
add wave -noupdate /example_tb/v1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {252 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {173 ns}
