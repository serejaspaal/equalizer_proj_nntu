module w_matrix #(
    parameter int A_WIDTH       = 16,
    parameter int H_WIDTH       = 16,
    parameter int M_WIDTH       = A_WIDTH + H_WIDTH + 2,
    parameter int DET_WIDTH     = 2*A_WIDTH,
    parameter int FRAC_WIDTH    = 16,
    parameter int W_WIDTH       = DET_WIDTH + M_WIDTH,
    //parameter int W_WIDTH       = 18 + M_WIDTH,
    parameter int USE_DSP_VALUE = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [H_WIDTH-1:0] i_h11_re, i_h11_im,
    input  logic signed [H_WIDTH-1:0] i_h12_re, i_h12_im,
    input  logic signed [H_WIDTH-1:0] i_h21_re, i_h21_im,
    input  logic signed [H_WIDTH-1:0] i_h22_re, i_h22_im,

    input  logic [A_WIDTH-1:0] i_a11, i_a22,
    input  logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im,

    output logic signed [W_WIDTH-1:0] w11_re, w11_im,
    output logic signed [W_WIDTH-1:0] w12_re, w12_im,
    output logic signed [W_WIDTH-1:0] w21_re, w21_im,
    output logic signed [W_WIDTH-1:0] w22_re, w22_im,

    output logic o_sat_w11_re, o_sat_w11_im,
    output logic o_sat_w12_re, o_sat_w12_im,
    output logic o_sat_w21_re, o_sat_w21_im,
    output logic o_sat_w22_re, o_sat_w22_im,

    output logic [DET_WIDTH-1:0] det_a,
    output logic sat_det,
    output logic underflow_det,

    output logic signed [M_WIDTH-1:0] m11_re, m11_im,
    output logic signed [M_WIDTH-1:0] m12_re, m12_im,
    output logic signed [M_WIDTH-1:0] m21_re, m21_im,
    output logic signed [M_WIDTH-1:0] m22_re, m22_im,
    output logic o_sat_m11_re, o_sat_m11_im,
    output logic o_sat_m12_re, o_sat_m12_im,
    output logic o_sat_m21_re, o_sat_m21_im,
    output logic o_sat_m22_re, o_sat_m22_im,

    output logic [DET_WIDTH-1:0] det_inv,
    //output logic [18-1:0] det_inv,
    output logic inf_func_reverse

);
//    logic [DET_WIDTH-1:0] det_a;
//    logic sat_det;
//    logic underflow_det;
//
//    logic signed [M_WIDTH-1:0] m11_re, m11_im;
//    logic signed [M_WIDTH-1:0] m12_re, m12_im;
//    logic signed [M_WIDTH-1:0] m21_re, m21_im;
//    logic signed [M_WIDTH-1:0] m22_re, m22_im;
//    logic o_sat_m11_re, o_sat_m11_im;
//    logic o_sat_m12_re, o_sat_m12_im;
//    logic o_sat_m21_re, o_sat_m21_im;
//    logic o_sat_m22_re, o_sat_m22_im;
//
//    logic [DET_WIDTH-1:0] det_inv;
//    logic inf_func_reverse;


    a_det #(//4 takt
        .A_WIDTH (A_WIDTH),
        .DET_WIDTH (DET_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE)
    ) inst_a_det (
        .clk (clk),
        .rst (rst),
        .i_a11 (i_a11),
        .i_a22 (i_a22),
        .i_a12_re (i_a12_re),
        .i_a12_im (i_a12_im),
        .o_det_a (det_a),
        .o_sat_det (sat_det),
        .sum_underflow (underflow_det)
    );

    func_reverse #( //8 takt
        .IN_WIDTH (DET_WIDTH),
        .FRAC_WIDTH (FRAC_WIDTH),
        .OUT_WIDTH (DET_WIDTH)
        //.OUT_WIDTH (18)
    ) inst_func_reverse (
        .i_clk (clk),
        .i_x (det_a),
        .o_result (det_inv),
        .o_inf (inf_func_reverse)
    );

    m_matrix #(//5 takt
        .A_WIDTH (A_WIDTH),
        .H_WIDTH (H_WIDTH),
        .M_WIDTH (M_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE)
    ) inst_m_matrix (
        .clk (clk),
        .rst (rst),
        .i_h11_re (i_h11_re),
        .i_h11_im (i_h11_im),
        .i_h12_re (i_h12_re),
        .i_h12_im (i_h12_im),
        .i_h21_re (i_h21_re),
        .i_h21_im (i_h21_im),
        .i_h22_re (i_h22_re),
        .i_h22_im (i_h22_im),
        .i_a11    (i_a11),
        .i_a22    (i_a22),
        .i_a12_re (i_a12_re),
        .i_a12_im (i_a12_im),
        .m11_re (m11_re),
        .m11_im (m11_im),
        .m12_re (m12_re),
        .m12_im (m12_im),
        .m21_re (m21_re),
        .m21_im (m21_im),
        .m22_re (m22_re),
        .m22_im (m22_im),
        .o_sat_m11_re (o_sat_m11_re),
        .o_sat_m11_im (o_sat_m11_im),
        .o_sat_m12_re (o_sat_m12_re),
        .o_sat_m12_im (o_sat_m12_im),
        .o_sat_m21_re (o_sat_m21_re),
        .o_sat_m21_im (o_sat_m21_im),
        .o_sat_m22_re (o_sat_m22_re),
        .o_sat_m22_im (o_sat_m22_im)
    );

    logic [8:0][M_WIDTH-1:0] dline_m;
    logic [8:0][M_WIDTH-1:0] o_dline_m;
    assign dline_m = {m11_re, m11_im, m12_re, m12_im, m21_re, m21_im, m22_re, m22_im};
    logic [M_WIDTH-1:0] dline_m11_re, dline_m11_im;
    logic [M_WIDTH-1:0] dline_m12_re, dline_m12_im;
    logic [M_WIDTH-1:0] dline_m21_re, dline_m21_im;
    logic [M_WIDTH-1:0] dline_m22_re, dline_m22_im;

    generate
        for (genvar i = 0; i < 8; i++) begin : gen_dline
            dline #(
                .DATA_WIDTH (M_WIDTH),
                .DELAY (3)
            ) inst_dline (
                .i_clk (clk),
                .i_data (dline_m[i]),
                .o_data (o_dline_m[i])
            );
        end
    endgenerate
    assign {dline_m11_re, dline_m11_im, dline_m12_re, dline_m12_im, dline_m21_re, dline_m21_im, dline_m22_re, dline_m22_im} = o_dline_m;


    cmult_matrix_on_real #( //10 takt
        .DET_WIDTH (DET_WIDTH),
        //.DET_WIDTH (18),
        .M_WIDTH (M_WIDTH),
        .W_WIDTH (W_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE)
    ) inst_cmult_matrix_on_real (
        .clk (clk),
        .det_inv (det_inv),
        .i_m11_re (dline_m11_re),
        .i_m11_im (dline_m11_im),
        .i_m12_re (dline_m12_re),
        .i_m12_im (dline_m12_im),
        .i_m21_re (dline_m21_re),
        .i_m21_im (dline_m21_im),
        .i_m22_re (dline_m22_re),
        .i_m22_im (dline_m22_im),
        .o_w11_re (w11_re),
        .o_w11_im (w11_im),
        .o_w12_re (w12_re),
        .o_w12_im (w12_im),
        .o_w21_re (w21_re),
        .o_w21_im (w21_im),
        .o_w22_re (w22_re),
        .o_w22_im (w22_im),
        .o_sat_w11_re (o_sat_w11_re),
        .o_sat_w11_im (o_sat_w11_im),
        .o_sat_w12_re (o_sat_w12_re),
        .o_sat_w12_im (o_sat_w12_im),
        .o_sat_w21_re (o_sat_w21_re),
        .o_sat_w21_im (o_sat_w21_im),
        .o_sat_w22_re (o_sat_w22_re),
        .o_sat_w22_im (o_sat_w22_im)
    );

endmodule
