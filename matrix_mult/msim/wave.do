onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /matrix_mult_tb/clk
add wave -noupdate /matrix_mult_tb/rst
add wave -noupdate /matrix_mult_tb/i_w11_re
add wave -noupdate /matrix_mult_tb/i_w11_im
add wave -noupdate /matrix_mult_tb/i_w12_re
add wave -noupdate /matrix_mult_tb/i_w12_im
add wave -noupdate /matrix_mult_tb/i_w21_re
add wave -noupdate /matrix_mult_tb/i_w21_im
add wave -noupdate /matrix_mult_tb/i_w22_re
add wave -noupdate /matrix_mult_tb/i_w22_im
add wave -noupdate /matrix_mult_tb/i_s11_re
add wave -noupdate /matrix_mult_tb/i_s11_im
add wave -noupdate /matrix_mult_tb/i_s12_re
add wave -noupdate /matrix_mult_tb/i_s12_im
add wave -noupdate /matrix_mult_tb/i_s21_re
add wave -noupdate /matrix_mult_tb/i_s21_im
add wave -noupdate /matrix_mult_tb/i_s22_re
add wave -noupdate /matrix_mult_tb/i_s22_im
add wave -noupdate /matrix_mult_tb/o_f11_re
add wave -noupdate /matrix_mult_tb/o_f11_im
add wave -noupdate /matrix_mult_tb/o_f12_re
add wave -noupdate /matrix_mult_tb/o_f12_im
add wave -noupdate /matrix_mult_tb/o_f21_re
add wave -noupdate /matrix_mult_tb/o_f21_im
add wave -noupdate /matrix_mult_tb/o_f22_re
add wave -noupdate /matrix_mult_tb/o_f22_im
add wave -noupdate -color Cyan /matrix_mult_tb/w11_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w11_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w12_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w12_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w21_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w21_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w22_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/w22_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s11_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s11_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s12_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s12_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s21_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s21_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s22_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/s22_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f11_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f11_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f12_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f12_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f21_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f21_im_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f22_re_fxp
add wave -noupdate -color Cyan /matrix_mult_tb/f22_im_fxp
add wave -noupdate /matrix_mult_tb/o_sat11_re
add wave -noupdate /matrix_mult_tb/o_sat11_im
add wave -noupdate /matrix_mult_tb/o_sat12_re
add wave -noupdate /matrix_mult_tb/o_sat12_im
add wave -noupdate /matrix_mult_tb/o_sat21_re
add wave -noupdate /matrix_mult_tb/o_sat21_im
add wave -noupdate /matrix_mult_tb/o_sat22_re
add wave -noupdate /matrix_mult_tb/o_sat22_im
add wave -noupdate /matrix_mult_tb/o_udf11_re
add wave -noupdate /matrix_mult_tb/o_udf11_im
add wave -noupdate /matrix_mult_tb/o_udf12_re
add wave -noupdate /matrix_mult_tb/o_udf12_im
add wave -noupdate /matrix_mult_tb/o_udf21_re
add wave -noupdate /matrix_mult_tb/o_udf21_im
add wave -noupdate /matrix_mult_tb/o_udf22_re
add wave -noupdate /matrix_mult_tb/o_udf22_im
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {139 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
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
WaveRestoreZoom {0 ns} {580 ns}
