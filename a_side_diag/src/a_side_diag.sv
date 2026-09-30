`timescale 1ns / 1ps

module a_side_diag #(
    parameter int H_WIDTH = 8,
    parameter int A_WIDTH = 2 * H_WIDTH + 2,
    parameter int USE_DSP_VALUE = 1
)(
    input logic clk,
    input logic rst,
    input logic valid_in,

    input logic signed [H_WIDTH-1:0] i_h11_re,
    input logic signed [H_WIDTH-1:0] i_h11_im,

    input logic signed [H_WIDTH-1:0] i_h12_re,
    input logic signed [H_WIDTH-1:0] i_h12_im,

    input logic signed [H_WIDTH-1:0] i_h21_re,
    input logic signed [H_WIDTH-1:0] i_h21_im,

    input logic signed [H_WIDTH-1:0] i_h22_re,
    input logic signed [H_WIDTH-1:0] i_h22_im,

    output logic [A_WIDTH-1:0] o_a12_re,
    output logic [A_WIDTH-1:0] o_a12_im,

    output logic o_sat_a12_re,
    output logic o_sat_a12_im,

    output logic valid_out
);

    localparam int CMULT_WIDTH = 2 * H_WIDTH + 1;
    localparam int SUM_WIDTH   = CMULT_WIDTH + 1;

    logic signed [CMULT_WIDTH-1:0] cmult_re [1:0];
    logic signed [CMULT_WIDTH-1:0] cmult_im [1:0];

    logic [SUM_WIDTH-1:0] sum_re;
    logic [SUM_WIDTH-1:0] sum_im;

    logic valid_cm1;
    logic valid_cm2;
    logic valid_cm3;

    logic valid_sum_re;
    logic valid_sum_im;

    logic [A_WIDTH-1:0] round_re;
    logic [A_WIDTH-1:0] round_im;

    logic sat_re;
    logic sat_im;

    cmult_b_coupl #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_re_im_1 (
        .clk(clk),

        .x0(i_h11_re),
        .y0(i_h11_im),

        .x1(i_h21_re),
        .y1(i_h21_im),

        .out_re(cmult_re[0]),
        .out_im(cmult_im[0])
    );

    cmult_b_coupl #(
        .A_WIDTH(H_WIDTH),
        .B_WIDTH(H_WIDTH),
        .USE_DSP_VALUE(USE_DSP_VALUE)
    ) inst_cmult_re_im_2 (
        .clk(clk),

        .x0(i_h12_re),
        .y0(i_h12_im),

        .x1(i_h22_re),
        .y1(i_h22_im),

        .out_re(cmult_re[1]),
        .out_im(cmult_im[1])
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

        .A(cmult_re[0]),
        .B(cmult_re[1]),
        .sub(1'b0),

        .valid_out(valid_sum_re),
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

        .A(cmult_im[0]),
        .B(cmult_im[1]),
        .sub(1'b0),

        .valid_out(valid_sum_im),
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
        .o_data(round_re),
        .o_sat(sat_re)
    );

    round #(
        .IN_WIDTH(SUM_WIDTH),
        .OUT_WIDTH(A_WIDTH),
        .IN_SIGNED(1),
        .CLIP_WIDTH(0)
    ) inst_round_im (
        .clk(clk),
        .i_data(sum_im),
        .o_data(round_im),
        .o_sat(sat_im)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            valid_cm1 <= 1'b0;
            valid_cm2 <= 1'b0;
            valid_cm3 <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            valid_cm1 <= valid_in;
            valid_cm2 <= valid_cm1;
            valid_cm3 <= valid_cm2;

            valid_out <= valid_sum_re;
        end
    end

    always_comb begin
        o_a12_re = round_re;
        o_a12_im = round_im;

        o_sat_a12_re = sat_re;
        o_sat_a12_im = sat_im;
    end

endmodule