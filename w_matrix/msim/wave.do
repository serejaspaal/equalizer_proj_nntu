onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /w_matrix_tb/clk
add wave -noupdate /w_matrix_tb/rst
add wave -noupdate /w_matrix_tb/i_h11_re
add wave -noupdate /w_matrix_tb/i_h11_im
add wave -noupdate /w_matrix_tb/i_h12_re
add wave -noupdate /w_matrix_tb/i_h12_im
add wave -noupdate /w_matrix_tb/i_h21_re
add wave -noupdate /w_matrix_tb/i_h21_im
add wave -noupdate /w_matrix_tb/i_h22_re
add wave -noupdate /w_matrix_tb/i_h22_im
add wave -noupdate -radix unsigned /w_matrix_tb/i_a11
add wave -noupdate -radix unsigned /w_matrix_tb/i_a22
add wave -noupdate /w_matrix_tb/i_a12_re
add wave -noupdate /w_matrix_tb/i_a12_im
add wave -noupdate /w_matrix_tb/i_a11_fxp
add wave -noupdate /w_matrix_tb/i_a22_fxp
add wave -noupdate /w_matrix_tb/i_a12_re_fxp
add wave -noupdate /w_matrix_tb/i_a12_im_fxp
add wave -noupdate -color {Olive Drab} /w_matrix_tb/det_a_fxp
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_det_sat
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_det_udf
add wave -noupdate -color {Olive Drab} /w_matrix_tb/det_inv_fxp
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_det_inv_inf
add wave -noupdate -color Cyan /w_matrix_tb/o_w11_re
add wave -noupdate -color Cyan /w_matrix_tb/o_w11_im
add wave -noupdate -color Cyan /w_matrix_tb/o_w12_re
add wave -noupdate -color Cyan /w_matrix_tb/o_w12_im
add wave -noupdate -color Cyan /w_matrix_tb/o_w21_re
add wave -noupdate -color Cyan /w_matrix_tb/o_w21_im
add wave -noupdate -color Cyan /w_matrix_tb/o_w22_re
add wave -noupdate -color Cyan /w_matrix_tb/o_w22_im
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w11_re
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w11_im
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w12_re
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w12_im
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w21_re
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w21_im
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w22_re
add wave -noupdate -color Cyan /w_matrix_tb/o_sat_w22_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m11_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m11_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m12_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m12_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m21_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m21_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m22_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_m22_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m11_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m11_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m12_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m12_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m21_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m21_im
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m22_re
add wave -noupdate -color {Olive Drab} /w_matrix_tb/o_sat_m22_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {174 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 208
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
WaveRestoreZoom {0 ns} {231 ns}
