onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /a_matrix_tb/clk
add wave -noupdate -radix binary /a_matrix_tb/rh11r
add wave -noupdate -radix binary /a_matrix_tb/rh11i
add wave -noupdate -radix binary /a_matrix_tb/rh12r
add wave -noupdate -radix binary /a_matrix_tb/rh12i
add wave -noupdate -radix binary /a_matrix_tb/rh21r
add wave -noupdate -radix binary /a_matrix_tb/rh21i
add wave -noupdate -radix binary /a_matrix_tb/rh22r
add wave -noupdate -radix binary /a_matrix_tb/rh22i
add wave -noupdate -radix float32 /a_matrix_tb/rc11
add wave -noupdate -radix float32 /a_matrix_tb/rc22
add wave -noupdate -radix decimal /a_matrix_tb/i_h11_re
add wave -noupdate -radix decimal /a_matrix_tb/i_h11_im
add wave -noupdate -radix decimal /a_matrix_tb/i_h12_re
add wave -noupdate -radix decimal /a_matrix_tb/i_h12_im
add wave -noupdate -radix decimal /a_matrix_tb/i_h21_re
add wave -noupdate -radix decimal /a_matrix_tb/i_h21_im
add wave -noupdate -radix decimal /a_matrix_tb/i_h22_re
add wave -noupdate -radix decimal /a_matrix_tb/i_h22_im
add wave -noupdate -radix unsigned /a_matrix_tb/i_c11
add wave -noupdate -radix unsigned /a_matrix_tb/i_c22
add wave -noupdate -radix unsigned /a_matrix_tb/o_a11
add wave -noupdate -radix unsigned /a_matrix_tb/o_a22
add wave -noupdate -radix decimal /a_matrix_tb/o_a12_re
add wave -noupdate -radix decimal /a_matrix_tb/o_a12_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {911 ns} 0}
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
WaveRestoreZoom {879 ns} {1007 ns}
