`timescale 1ns / 1ps

module matrix_mult #(
    parameter int W_WIDTH       = 16,
    parameter int S_WIDTH       = 66,
    parameter int F_WIDTH       = W_WIDTH + S_WIDTH + 1,
    parameter int FRAC_WIDTH    = 8,
    parameter int USE_DSP_VALUE = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [W_WIDTH-1:0] i_w11_re, i_w11_im,
    input  logic signed [W_WIDTH-1:0] i_w12_re, i_w12_im,
    input  logic signed [W_WIDTH-1:0] i_w21_re, i_w21_im,
    input  logic signed [W_WIDTH-1:0] i_w22_re, i_w22_im,

    input  logic signed [S_WIDTH-1:0] i_s11_re, i_s11_im,
    input  logic signed [S_WIDTH-1:0] i_s12_re, i_s12_im,
    input  logic signed [S_WIDTH-1:0] i_s21_re, i_s21_im,
    input  logic signed [S_WIDTH-1:0] i_s22_re, i_s22_im,

    output logic signed [F_WIDTH-1:0] o_f11_re, o_f11_im,
    output logic signed [F_WIDTH-1:0] o_f12_re, o_f12_im,
    output logic signed [F_WIDTH-1:0] o_f21_re, o_f21_im,
    output logic signed [F_WIDTH-1:0] o_f22_re, o_f22_im,

    output logic o_sat11_re, o_sat11_im,
    output logic o_sat12_re, o_sat12_im,
    output logic o_sat21_re, o_sat21_im,
    output logic o_sat22_re, o_sat22_im,

    output logic o_udf11_re, o_udf11_im,
    output logic o_udf12_re, o_udf12_im,
    output logic o_udf21_re, o_udf21_im,
    output logic o_udf22_re, o_udf22_im
);

logic signed [3:0][W_WIDTH-1:0] w1_re, w1_im, w2_re, w2_im;
logic signed [3:0][S_WIDTH-1:0] s1_re, s1_im, s2_re, s2_im;
logic signed [3:0][F_WIDTH-1:0] f_re, f_im;
logic [3:0] sat_re, sat_im;
logic [3:0] udf_re, udf_im;

assign w1_re = {i_w11_re, i_w21_re, i_w11_re, i_w21_re};
assign w1_im = {i_w11_im, i_w21_im, i_w11_im, i_w21_im};
assign w2_re = {i_w12_re, i_w22_re, i_w12_re, i_w22_re};
assign w2_im = {i_w12_im, i_w22_im, i_w12_im, i_w22_im};

assign s1_re = {i_s11_re, i_s11_re, i_s12_re, i_s12_re};
assign s1_im = {i_s11_im, i_s11_im, i_s12_im, i_s12_im};
assign s2_re = {i_s21_re, i_s21_re, i_s22_re, i_s22_re};
assign s2_im = {i_s21_im, i_s21_im, i_s22_im, i_s22_im};

generate
    for (genvar i = 0; i < 4; i++) begin : gen_matrix
        one_block_matrix_mult #(
           	.W_WIDTH      (W_WIDTH),
           	.S_WIDTH      (S_WIDTH),
           	.F_WIDTH      (F_WIDTH),
           	.USE_DSP_VALUE(USE_DSP_VALUE)
         ) inst_one_block_matrix_mult (
           	.clk       (clk),
           	.rst       (rst),
           	.i_w1_re   (w1_re[i]),
           	.i_w1_im   (w1_im[i]),
           	.i_w2_re   (w2_re[i]),
           	.i_w2_im   (w2_im[i]),
           	.i_s1_re   (s1_re[i]),
           	.i_s1_im   (s1_im[i]),
           	.i_s2_re   (s2_re[i]),
           	.i_s2_im   (s2_im[i]),
           	.o_f_re    (f_re[i]),
           	.o_f_im    (f_im[i]),
           	.o_sat_re  (sat_re[i]),
           	.o_sat_im  (sat_im[i]),
           	.o_udf_f_re(udf_re[i]),
           	.o_udf_f_im(udf_im[i])
        );
    end
endgenerate

assign o_f11_re = f_re[3];
assign o_f11_im = f_im[3];
assign o_f12_re = f_re[1];
assign o_f12_im = f_im[1];
assign o_f21_re = f_re[2];
assign o_f21_im = f_im[2];
assign o_f22_re = f_re[0];
assign o_f22_im = f_im[0];

assign o_udf11_re = udf_re[3];
assign o_udf11_im = udf_im[3];
assign o_udf12_re = udf_re[1];
assign o_udf12_im = udf_im[1];
assign o_udf21_re = udf_re[2];
assign o_udf21_im = udf_im[2];
assign o_udf22_re = udf_re[0];
assign o_udf22_im = udf_im[0];

assign o_sat11_re = sat_re[3];
assign o_sat11_im = sat_im[3];
assign o_sat12_re = sat_re[1];
assign o_sat12_im = sat_im[1];
assign o_sat21_re = sat_re[2];
assign o_sat21_im = sat_im[2];
assign o_sat22_re = sat_re[0];
assign o_sat22_im = sat_im[0];

endmodule
