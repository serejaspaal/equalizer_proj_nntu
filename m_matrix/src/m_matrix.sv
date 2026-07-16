module m_matrix #(
    parameter int    A_WIDTH       = 16,
    parameter int    H_WIDTH       = 16,
    parameter int    ROUNDED_WIDTH = 16,
 //   parameter int A_SIGNED         = 0,
 //   parameter int SIGNED_RES       = 1,
 //   parameter int USE_DSP_VALUE    = 1,
    parameter string A_SIGNED         = "no",
    parameter string SIGNED_RES       = "yes",
    parameter string USE_DSP_VALUE    = "yes",
    localparam int   M_WIDTH       = A_WIDTH + H_WIDTH + 2
)(
    input  logic clk,
    input  logic rst,
    input  logic [H_WIDTH-1:0] i_h11_re, i_h11_im,
    input  logic [H_WIDTH-1:0] i_h12_re, i_h12_im,
    input  logic [H_WIDTH-1:0] i_h21_re, i_h21_im,
    input  logic [H_WIDTH-1:0] i_h22_re, i_h22_im,

    input  logic [A_WIDTH-1:0] i_a11, i_a22,
    input  logic [A_WIDTH-1:0] i_a12_re, i_a12_im,

//    output logic [ROUNDED_WIDTH-1:0] m11_re, m11_im,
//    output logic [ROUNDED_WIDTH-1:0] m12_re, m12_im,
//    output logic [ROUNDED_WIDTH-1:0] m21_re, m21_im,
//    output logic [ROUNDED_WIDTH-1:0] m22_re, m22_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m11_re, m11_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m12_re, m12_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m21_re, m21_im,
    output logic signed [A_WIDTH+H_WIDTH+1:0] m22_re, m22_im,

    output logic o_sat_m11_re, o_sat_m11_im,
    output logic o_sat_m12_re, o_sat_m12_im,
    output logic o_sat_m21_re, o_sat_m21_im,
    output logic o_sat_m22_re, o_sat_m22_im
);

    logic [H_WIDTH-1:0] h1_re [0:1], h1_im [0:1], h2_re [0:1], h2_im [0:1];
    logic [A_WIDTH+H_WIDTH+1:0] m_top_re [0:1], m_top_im [0:1];
    logic [A_WIDTH+H_WIDTH+1:0] m_bot_re [0:1], m_bot_im [0:1];

    logic sat_top_re [0:1], sat_top_im [0:1];
    logic sat_bot_re [0:1], sat_bot_im [0:1];

    assign h1_re = {i_h11_re, i_h21_re};
    assign h1_im = {i_h11_im, i_h21_im};
    assign h2_re = {i_h12_re, i_h22_re};
    assign h2_im = {i_h12_im, i_h22_im};

    generate
        for (genvar i = 0; i < 2; i++) begin : gen_matrix
            top_block_m_matrix #(
                .A_WIDTH (A_WIDTH),
                .H_WIDTH (H_WIDTH),
                .ROUNDED_WIDTH (ROUNDED_WIDTH),
                .A_SIGNED (A_SIGNED),
                .SIGNED_RES (SIGNED_RES),
                .USE_DSP_VALUE (USE_DSP_VALUE)
            ) inst_top_block (
                .clk(clk),
                .rst(rst),
                .i_h1_re (h1_re[i]),
                .i_h1_im (h1_im[i]),
                .i_h2_re (h2_re[i]),
                .i_h2_im (h2_im[i]),
                .i_a22 (i_a22),
                .i_a12_re (i_a12_re),
                .i_a12_im (i_a12_im),
                .m_re (m_top_re[i]),
                .m_im (m_top_im[i]),
                .o_sat_m_re (sat_top_re[i]),
                .o_sat_m_im (sat_top_im[i])
            );

            bot_block_m_matrix #(
                .A_WIDTH (A_WIDTH),
                .H_WIDTH (H_WIDTH),
                .ROUNDED_WIDTH (ROUNDED_WIDTH),
                .A_SIGNED (A_SIGNED),
                .SIGNED_RES (SIGNED_RES),
                .USE_DSP_VALUE (USE_DSP_VALUE)
            ) inst_bot_block (
                .clk(clk),
                .rst(rst),
                .i_h1_re (h1_re[i]),
                .i_h1_im (h1_im[i]),
                .i_h2_re (h2_re[i]),
                .i_h2_im (h2_im[i]),
                .i_a11 (i_a11),
                .i_a12_re (i_a12_re),
                .i_a12_im (i_a12_im),
                .m_re (m_bot_re[i]),
                .m_im (m_bot_im[i]),
                .o_sat_m_re (sat_bot_re[i]),
                .o_sat_m_im (sat_bot_im[i])
            );
        end
    endgenerate

    assign m11_re = m_top_re[0];
    assign m11_im = m_top_im[0];
    assign m12_re = m_top_re[1];
    assign m12_im = m_top_im[1];
    assign m21_re = m_bot_re[0];
    assign m21_im = m_bot_im[0];
    assign m22_re = m_bot_re[1];
    assign m22_im = m_bot_im[1];

    assign o_sat_m11_re = sat_top_re[0];
    assign o_sat_m11_im = sat_top_im[0];
    assign o_sat_m12_re = sat_top_re[1];
    assign o_sat_m12_im = sat_top_im[1];
    assign o_sat_m21_re = sat_bot_re[0];
    assign o_sat_m21_im = sat_bot_im[0];
    assign o_sat_m22_re = sat_bot_re[1];
    assign o_sat_m22_im = sat_bot_im[1];

endmodule
