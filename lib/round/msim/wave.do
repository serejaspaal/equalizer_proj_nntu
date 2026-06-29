onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /round_tb/clk
add wave -noupdate /round_tb/i_data_fxp_s
add wave -noupdate /round_tb/round_fxp_s
add wave -noupdate /round_tb/o_sat_s
add wave -noupdate /round_tb/i_data_fxp_u
add wave -noupdate /round_tb/round_fxp_u
add wave -noupdate /round_tb/o_sat_u
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 179
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
WaveRestoreZoom {0 ns} {69 ns}
