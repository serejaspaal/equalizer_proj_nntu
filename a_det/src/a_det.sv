module a_det #(
    parameter int A_WIDTH       = 16,
    parameter int DET_WIDTH     = 2*A_WIDTH,
    parameter int USE_DSP_VALUE = 1
)(
    input  logic clk,
    input  logic rst,

    input  logic [A_WIDTH-1:0] i_a11, i_a22,
    input  logic [A_WIDTH-1:0] i_a12_re, i_a12_im,

    output logic [DET_WIDTH-1:0] o_det_a,

    output logic o_sat_det,
    output logic sum_underflow
);
    logic [2*A_WIDTH-1:0] mult_result;
    logic [2*A_WIDTH-1:0] dline_result;
    logic [2*A_WIDTH-1:0] cmodule_result;
    logic [2*A_WIDTH:0] sum_result;
    logic [2*A_WIDTH-1:0] sum_result_drop;

    mult #(
        .A_WIDTH ( A_WIDTH ),
        .B_WIDTH ( A_WIDTH ),
        .SIGNED_OPERANDS ( 0 ),
        .USE_DSP_VALUE ( USE_DSP_VALUE )
    ) inst_mult (
        .clk ( clk ),
        .a ( i_a11 ),
        .b ( i_a22 ),
        .result ( mult_result )
    );

    dline #(
        .DATA_WIDTH (2*A_WIDTH),
        .DELAY (1)
    ) inst_dline (
        .i_clk (clk),
        .i_data (mult_result),
        .o_data (dline_result)
    );

    cmodule #(
        .WIDTH (A_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE)
    ) inst_cmodule (
        .clk (clk),
        .rst (rst),
        .valid_in (1'b1),
        .Re (i_a12_re),
        .Im (i_a12_im),
        .valid_out (),
        .MagSq (cmodule_result)
    );

    sum #(
        .A_WIDTH (2*A_WIDTH),
        .B_WIDTH (2*A_WIDTH),
        .USE_DSP_VALUE (USE_DSP_VALUE),
        .SIGNED_OPERANDS (0)
    ) inst_sum (
        .clk (clk),
        .rst (rst),
        .valid_in (1'b1),
        .A (dline_result),
        .B (cmodule_result),
        .sub (1'b1),
        .valid_out (),
        .S (sum_result),
        .underflow ( sum_underflow )
    );

    assign sum_result_drop = sum_result[2*A_WIDTH-1:0];

    round #(
        .IN_WIDTH (2*A_WIDTH),
        .OUT_WIDTH (DET_WIDTH),
        .IN_SIGNED (0)
    ) inst_round (
        .clk (clk),
        .i_data (sum_result_drop),
        .o_data (o_det_a),
        .o_sat (o_sat_det)
    );


endmodule
