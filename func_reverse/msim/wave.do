onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /func_reverse_tb/clk
add wave -noupdate -radix unsigned -childformat {{{/func_reverse_tb/x[31]} -radix unsigned} {{/func_reverse_tb/x[30]} -radix unsigned} {{/func_reverse_tb/x[29]} -radix unsigned} {{/func_reverse_tb/x[28]} -radix unsigned} {{/func_reverse_tb/x[27]} -radix unsigned} {{/func_reverse_tb/x[26]} -radix unsigned} {{/func_reverse_tb/x[25]} -radix unsigned} {{/func_reverse_tb/x[24]} -radix unsigned} {{/func_reverse_tb/x[23]} -radix unsigned} {{/func_reverse_tb/x[22]} -radix unsigned} {{/func_reverse_tb/x[21]} -radix unsigned} {{/func_reverse_tb/x[20]} -radix unsigned} {{/func_reverse_tb/x[19]} -radix unsigned} {{/func_reverse_tb/x[18]} -radix unsigned} {{/func_reverse_tb/x[17]} -radix unsigned} {{/func_reverse_tb/x[16]} -radix unsigned} {{/func_reverse_tb/x[15]} -radix unsigned} {{/func_reverse_tb/x[14]} -radix unsigned} {{/func_reverse_tb/x[13]} -radix unsigned} {{/func_reverse_tb/x[12]} -radix unsigned} {{/func_reverse_tb/x[11]} -radix unsigned} {{/func_reverse_tb/x[10]} -radix unsigned} {{/func_reverse_tb/x[9]} -radix unsigned} {{/func_reverse_tb/x[8]} -radix unsigned} {{/func_reverse_tb/x[7]} -radix unsigned} {{/func_reverse_tb/x[6]} -radix unsigned} {{/func_reverse_tb/x[5]} -radix unsigned} {{/func_reverse_tb/x[4]} -radix unsigned} {{/func_reverse_tb/x[3]} -radix unsigned} {{/func_reverse_tb/x[2]} -radix unsigned} {{/func_reverse_tb/x[1]} -radix unsigned} {{/func_reverse_tb/x[0]} -radix unsigned}} -subitemconfig {{/func_reverse_tb/x[31]} {-height 15 -radix unsigned} {/func_reverse_tb/x[30]} {-height 15 -radix unsigned} {/func_reverse_tb/x[29]} {-height 15 -radix unsigned} {/func_reverse_tb/x[28]} {-height 15 -radix unsigned} {/func_reverse_tb/x[27]} {-height 15 -radix unsigned} {/func_reverse_tb/x[26]} {-height 15 -radix unsigned} {/func_reverse_tb/x[25]} {-height 15 -radix unsigned} {/func_reverse_tb/x[24]} {-height 15 -radix unsigned} {/func_reverse_tb/x[23]} {-height 15 -radix unsigned} {/func_reverse_tb/x[22]} {-height 15 -radix unsigned} {/func_reverse_tb/x[21]} {-height 15 -radix unsigned} {/func_reverse_tb/x[20]} {-height 15 -radix unsigned} {/func_reverse_tb/x[19]} {-height 15 -radix unsigned} {/func_reverse_tb/x[18]} {-height 15 -radix unsigned} {/func_reverse_tb/x[17]} {-height 15 -radix unsigned} {/func_reverse_tb/x[16]} {-height 15 -radix unsigned} {/func_reverse_tb/x[15]} {-height 15 -radix unsigned} {/func_reverse_tb/x[14]} {-height 15 -radix unsigned} {/func_reverse_tb/x[13]} {-height 15 -radix unsigned} {/func_reverse_tb/x[12]} {-height 15 -radix unsigned} {/func_reverse_tb/x[11]} {-height 15 -radix unsigned} {/func_reverse_tb/x[10]} {-height 15 -radix unsigned} {/func_reverse_tb/x[9]} {-height 15 -radix unsigned} {/func_reverse_tb/x[8]} {-height 15 -radix unsigned} {/func_reverse_tb/x[7]} {-height 15 -radix unsigned} {/func_reverse_tb/x[6]} {-height 15 -radix unsigned} {/func_reverse_tb/x[5]} {-height 15 -radix unsigned} {/func_reverse_tb/x[4]} {-height 15 -radix unsigned} {/func_reverse_tb/x[3]} {-height 15 -radix unsigned} {/func_reverse_tb/x[2]} {-height 15 -radix unsigned} {/func_reverse_tb/x[1]} {-height 15 -radix unsigned} {/func_reverse_tb/x[0]} {-height 15 -radix unsigned}} /func_reverse_tb/x
add wave -noupdate /func_reverse_tb/x_fxp
add wave -noupdate /func_reverse_tb/o_inf_off
add wave -noupdate -radix unsigned /func_reverse_tb/o_result_off
add wave -noupdate /func_reverse_tb/result_fxp_off
add wave -noupdate /func_reverse_tb/o_inf_on
add wave -noupdate -radix unsigned /func_reverse_tb/o_result_on
add wave -noupdate /func_reverse_tb/result_fxp_on
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1891 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
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
WaveRestoreZoom {0 ns} {2100 ns}
