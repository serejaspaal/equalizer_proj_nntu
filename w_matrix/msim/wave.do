onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /w_matrix_tb/clk
add wave -noupdate /w_matrix_tb/rst
add wave -noupdate -expand -group input /w_matrix_tb/i_stb
add wave -noupdate -expand -group input -radix unsigned /w_matrix_tb/i_a11
add wave -noupdate -expand -group input /w_matrix_tb/i_a12_re
add wave -noupdate -expand -group input /w_matrix_tb/i_a12_im
add wave -noupdate -expand -group input -radix unsigned /w_matrix_tb/i_a22
add wave -noupdate -expand -group input /w_matrix_tb/i_a11_fxp
add wave -noupdate -expand -group input /w_matrix_tb/i_a12_re_fxp
add wave -noupdate -expand -group input /w_matrix_tb/i_a12_im_fxp
add wave -noupdate -expand -group input /w_matrix_tb/i_a22_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h11_re_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h11_im_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h12_re_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h12_im_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h21_re_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h21_im_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h22_re_fxp
add wave -noupdate -expand -group input /w_matrix_tb/h22_im_fxp
add wave -noupdate -expand -group det_a -radix unsigned /w_matrix_tb/o_det_a
add wave -noupdate -expand -group det_a -color {Olive Drab} /w_matrix_tb/det_a_fxp
add wave -noupdate -expand -group det_a -color {Olive Drab} /w_matrix_tb/o_det_sat
add wave -noupdate -expand -group det_a -color {Olive Drab} /w_matrix_tb/o_det_udf
add wave -noupdate -expand -group det_a_inv -radix unsigned -childformat {{{/w_matrix_tb/o_det_inv[39]} -radix unsigned} {{/w_matrix_tb/o_det_inv[38]} -radix unsigned} {{/w_matrix_tb/o_det_inv[37]} -radix unsigned} {{/w_matrix_tb/o_det_inv[36]} -radix unsigned} {{/w_matrix_tb/o_det_inv[35]} -radix unsigned} {{/w_matrix_tb/o_det_inv[34]} -radix unsigned} {{/w_matrix_tb/o_det_inv[33]} -radix unsigned} {{/w_matrix_tb/o_det_inv[32]} -radix unsigned} {{/w_matrix_tb/o_det_inv[31]} -radix unsigned} {{/w_matrix_tb/o_det_inv[30]} -radix unsigned} {{/w_matrix_tb/o_det_inv[29]} -radix unsigned} {{/w_matrix_tb/o_det_inv[28]} -radix unsigned} {{/w_matrix_tb/o_det_inv[27]} -radix unsigned} {{/w_matrix_tb/o_det_inv[26]} -radix unsigned} {{/w_matrix_tb/o_det_inv[25]} -radix unsigned} {{/w_matrix_tb/o_det_inv[24]} -radix unsigned} {{/w_matrix_tb/o_det_inv[23]} -radix unsigned} {{/w_matrix_tb/o_det_inv[22]} -radix unsigned} {{/w_matrix_tb/o_det_inv[21]} -radix unsigned} {{/w_matrix_tb/o_det_inv[20]} -radix unsigned} {{/w_matrix_tb/o_det_inv[19]} -radix unsigned} {{/w_matrix_tb/o_det_inv[18]} -radix unsigned} {{/w_matrix_tb/o_det_inv[17]} -radix unsigned} {{/w_matrix_tb/o_det_inv[16]} -radix unsigned} {{/w_matrix_tb/o_det_inv[15]} -radix unsigned} {{/w_matrix_tb/o_det_inv[14]} -radix unsigned} {{/w_matrix_tb/o_det_inv[13]} -radix unsigned} {{/w_matrix_tb/o_det_inv[12]} -radix unsigned} {{/w_matrix_tb/o_det_inv[11]} -radix unsigned} {{/w_matrix_tb/o_det_inv[10]} -radix unsigned} {{/w_matrix_tb/o_det_inv[9]} -radix unsigned} {{/w_matrix_tb/o_det_inv[8]} -radix unsigned} {{/w_matrix_tb/o_det_inv[7]} -radix unsigned} {{/w_matrix_tb/o_det_inv[6]} -radix unsigned} {{/w_matrix_tb/o_det_inv[5]} -radix unsigned} {{/w_matrix_tb/o_det_inv[4]} -radix unsigned} {{/w_matrix_tb/o_det_inv[3]} -radix unsigned} {{/w_matrix_tb/o_det_inv[2]} -radix unsigned} {{/w_matrix_tb/o_det_inv[1]} -radix unsigned} {{/w_matrix_tb/o_det_inv[0]} -radix unsigned}} -subitemconfig {{/w_matrix_tb/o_det_inv[39]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[38]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[37]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[36]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[35]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[34]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[33]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[32]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[31]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[30]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[29]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[28]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[27]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[26]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[25]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[24]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[23]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[22]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[21]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[20]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[19]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[18]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[17]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[16]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[15]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[14]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[13]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[12]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[11]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[10]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[9]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[8]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[7]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[6]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[5]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[4]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[3]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[2]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[1]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv[0]} {-height 15 -radix unsigned}} /w_matrix_tb/o_det_inv
add wave -noupdate -expand -group det_a_inv -color {Olive Drab} /w_matrix_tb/o_det_inv_inf
add wave -noupdate -expand -group det_a_inv -radix unsigned -childformat {{{/w_matrix_tb/o_det_inv_round[31]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[30]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[29]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[28]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[27]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[26]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[25]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[24]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[23]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[22]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[21]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[20]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[19]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[18]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[17]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[16]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[15]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[14]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[13]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[12]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[11]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[10]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[9]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[8]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[7]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[6]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[5]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[4]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[3]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[2]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[1]} -radix unsigned} {{/w_matrix_tb/o_det_inv_round[0]} -radix unsigned}} -expand -subitemconfig {{/w_matrix_tb/o_det_inv_round[31]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[30]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[29]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[28]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[27]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[26]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[25]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[24]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[23]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[22]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[21]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[20]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[19]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[18]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[17]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[16]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[15]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[14]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[13]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[12]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[11]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[10]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[9]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[8]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[7]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[6]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[5]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[4]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[3]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[2]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[1]} {-height 15 -radix unsigned} {/w_matrix_tb/o_det_inv_round[0]} {-height 15 -radix unsigned}} /w_matrix_tb/o_det_inv_round
add wave -noupdate -expand -group det_a_inv -color {Olive Drab} /w_matrix_tb/det_inv_fxp
add wave -noupdate /w_matrix_tb/o_sat_det_inv
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m11_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m11_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m12_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m12_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m21_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m21_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m22_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_m22_im
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m11_re_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m11_im_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m12_re_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m12_im_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m21_re_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m21_im_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m22_re_fxp
add wave -noupdate -group m_matrix -color Coral /w_matrix_tb/m22_im_fxp
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m11_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m11_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m12_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m12_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m21_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m21_im
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m22_re
add wave -noupdate -group m_matrix -color {Olive Drab} /w_matrix_tb/o_sat_m22_im
add wave -noupdate -group {output - w_matrix} /w_matrix_tb/o_stb
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w11_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w11_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w12_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w12_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w21_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w21_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w22_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_w22_im
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w11_re_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w11_im_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w12_re_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w12_im_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w21_re_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w21_im_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w22_re_fxp
add wave -noupdate -group {output - w_matrix} -color Coral /w_matrix_tb/w22_im_fxp
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w11_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w11_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w12_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w12_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w21_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w21_im
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w22_re
add wave -noupdate -group {output - w_matrix} -color Cyan /w_matrix_tb/o_sat_w22_im
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e11_re_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e11_im_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e12_re_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e12_im_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e21_re_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e21_im_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e22_re_fxp
add wave -noupdate -expand -group {unit matrix} -color Magenta /w_matrix_tb/e22_im_fxp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141 ns} 0}
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
WaveRestoreZoom {1 ns} {442 ns}
