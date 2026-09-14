`timescale 1ns / 1ps

module one_block_matrix_mult #(
    parameter int    W_WIDTH       = 16,
    parameter int    S_WIDTH       = 16,
    parameter int    F_WIDTH       = W_WIDTH + S_WIDTH + 2,
    parameter int USE_DSP_VALUE    = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [W_WIDTH-1:0] i_w1_re, i_w1_im,
    input  logic signed [W_WIDTH-1:0] i_w2_re, i_w2_im,

    input  logic [S_WIDTH-1:0] i_s1_re, i_s1_im,
    input  logic [S_WIDTH-1:0] i_s2_re, i_s2_im,

    output logic [F_WIDTH-1:0] o_f_re, o_f_im,
    output logic o_sat_re, o_sat_im,

    output logic o_udf_f_re, o_udf_f_im
);
    logic sub = 0;

    logic signed [W_WIDTH+S_WIDTH:0] cmult1_re, cmult1_im;
    logic signed [W_WIDTH+S_WIDTH:0] cmult2_re, cmult2_im;


    logic [W_WIDTH+S_WIDTH+1:0] sum_re, sum_im;


    cmult #(
        .A_WIDTH ( W_WIDTH ),
        .B_WIDTH ( S_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult1 (
        .clk ( clk ),
        .x0 ( i_w1_re ),
        .y0 ( i_w1_im ),
        .x1 ( i_s1_re ),
        .y1 ( i_s1_im ),
        .out_re ( cmult1_re ),
        .out_im ( cmult1_im )
    );

    cmult #(
        .A_WIDTH ( W_WIDTH ),
        .B_WIDTH ( S_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult2 (
        .clk ( clk ),
        .x0 ( i_w2_re ),
        .y0 ( i_w2_im ),
        .x1 ( i_s2_re ),
        .y1 ( i_s2_im ),
        .out_re ( cmult2_re ),
        .out_im ( cmult2_im )
    );
//****************************************************************

    sum #(
        .A_WIDTH ( W_WIDTH+S_WIDTH+1 ),
        .B_WIDTH ( W_WIDTH+S_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_re ),
        .B ( cmult2_re ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_re ),
        .underflow ( o_udf_f_re )
    );
    sum #(
        .A_WIDTH ( W_WIDTH+S_WIDTH+1 ),
        .B_WIDTH ( W_WIDTH+S_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( cmult1_im ),
        .B ( cmult2_im ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_im ),
        .underflow ( o_udf_f_im )
    );


    round #(
        .IN_WIDTH ( W_WIDTH+S_WIDTH+2 ),
        .OUT_WIDTH ( F_WIDTH ),
        .IN_SIGNED ( 1 )
    ) inst_round_re (
        .clk ( clk ),
        .i_data ( sum_re ),
        .o_data ( o_f_re ),
        .o_sat ( o_sat_re )
    );

    round #(
        .IN_WIDTH ( W_WIDTH+S_WIDTH+2 ),
        .OUT_WIDTH ( F_WIDTH ),
        .IN_SIGNED ( 1 )
    ) inst_round_im (
        .clk ( clk ),
        .i_data ( sum_im ),
        .o_data ( o_f_im ),
        .o_sat ( o_sat_im )
    );

endmodule
