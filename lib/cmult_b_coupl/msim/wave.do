onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmult_b_coupl_tb/dut/clk
add wave -noupdate /cmult_b_coupl_tb/dut/x0
add wave -noupdate /cmult_b_coupl_tb/dut/y0
add wave -noupdate /cmult_b_coupl_tb/dut/x1
add wave -noupdate /cmult_b_coupl_tb/dut/y1
add wave -noupdate /cmult_b_coupl_tb/dut/sum_a
add wave -noupdate /cmult_b_coupl_tb/dut/dif_b
add wave -noupdate /cmult_b_coupl_tb/dut/p1
add wave -noupdate /cmult_b_coupl_tb/dut/p2
add wave -noupdate /cmult_b_coupl_tb/dut/p3
add wave -noupdate /cmult_b_coupl_tb/dut/p1_reg
add wave -noupdate /cmult_b_coupl_tb/dut/p2_reg
add wave -noupdate /cmult_b_coupl_tb/dut/out_re
add wave -noupdate /cmult_b_coupl_tb/dut/out_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ns} 0}
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
WaveRestoreZoom {0 ns} {126 ns}
