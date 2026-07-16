onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmult_matrix_on_real_tb/clk
add wave -noupdate -radix unsigned /cmult_matrix_on_real_tb/det_inv
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m11_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m11_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m12_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m12_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m21_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m21_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m22_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/i_m22_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w11_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w11_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w12_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w12_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w21_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w21_im
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w22_re
add wave -noupdate -radix decimal /cmult_matrix_on_real_tb/o_w22_im
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w11_re
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w11_im
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w12_re
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w12_im
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w21_re
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w21_im
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w22_re
add wave -noupdate /cmult_matrix_on_real_tb/o_sat_w22_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
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
WaveRestoreZoom {0 ns} {203 ns}
