onerror {resume}
quietly WaveActivateNextPane {} 0

delete wave *

add wave -noupdate /sum_tb/clk
add wave -noupdate /sum_tb/rst

add wave -noupdate /sum_tb/valid_in1
add wave -noupdate -radix decimal /sum_tb/A1
add wave -noupdate -radix decimal /sum_tb/B1
add wave -noupdate /sum_tb/sub1
add wave -noupdate /sum_tb/valid_out1
add wave -noupdate -radix decimal /sum_tb/S1
add wave -noupdate -radix decimal /sum_tb/exp_S1
add wave -noupdate /sum_tb/underflow1
add wave -noupdate /sum_tb/exp_u1

add wave -noupdate /sum_tb/valid_in2
add wave -noupdate -radix unsigned /sum_tb/A2
add wave -noupdate -radix unsigned /sum_tb/B2
add wave -noupdate /sum_tb/sub2
add wave -noupdate /sum_tb/valid_out2
add wave -noupdate -radix unsigned /sum_tb/S2
add wave -noupdate -radix unsigned /sum_tb/exp_S2
add wave -noupdate /sum_tb/underflow2
add wave -noupdate /sum_tb/exp_u2

TreeUpdate [SetDefaultTree]

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
WaveRestoreZoom {0 ns} {200 ns}