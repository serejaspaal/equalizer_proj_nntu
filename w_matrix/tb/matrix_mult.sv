module matrix_mult #(
    parameter int A_WIDTH       = 16,
    parameter int W_WIDTH       = 66,
    parameter int E_WIDTH       = A_WIDTH + W_WIDTH + 2,
    parameter int FRAC_WIDTH    = 8,
    parameter int USE_DSP_VALUE = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [W_WIDTH-1:0] i_w11_re, i_w11_im,
    input  logic signed [W_WIDTH-1:0] i_w12_re, i_w12_im,
    input  logic signed [W_WIDTH-1:0] i_w21_re, i_w21_im,
    input  logic signed [W_WIDTH-1:0] i_w22_re, i_w22_im,

    input  logic [A_WIDTH-1:0] i_a11, i_a22,
    input  logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im,


    output logic signed [E_WIDTH-1:0] o_e11_re, o_e11_im,
    output logic signed [E_WIDTH-1:0] o_e12_re, o_e12_im,
    output logic signed [E_WIDTH-1:0] o_e21_re, o_e21_im,
    output logic signed [E_WIDTH-1:0] o_e22_re, o_e22_im
);

logic signed [1:0][W_WIDTH-1:0] w1_re, w1_im, w2_re, w2_im;
logic signed [1:0][E_WIDTH-1:0] e_top_re, e_top_im, e_bot_re, e_bot_im;
logic [1:0] sat_top_re, sat_top_im, sat_bot_re, sat_bot_im;

assign w1_re = {i_w21_re, i_w11_re};
assign w1_im = {i_w21_im, i_w11_im};
assign w2_re = {i_w22_re, i_w12_re};
assign w2_im = {i_w22_im, i_w12_im};

generate
    for (genvar i = 0; i < 2; i++) begin : gen_matrix
        top_block_mult_matrix #(
            .A_WIDTH (A_WIDTH),
            .W_WIDTH (W_WIDTH),
            .E_WIDTH (E_WIDTH),
            .USE_DSP_VALUE (USE_DSP_VALUE)
        ) inst_top_block (
            .clk(clk),
            .rst(rst),
            .i_w1_re (w1_re[i]),
            .i_w1_im (w1_im[i]),
            .i_w2_re (w2_re[i]),
            .i_w2_im (w2_im[i]),
            .i_a11 (i_a11),
            .i_a12_re (i_a12_re),
            .i_a12_im (i_a12_im),
            .e_re (e_top_re[i]),
            .e_im (e_top_im[i]),
            .o_sat_e_re (sat_top_re[i]),
            .o_sat_e_im (sat_top_im[i])
        );

        bot_block_mult_matrix #(
            .A_WIDTH (A_WIDTH),
            .W_WIDTH (W_WIDTH),
            .E_WIDTH (E_WIDTH),
            .USE_DSP_VALUE (USE_DSP_VALUE)
        ) inst_bot_block (
            .clk(clk),
            .rst(rst),
            .i_w1_re (w1_re[i]),
            .i_w1_im (w1_im[i]),
            .i_w2_re (w2_re[i]),
            .i_w2_im (w2_im[i]),
            .i_a22 (i_a22),
            .i_a12_re (i_a12_re),
            .i_a12_im (i_a12_im),
            .e_re (e_bot_re[i]),
            .e_im (e_bot_im[i]),
            .o_sat_e_re (sat_bot_re[i]),
            .o_sat_e_im (sat_bot_im[i])
        );
    end
endgenerate

assign o_e11_re = e_top_re[0];
assign o_e11_im = e_top_im[0];
assign o_e12_re = e_top_re[1];
assign o_e12_im = e_top_im[1];
assign o_e21_re = e_bot_re[0];
assign o_e21_im = e_bot_im[0];
assign o_e22_re = e_bot_re[1];
assign o_e22_im = e_bot_im[1];

assign o_sat_e11_re = sat_top_re[0];
assign o_sat_e11_im = sat_top_im[0];
assign o_sat_e12_re = sat_top_re[1];
assign o_sat_e12_im = sat_top_im[1];
assign o_sat_e21_re = sat_bot_re[0];
assign o_sat_e21_im = sat_bot_im[0];
assign o_sat_e22_re = sat_bot_re[1];
assign o_sat_e22_im = sat_bot_im[1];

endmodule
