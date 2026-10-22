`timescale 1ns / 1ps

module s_recover #(
    parameter int H_WIDTH = 8,
    parameter int A_WIDTH = 2 * H_WIDTH + 2,
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

    logic valid_cm3;
    logic valid_sum_s11;

    dline #(
        .DATA_WIDTH(1),
        .DELAY(3)
    ) inst_valid_cm3 (
        .i_clk(clk),
        .i_data(valid_in),
        .o_data(valid_cm3)
    );

    one_block_s_recover #(
        .H_WIDTH(H_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_s11 (
        .clk(clk),
        .rst(rst),
        .valid_cm3(valid_cm3),

        .i_w1_re(i_w11_re),
        .i_w1_im(i_w11_im),
        .i_w2_re(i_w12_re),
        .i_w2_im(i_w12_im),

        .i_s1_re(i_s11_re),
        .i_s1_im(i_s11_im),
        .i_s2_re(i_s21_re),
        .i_s2_im(i_s21_im),

        .o_s_re(o_s11_re),
        .o_s_im(o_s11_im),
        .o_sat_re(o_sat_s11_re),
        .o_sat_im(o_sat_s11_im),

        .valid_sum(valid_sum_s11)
    );

    one_block_s_recover #(
        .H_WIDTH(H_WIDTH),
        .A_WIDTH(A_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_s21 (
        .clk(clk),
        .rst(rst),
        .valid_cm3(valid_cm3),

        .i_w1_re(i_w21_re),
        .i_w1_im(i_w21_im),
        .i_w2_re(i_w22_re),
        .i_w2_im(i_w22_im),

        .i_s1_re(i_s11_re),
        .i_s1_im(i_s11_im),
        .i_s2_re(i_s21_re),
        .i_s2_im(i_s21_im),

        .o_s_re(o_s21_re),
        .o_s_im(o_s21_im),
        .o_sat_re(o_sat_s21_re),
        .o_sat_im(o_sat_s21_im),

        .valid_sum()
    );

    dline #(
        .DATA_WIDTH(1),
        .DELAY(1)
    ) inst_valid_out (
        .i_clk(clk),
        .i_data(valid_sum_s11),
        .o_data(valid_out)
    );

endmodule
