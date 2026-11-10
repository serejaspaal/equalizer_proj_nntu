onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /s_recover_tb/clk
add wave -noupdate /s_recover_tb/rst
add wave -noupdate /s_recover_tb/i_stb
add wave -noupdate /s_recover_tb/test_idx
add wave -noupdate -radix decimal /s_recover_tb/i_w11_re
add wave -noupdate -radix decimal /s_recover_tb/i_w11_im
add wave -noupdate -radix decimal /s_recover_tb/i_w12_re
add wave -noupdate -radix decimal /s_recover_tb/i_w12_im
add wave -noupdate -radix decimal /s_recover_tb/i_w21_re
add wave -noupdate -radix decimal /s_recover_tb/i_w21_im
add wave -noupdate -radix decimal /s_recover_tb/i_w22_re
add wave -noupdate -radix decimal /s_recover_tb/i_w22_im
add wave -noupdate -radix decimal /s_recover_tb/i_s11_re
add wave -noupdate -radix decimal /s_recover_tb/i_s11_im
add wave -noupdate -radix decimal /s_recover_tb/i_s21_re
add wave -noupdate -radix decimal /s_recover_tb/i_s21_im
add wave -noupdate -radix decimal /s_recover_tb/o_s11_re
add wave -noupdate -radix decimal /s_recover_tb/o_s11_im
add wave -noupdate /s_recover_tb/o_sat_s11_re
add wave -noupdate /s_recover_tb/o_sat_s11_im
add wave -noupdate -radix decimal /s_recover_tb/o_s21_re
add wave -noupdate -radix decimal /s_recover_tb/o_s21_im
add wave -noupdate /s_recover_tb/o_sat_s21_re
add wave -noupdate /s_recover_tb/o_sat_s21_im
add wave -noupdate /s_recover_tb/o_stb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {312 ns}
