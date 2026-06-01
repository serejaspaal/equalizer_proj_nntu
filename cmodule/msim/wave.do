onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cmodule/WIDTH
add wave -noupdate /tb_cmodule/clk
add wave -noupdate /tb_cmodule/rst
add wave -noupdate /tb_cmodule/valid_in
add wave -noupdate /tb_cmodule/Re
add wave -noupdate /tb_cmodule/Im
add wave -noupdate /tb_cmodule/valid_out
add wave -noupdate /tb_cmodule/MagSq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {1 us}
