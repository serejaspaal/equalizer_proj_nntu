onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dline_tb/DATA_WIDTH
add wave -noupdate /dline_tb/DELAY
add wave -noupdate /dline_tb/i_clk
add wave -noupdate -radix decimal /dline_tb/i_data
add wave -noupdate -radix decimal /dline_tb/o_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51 ns} 0}
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
WaveRestoreZoom {13 ns} {205 ns}
