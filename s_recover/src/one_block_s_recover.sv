`timescale 1ns / 1ps

module one_block_s_recover #(
    parameter int H_WIDTH = 8,
    parameter int A_WIDTH = 2 * H_WIDTH + 2,
    parameter int USE_DSP_VALUE = 1
)(
    input logic clk,
    input logic rst,
    input logic valid_cm3,

    input logic signed [H_WIDTH-1:0] i_w1_re,
    input logic signed [H_WIDTH-1:0] i_w1_im,
    input logic signed [H_WIDTH-1:0] i_w2_re,
    input logic signed [H_WIDTH-1:0] i_w2_im,

    input logic signed [H_WIDTH-1:0] i_s1_re,
    input logic signed [H_WIDTH-1:0] i_s1_im,
    input logic signed [H_WIDTH-1:0] i_s2_re,
    input logic signed [H_WIDTH-1:0] i_s2_im,

    output logic [A_WIDTH-1:0] o_s_re,
    output logic [A_WIDTH-1:0] o_s_im,

    output logic o_sat_re,
    output logic o_sat_im,

    output logic valid_sum
);

    localparam int CMULT_WIDTH = 2 * H_WIDTH + 1;
    localparam int SUM_WIDTH   = CMULT_WIDTH + 1;

    logic signed [CMULT_WIDTH-1:0] cmult1_re;
    logic signed [CMULT_WIDTH-1:0] cmult1_im;
    logic signed [CMULT_WIDTH-1:0] cmult2_re;
    logic signed [CMULT_WIDTH-1:0] cmult2_im;

    logic [SUM_WIDTH-1:0] sum_re;
    logic [SUM_WIDTH-1:0] sum_im;

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult1 (
        .clk(clk),
        .x0(i_w1_re),
        .y0(i_w1_im),
        .x1(i_s1_re),
        .y1(i_s1_im),
        .out_re(cmult1_re),
        .out_im(cmult1_im)
    );

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult2 (
        .clk(clk),
        .x0(i_w2_re),
        .y0(i_w2_im),
        .x1(i_s2_re),
        .y1(i_s2_im),
        .out_re(cmult2_re),
        .out_im(cmult2_im)
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_re (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(cmult1_re),
        .B(cmult2_re),
        .sub(1'b0),
        .valid_out(valid_sum),
        .S(sum_re),
        .underflow()
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_im (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(cmult1_im),
        .B(cmult2_im),
        .sub(1'b0),
        .valid_out(),
        .S(sum_im),
        .underflow()
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_re (
        .clk(clk),
        .i_data(sum_re),
        .o_data(o_s_re),
        .o_sat(o_sat_re)
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_im (
        .clk(clk),
        .i_data(sum_im),
        .o_data(o_s_im),
        .o_sat(o_sat_im)
    );

endmodule
