onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -radix binary /a_side_diag_tb/clk
add wave -noupdate -radix binary /a_side_diag_tb/rst
add wave -noupdate -radix binary /a_side_diag_tb/valid_in
add wave -noupdate -radix binary /a_side_diag_tb/valid_out

add wave -noupdate -radix decimal /a_side_diag_tb/h11_re
add wave -noupdate -radix decimal /a_side_diag_tb/h11_im
add wave -noupdate -radix decimal /a_side_diag_tb/h12_re
add wave -noupdate -radix decimal /a_side_diag_tb/h12_im
add wave -noupdate -radix decimal /a_side_diag_tb/h21_re
add wave -noupdate -radix decimal /a_side_diag_tb/h21_im
add wave -noupdate -radix decimal /a_side_diag_tb/h22_re
add wave -noupdate -radix decimal /a_side_diag_tb/h22_im

add wave -noupdate -radix decimal /a_side_diag_tb/a12_re
add wave -noupdate -radix decimal /a_side_diag_tb/a12_im
add wave -noupdate -radix binary /a_side_diag_tb/sat_a12_re
add wave -noupdate -radix binary /a_side_diag_tb/sat_a12_im

add wave -divider "A_SIDE_DIAG INTERNAL"

add wave -noupdate -radix decimal /a_side_diag_tb/dut/cmult_re
add wave -noupdate -radix decimal /a_side_diag_tb/dut/cmult_im

add wave -noupdate -radix decimal /a_side_diag_tb/dut/sum_re
add wave -noupdate -radix decimal /a_side_diag_tb/dut/sum_im

add wave -noupdate -radix decimal /a_side_diag_tb/dut/round_re
add wave -noupdate -radix decimal /a_side_diag_tb/dut/round_im

add wave -noupdate -radix binary /a_side_diag_tb/dut/valid_cm3
add wave -noupdate -radix binary /a_side_diag_tb/dut/valid_sum_re
add wave -noupdate -radix binary /a_side_diag_tb/dut/valid_out

TreeUpdate [SetDefaultTree]

configure wave -namecolwidth 239
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

WaveRestoreZoom {0 ns} {625 ns}