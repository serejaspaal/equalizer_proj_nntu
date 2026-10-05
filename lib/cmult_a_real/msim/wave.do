onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmult_a_real_tb/clk
add wave -noupdate -radix decimal /cmult_a_real_tb/a_s
add wave -noupdate -radix unsigned /cmult_a_real_tb/a_u
add wave -noupdate -radix decimal /cmult_a_real_tb/x1
add wave -noupdate -radix decimal /cmult_a_real_tb/y1
add wave -noupdate -radix decimal /cmult_a_real_tb/out_re_s
add wave -noupdate /cmult_a_real_tb/exp_re_s
add wave -noupdate -radix decimal /cmult_a_real_tb/out_im_s
add wave -noupdate /cmult_a_real_tb/exp_im_s
add wave -noupdate -radix decimal /cmult_a_real_tb/out_re_u
add wave -noupdate /cmult_a_real_tb/exp_re_u
add wave -noupdate -radix decimal /cmult_a_real_tb/out_im_u
add wave -noupdate /cmult_a_real_tb/exp_im_u
add wave -noupdate /cmult_a_real_tb/test_number
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {202 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
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
WaveRestoreZoom {199 ns} {306 ns}
