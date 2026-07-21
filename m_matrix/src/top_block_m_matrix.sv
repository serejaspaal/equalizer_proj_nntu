module top_block_m_matrix #(
    parameter int    A_WIDTH       = 16,
    parameter int    H_WIDTH       = 16,
    parameter int    M_WIDTH       = A_WIDTH + H_WIDTH + 2,
    parameter int USE_DSP_VALUE    = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [H_WIDTH-1:0] i_h1_re, i_h1_im,
    input  logic signed [H_WIDTH-1:0] i_h2_re, i_h2_im,

    input  logic [A_WIDTH-1:0] i_a22,
    input  logic signed [A_WIDTH-1:0] i_a12_re, i_a12_im,


    output logic signed [M_WIDTH-1:0] m_re, m_im,

    output logic o_sat_m_re, o_sat_m_im
);

    logic sub = 1;

    logic signed [M_WIDTH-1:0] round_m_re, round_m_im;

    logic signed [A_WIDTH+H_WIDTH-1:0] cmult1_m_re, cmult1_m_im;
    logic signed [A_WIDTH+H_WIDTH-1:0] dline_m_re, dline_m_im;

    logic signed [A_WIDTH+H_WIDTH:0] cmult2_m_re, cmult2_m_im;


    logic signed [M_WIDTH-1:0] sum_m_re, sum_m_im;


    cmult_a_real_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .A_SIGNED ( 0 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult_a_real_b_coupl (
        .clk ( clk ),
        .a ( i_a22 ),
        .x1 ( i_h1_re ),
        .y1 ( i_h1_im ),
        .out_re ( cmult1_m_re ),
        .out_im ( cmult1_m_im )
    );

    dline #(
        .DATA_WIDTH ( A_WIDTH+H_WIDTH ),
        .DELAY ( 2 )
    ) inst_dline_re (
        .i_clk ( clk ),
        .i_data ( cmult1_m_re ),
        .o_data ( dline_m_re )
    );

    dline #(
        .DATA_WIDTH ( A_WIDTH+H_WIDTH ),
        .DELAY ( 2 )
    ) inst_dline_im (
        .i_clk ( clk ),
        .i_data ( cmult1_m_im ),
        .o_data ( dline_m_im )
    );

    cmult_b_coupl #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( H_WIDTH ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_cmult_b_coupl_m (
        .clk ( clk ),
        .x0 ( i_a12_re ),
        .y0 ( i_a12_im ),
        .x1 ( i_h2_re ),
        .y1 ( i_h2_im ),
        .out_re ( cmult2_m_re ),
        .out_im ( cmult2_m_im )
    );
//****************************************************************

    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_m_re (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( dline_m_re ),
        .B ( cmult2_m_re ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_m_re ),
        .underflow (  )
    );
    sum #(
        .A_WIDTH ( A_WIDTH+H_WIDTH ),
        .B_WIDTH ( A_WIDTH+H_WIDTH+1 ),
        .SIGNED_OPERANDS ( 1 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_sum_m_im (
        .clk ( clk ),
        .rst ( rst ),
        .valid_in ( 1'b1 ),
        .A ( dline_m_im ),
        .B ( cmult2_m_im ),
        .sub ( sub ),
        .valid_out (  ),
        .S ( sum_m_im ),
        .underflow (  )
    );

    //****************************************************************

    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( M_WIDTH ),
        .IN_SIGNED ( 1 )
    ) inst_round_m_re (
        .clk ( clk ),
        .i_data ( sum_m_re ),
        .o_data ( round_m_re ),
        .o_sat ( o_sat_m_re )
    );

    round #(
        .IN_WIDTH ( M_WIDTH ),
        .OUT_WIDTH ( M_WIDTH ),
        .IN_SIGNED ( 1 )
    ) inst_round_m_im (
        .clk ( clk ),
        .i_data ( sum_m_im ),
        .o_data ( round_m_im ),
        .o_sat ( o_sat_m_im )
    );


    assign m_re = round_m_re;
    assign m_im = round_m_im;

endmodule
