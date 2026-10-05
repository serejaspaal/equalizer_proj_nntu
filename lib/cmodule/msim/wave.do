onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmodule_tb/clk
add wave -noupdate /cmodule_tb/rst
add wave -noupdate /cmodule_tb/Re
add wave -noupdate /cmodule_tb/Im
add wave -noupdate -radix decimal /cmodule_tb/MagSq
add wave -noupdate -radix decimal /cmodule_tb/exp
add wave -noupdate /cmodule_tb/test_number
add wave -noupdate /cmodule_tb/errors
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ns} 0}
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
WaveRestoreZoom {0 ns} {308 ns}
