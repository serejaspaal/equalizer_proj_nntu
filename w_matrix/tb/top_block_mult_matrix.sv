module top_block_mult_matrix #(
    parameter int    A_WIDTH       = 16,
    parameter int    W_WIDTH       = 16,
    parameter int    E_WIDTH       = A_WIDTH + W_WIDTH + 2,
    parameter int USE_DSP_VALUE    = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [W_WIDTH-1:0] i_w1_re, i_w1_im,
    input  logic signed [W_WIDTH-1:0] i_w2_re, i_w2_im,

    input  logic [A_WIDTH-1:0] i_a11,
    input  logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im,


    output logic signed [E_WIDTH-1:0] e_re, e_im,

    output logic o_sat_e_re, o_sat_e_im
);
    logic sub = 0;

    logic signed [A_WIDTH+W_WIDTH-1:0] cmult1_e_re, cmult1_e_im;
    logic signed [A_WIDTH+W_WIDTH-1:0] dline_e_re, dline_e_im;

    logic signed [A_WIDTH+W_WIDTH:0] cmult2_e_re, cmult2_e_im;


    logic signed [A_WIDTH+W_WIDTH+1:0] sum_e_re, sum_e_im;


    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( W_WIDTH ),
        .A_SIGNED ( 0 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult_a_real_b_coupl (
        .clk ( clk ),
        .a ( i_a11 ),
        .x1 ( i_w1_re ),
        .y1 ( i_w1_im ),
        .out_re ( cmult1_e_re ),
        .out_im ( cmult1_e_im )
    );

    dline #(
        .DATA_WIDTH ( A_WIDTH+W_WIDTH ),
        .DELAY ( 2 )
    ) inst_dline_re (
        .i_clk ( clk ),
        .i_data ( cmult1_e_re ),
        .o_data ( dline_e_re )
    );

    dline #(
        .DATA_WIDTH ( A_WIDTH+W_WIDTH ),
        .DELAY ( 2 )
    ) inst_dline_im (
        .i_clk ( clk ),
        .i_data ( cmult1_e_im ),
        .o_data ( dline_e_im )
    );

    cmult_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( W_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult_b_coupl_m (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_w2_re ),
        .y1 ( i_w2_im ),
        .out_re ( cmult2_e_re ),
        .out_im ( cmult2_e_im )
    );
//****************************************************************

    sum #(
        .A_WIDTH ( A_WIDTH+W_WIDTH ),
        .B_WIDTH ( A_WIDTH+W_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_m_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( dline_e_re ),
        .B ( cmult2_e_re ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_e_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+W_WIDTH ),
        .B_WIDTH ( A_WIDTH+W_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_m_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( dline_e_im ),
        .B ( cmult2_e_im ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_e_im ),
        .underflow (  )
    );

    //****************************************************************

    // assign m_re = cmult2_m_re;
    // assign m_im = cmult2_m_im;
    assign e_re =   sum_e_re;
    assign e_im =   sum_e_im;

endmodule
