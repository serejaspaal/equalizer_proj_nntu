`timescale 1ns / 1ps

module s_recover #(
    parameter int H_WIDTH       = 8,
    parameter int A_WIDTH       = 2 * H_WIDTH + 2,
    parameter int USE_DSP_VALUE = 1
)(
    input logic clk,
    input logic rst,
    input logic valid_in,

    input logic signed [H_WIDTH-1:0] i_w11_re,
    input logic signed [H_WIDTH-1:0] i_w11_im,

    input logic signed [H_WIDTH-1:0] i_w12_re,
    input logic signed [H_WIDTH-1:0] i_w12_im,

    input logic signed [H_WIDTH-1:0] i_w21_re,
    input logic signed [H_WIDTH-1:0] i_w21_im,

    input logic signed [H_WIDTH-1:0] i_w22_re,
    input logic signed [H_WIDTH-1:0] i_w22_im,

    input logic signed [H_WIDTH-1:0] i_s11_re,
    input logic signed [H_WIDTH-1:0] i_s11_im,

    input logic signed [H_WIDTH-1:0] i_s21_re,
    input logic signed [H_WIDTH-1:0] i_s21_im,

    output logic [A_WIDTH-1:0] o_s11_re,
    output logic [A_WIDTH-1:0] o_s11_im,

    output logic o_sat_s11_re,
    output logic o_sat_s11_im,

    output logic [A_WIDTH-1:0] o_s21_re,
    output logic [A_WIDTH-1:0] o_s21_im,

    output logic o_sat_s21_re,
    output logic o_sat_s21_im,

    output logic valid_out
);

    localparam int CMULT_WIDTH = 2 * H_WIDTH + 1;
    localparam int SUM_WIDTH   = CMULT_WIDTH + 1;

    logic signed [CMULT_WIDTH-1:0] s11_mult_re [1:0];
    logic signed [CMULT_WIDTH-1:0] s11_mult_im [1:0];

    logic signed [CMULT_WIDTH-1:0] s21_mult_re [1:0];
    logic signed [CMULT_WIDTH-1:0] s21_mult_im [1:0];

    logic [SUM_WIDTH-1:0] s11_sum_re;
    logic [SUM_WIDTH-1:0] s11_sum_im;

    logic [SUM_WIDTH-1:0] s21_sum_re;
    logic [SUM_WIDTH-1:0] s21_sum_im;

    logic valid_cm3;
    logic valid_sum;

    logic [A_WIDTH-1:0] s11_round_re;
    logic [A_WIDTH-1:0] s11_round_im;

    logic [A_WIDTH-1:0] s21_round_re;
    logic [A_WIDTH-1:0] s21_round_im;

    logic sat_s11_re;
    logic sat_s11_im;

    logic sat_s21_re;
    logic sat_s21_im;

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_s11_1 (
        .clk(clk),
        .x0(i_w11_re),
        .y0(i_w11_im),
        .x1(i_s11_re),
        .y1(i_s11_im),
        .out_re(s11_mult_re[0]),
        .out_im(s11_mult_im[0])
    );

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_s11_2 (
        .clk(clk),
        .x0(i_w12_re),
        .y0(i_w12_im),
        .x1(i_s21_re),
        .y1(i_s21_im),
        .out_re(s11_mult_re[1]),
        .out_im(s11_mult_im[1])
    );

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_s21_1 (
        .clk(clk),
        .x0(i_w21_re),
        .y0(i_w21_im),
        .x1(i_s11_re),
        .y1(i_s11_im),
        .out_re(s21_mult_re[0]),
        .out_im(s21_mult_im[0])
    );

    cmult #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_s21_2 (
        .clk(clk),
        .x0(i_w22_re),
        .y0(i_w22_im),
        .x1(i_s21_re),
        .y1(i_s21_im),
        .out_re(s21_mult_re[1]),
        .out_im(s21_mult_im[1])
    );

    dline #(
        .DATA_WIDTH(1),
        .DELAY(3)
    ) inst_valid_cm3 (
        .i_clk(clk),
        .i_data(valid_in),
        .o_data(valid_cm3)
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_s11_re (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(s11_mult_re[0]),
        .B(s11_mult_re[1]),
        .sub(1'b0),
        .valid_out(valid_sum),
        .S(s11_sum_re),
        .underflow()
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_s11_im (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(s11_mult_im[0]),
        .B(s11_mult_im[1]),
        .sub(1'b0),
        .valid_out(),
        .S(s11_sum_im),
        .underflow()
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_s21_re (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(s21_mult_re[0]),
        .B(s21_mult_re[1]),
        .sub(1'b0),
        .valid_out(),
        .S(s21_sum_re),
        .underflow()
    );

    sum #(
        .A_WIDTH(CMULT_WIDTH),
        .B_WIDTH(CMULT_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE),
        .SIGNED_OPERANDS(1)
    ) inst_sum_s21_im (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_cm3),
        .A(s21_mult_im[0]),
        .B(s21_mult_im[1]),
        .sub(1'b0),
        .valid_out(),
        .S(s21_sum_im),
        .underflow()
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_s11_re (
        .clk(clk),
        .i_data(s11_sum_re),
        .o_data(s11_round_re),
        .o_sat(sat_s11_re)
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_s11_im (
        .clk(clk),
        .i_data(s11_sum_im),
        .o_data(s11_round_im),
        .o_sat(sat_s11_im)
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_s21_re (
        .clk(clk),
        .i_data(s21_sum_re),
        .o_data(s21_round_re),
        .o_sat(sat_s21_re)
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_s21_im (
        .clk(clk),
        .i_data(s21_sum_im),
        .o_data(s21_round_im),
        .o_sat(sat_s21_im)
    );

    dline #(
        .DATA_WIDTH(1),
        .DELAY(1)
    ) inst_valid_out (
        .i_clk(clk),
        .i_data(valid_sum),
        .o_data(valid_out)
    );

    always_comb begin
        o_s11_re = s11_round_re;
        o_s11_im = s11_round_im;
        o_sat_s11_re = sat_s11_re;
        o_sat_s11_im = sat_s11_im;

        o_s21_re = s21_round_re;
        o_s21_im = s21_round_im;
        o_sat_s21_re = sat_s21_re;
        o_sat_s21_im = sat_s21_im;
    end

endmodule