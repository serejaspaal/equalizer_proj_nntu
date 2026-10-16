onerror {resume}
quietly WaveActivateNextPane {} 0

delete wave *

add wave -noupdate /neg_tb/clk
add wave -noupdate -radix decimal /neg_tb/a
add wave -noupdate -radix decimal /neg_tb/result
add wave -noupdate -radix decimal /neg_tb/expected

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