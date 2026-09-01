onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_det_tb/clk
add wave -noupdate /a_det_tb/rst
add wave -noupdate -radix unsigned /a_det_tb/i_a11
add wave -noupdate -radix unsigned /a_det_tb/i_a22
add wave -noupdate -radix decimal /a_det_tb/i_a12_re
add wave -noupdate -radix decimal /a_det_tb/i_a12_im
add wave -noupdate -color Cyan -radix unsigned -childformat {{{/a_det_tb/o_det_a[31]} -radix unsigned} {{/a_det_tb/o_det_a[30]} -radix unsigned} {{/a_det_tb/o_det_a[29]} -radix unsigned} {{/a_det_tb/o_det_a[28]} -radix unsigned} {{/a_det_tb/o_det_a[27]} -radix unsigned} {{/a_det_tb/o_det_a[26]} -radix unsigned} {{/a_det_tb/o_det_a[25]} -radix unsigned} {{/a_det_tb/o_det_a[24]} -radix unsigned} {{/a_det_tb/o_det_a[23]} -radix unsigned} {{/a_det_tb/o_det_a[22]} -radix unsigned} {{/a_det_tb/o_det_a[21]} -radix unsigned} {{/a_det_tb/o_det_a[20]} -radix unsigned} {{/a_det_tb/o_det_a[19]} -radix unsigned} {{/a_det_tb/o_det_a[18]} -radix unsigned} {{/a_det_tb/o_det_a[17]} -radix unsigned} {{/a_det_tb/o_det_a[16]} -radix unsigned} {{/a_det_tb/o_det_a[15]} -radix unsigned} {{/a_det_tb/o_det_a[14]} -radix unsigned} {{/a_det_tb/o_det_a[13]} -radix unsigned} {{/a_det_tb/o_det_a[12]} -radix unsigned} {{/a_det_tb/o_det_a[11]} -radix unsigned} {{/a_det_tb/o_det_a[10]} -radix unsigned} {{/a_det_tb/o_det_a[9]} -radix unsigned} {{/a_det_tb/o_det_a[8]} -radix unsigned} {{/a_det_tb/o_det_a[7]} -radix unsigned} {{/a_det_tb/o_det_a[6]} -radix unsigned} {{/a_det_tb/o_det_a[5]} -radix unsigned} {{/a_det_tb/o_det_a[4]} -radix unsigned} {{/a_det_tb/o_det_a[3]} -radix unsigned} {{/a_det_tb/o_det_a[2]} -radix unsigned} {{/a_det_tb/o_det_a[1]} -radix unsigned} {{/a_det_tb/o_det_a[0]} -radix unsigned}} -subitemconfig {{/a_det_tb/o_det_a[31]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[30]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[29]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[28]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[27]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[26]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[25]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[24]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[23]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[22]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[21]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[20]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[19]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[18]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[17]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[16]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[15]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[14]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[13]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[12]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[11]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[10]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[9]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[8]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[7]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[6]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[5]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[4]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[3]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[2]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[1]} {-color Cyan -height 15 -radix unsigned} {/a_det_tb/o_det_a[0]} {-color Cyan -height 15 -radix unsigned}} /a_det_tb/o_det_a
add wave -noupdate -color Cyan /a_det_tb/o_sat_det
add wave -noupdate -color Red /a_det_tb/errors
add wave -noupdate /a_det_tb/o_sum_udf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44 ns} 0}
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
WaveRestoreZoom {6 ns} {604 ns}
